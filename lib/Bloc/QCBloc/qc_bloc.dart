import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'qc_event.dart';
part 'qc_state.dart';

class QcBloc extends Bloc<QcEvent, QcState> {
  QcBloc() : super(QcInitial()) {

    on<CreateInitialQcEventHandler>((event, emit) async {
      emit(CreateInitialQcLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.createInitialQC;
        developer.log('url : $url');
        final token = PrefUtils.getToken();
        developer.log('token : $token');

        // Create request body (without "status")
        final body = {
          "initialweight": event.intialWeight,
          "moisture": event.moisture,
          "ricein": event.ricein,
          "huskin": event.huskin,
          "discolor": event.discolor,
          "transportId": event.transportId,
        };

        developer.log('Request Body: $body');

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
        developer.log('response: ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(CreateInitialQcSuccessState(responseData: data));
        } else {
          emit(CreateInitialQcErrorState(message: data['message'] ?? 'Oops! Something went wrong. Please try again later.'));
        }
      } catch (e) {
        developer.log('catchError: ${e.toString()}');
        emit(CreateInitialQcErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ),
        );
      }
    });

    ///Get All QC
    on<GetAllQcEventHandler>((event, emit) async {
      emit(GetAllQcLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.getAllQC;
        developer.log('url: $url');
        final token = PrefUtils.getToken();
        developer.log('token : $token');
        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['toDate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factory != null && event.factory!.isNotEmpty) queryParams['factoryname'] = event.factory!;
        // Build final URI safely
        developer.log('🧾 Query Params: $queryParams');

        final uri = Uri.parse(
          url,
        ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        developer.log('response: ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(GetAllQcSuccessState(responseData: data));
        } else {
          emit(GetAllQcErrorState(message: data['message'] ?? 'Oops! Something went wrong. Please try again later.'));
        }
      } catch (e) {
        developer.log('catchError : ${e.toString()}');
        emit(GetAllQcErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ),
        );
      }
    });

    /// Final QC Submit
    on<SubmitFinalQcEvent>((event, emit) async {
      emit(FinalQcLoadingState());
      try {
        // Correct URL for Final QC submission
        final url = ApiConstants.baseUrl + ApiConstants.submitFinalQC;
        final token = PrefUtils.getToken();
        developer.log('Submitting Final QC to: $url');
        developer.log('Token: $token');

        var request = http.MultipartRequest('POST', Uri.parse(url));

        // Add headers
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        });

        // Add form fields
        request.fields['qcNumber'] = event.qcNumber;
        request.fields['paddyQC'] = jsonEncode(event.paddyQc);
        request.fields['riceQC'] = jsonEncode(event.riceQc);
        request.fields['transportId'] = event.transportId;
        request.fields['finalweight'] = event.finalWeight;

        // Add file if present
        if (event.deliveryProof != null && event.deliveryProof!.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath(
            'deliveryProof',
            event.deliveryProof!.path,
          ));
          developer.log('📎 Delivery proof file added: ${event.deliveryProof!.path}');
        } else {
          developer.log('No delivery proof uploaded.');
        }

        // Send request
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        developer.log('✅ Response: ${response.statusCode} ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(FinalQcSuccessState(responseData));
        } else {
          emit(FinalQcErrorState(
            message: responseData['message'] ?? 'Something went wrong while submitting Final QC.',
          ));
        }
      } catch (e) {
        developer.log('❌ Final QC Submission Error: $e');
        emit(FinalQcErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ));
      }
    });

    ///Update qc status
    on<UpdateQcStatusEvent>((event, emit) async {
      emit(UpdateQcStatusLoadingState());
      try {
        final url = '${ApiConstants.baseUrl}${ApiConstants.updateQcStatus}${event.qcId}';
        developer.log('🟢 URL: $url');
        final token = PrefUtils.getToken();
        developer.log('🪙 Token: $token');

        final body = {
          "status": event.status,
        };
        developer.log('📤 Body: $body');

        final response = await http.patch(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        developer.log('📥 Response: ${response.statusCode} ${response.body}');
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(UpdateQcStatusSuccessState(responseData: data));
        } else {
          emit(UpdateQcStatusErrorState(
            message: data['message'] ?? 'Failed to update status.',
          ));
        }
      } catch (e) {
        developer.log('❌ Update QC Status Error: $e');
        emit(UpdateQcStatusErrorState(
          message: 'Something went wrong. Please try again later.',
        ));
      }
    });

    ///Get Final QC
    on<getFinalQcEventHandler>((event, emit) async {
      emit(getFinalQcLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.getFinalQc;
        developer.log('url: $url');
        final token = PrefUtils.getToken();
        developer.log('token : $token');
        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['toDate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factory != null && event.factory!.isNotEmpty) queryParams['factoryname'] = event.factory!;
        // Build final URI safely
        developer.log('🧾 Query Params: $queryParams');

        final uri = Uri.parse(
          url,
        ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        developer.log('response: ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(getFinalQcSuccessState(responseData: data));
        } else {
          emit(getFinalQcErrorState(message: data['message'] ?? 'Oops! Something went wrong. Please try again later.'));
        }
      } catch (e) {
        developer.log('catchError : ${e.toString()}');
        emit(getFinalQcErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ),
        );
      }
    });

  }
}
