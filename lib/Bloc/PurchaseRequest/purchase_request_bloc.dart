import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'purchase_request_event.dart';
part 'purchase_request_state.dart';

class PurchaseRequestBloc
    extends Bloc<PurchaseRequestEvent, PurchaseRequestState> {
  PurchaseRequestBloc() : super(PurchaseRequestInitial()) {

    on<PurchaseRequestEventHandler>((event, emit) async {
      emit(PurchaseRequestLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.allPurchaseRequest;
        final userToken = PrefUtils.getToken();
        developer.log('API userToken: $userToken');

        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromDate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['toDate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factoryName != null && event.factoryName!.isNotEmpty) queryParams['factoryname'] = event.factoryName!;
        // Build final URI safely
        final uri = Uri.parse(
          url,
        ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );
        developer.log('API queryParams: $queryParams');
        developer.log('API URL: $uri');
        developer.log('response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(PurchaseRequestSuccessState(purchaseRequestData: responseData));
        } else {
          emit(
            PurchaseRequestErrorState(
              message:
                  responseData['message'] ??
                  'No records found. Please try adjusting your filters or search.',
            ),
          );
        }
      } catch (e) {
        emit(
          PurchaseRequestErrorState(
            message: 'Oops! Something went wrong. Please try again later.',
          ),
        );
      }
    });


    on<purchaseRequest>((event, emit) async {
      emit(PurchaseRequestLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.allAllPurchase;
        final userToken = PrefUtils.getToken();
        developer.log('API userToken: $userToken');

        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromDate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['toDate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factoryName != null && event.factoryName!.isNotEmpty) queryParams['factoryname'] = event.factoryName!;
        // Build final URI safely
        final uri = Uri.parse(
          url,
        ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );
        developer.log('API queryParams: $queryParams');
        developer.log('API URL: $uri');
        developer.log('response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(PurchaseRequestSuccessState(purchaseRequestData: responseData));
        } else {
          emit(
            PurchaseRequestErrorState(
              message:
                  responseData['message'] ??
                  'No records found. Please try adjusting your filters or search.',
            ),
          );
        }
      } catch (e) {
        emit(
          PurchaseRequestErrorState(
            message: 'Oops! Something went wrong. Please try again later.',
          ),
        );
      }
    });


    /// Approve/Reject Purchase Event
    on<ApproveRejectPurchaseEvent>((event, emit) async {
      emit(PurchaseRequestLoadingState());

      try {
        final url = '${ApiConstants.baseUrl}/api/purchase/updatestatus/${event.purchaseId}';
        final userToken = PrefUtils.getToken();

        developer.log('Approve/Reject API URL: $url');
        developer.log('User Token: $userToken');
        developer.log('Request Body: ${jsonEncode({'status': event.status})}');

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: jsonEncode({'status': event.status}),
        );

        developer.log('Response Status Code: ${response.statusCode}');
        developer.log('Response Body: ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(ApproveRejectPurchaseSuccessState(
            message: 'Purchase request ${event.status.toLowerCase()}d successfully.',
          ));
        } else {
          emit(ApproveRejectPurchaseErrorState(
            message: responseData['message'] ?? 'Failed to ${event.status} purchase request.',
          ));
        }
      } catch (e) {
        developer.log('Exception: $e');
        emit(ApproveRejectPurchaseErrorState(message: 'Something went wrong.'));
      }
    });

  }
}
