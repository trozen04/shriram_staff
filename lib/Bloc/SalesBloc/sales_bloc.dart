import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shree_ram_staff/Constants/ApiConstants.dart';

import '../../utils/pref_utils.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  List<Map<String, String>>? lastReportData;

  SalesBloc() : super(SalesInitial()) {

    on<GetAllSalesLeadsSuperUserEvent>((event, emit) async {
      try {
        final token = PrefUtils.getToken();
        var queryParams = <String, String>{};
        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['todate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factory != null && event.factory!.isNotEmpty) queryParams['factoryname'] = event.factory!;

        // ✅ Add download param
        if (event.isDownload == true) queryParams['download'] = "pdf";

        developer.log('🧾 Query Params: $queryParams');

        final url = ApiConstants.baseUrl + ApiConstants.getAllSalesLeadsForSuperUser;
        developer.log('🧾 url: $url');

        final uri = Uri.parse(url).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        // ✅ Emit Loading only if NOT downloading
        if (event.isDownload == false) {
          emit(SalesLoading());
        }

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        // ✅ Handle PDF download separately
        final contentType = response.headers['content-type'] ?? '';
        if (event.isDownload == true && contentType.contains('application/pdf')) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/sales_leads_superuser.pdf'); // Unique name
          await file.writeAsBytes(bytes);
          await OpenFile.open(file.path);
          return; // Stop execution here
        }

        developer.log('response: ${response.body}');
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          emit(SalesSuccess(data));
        } else {
          emit(SalesError(
            data['message'] ?? 'Failed to fetch sales leads. Status: ${response.statusCode}',
          ));
        }
      } catch (e) {
        developer.log('catchError : ${e.toString()}');
        emit(SalesError('Oops! Something went wrong. Please try again later.'));
      }
    });

    on<GetAllSalesLeadsSubUserEvent>((event, emit) async {
      try {
        final token = PrefUtils.getToken();
        var queryParams = <String, String>{};
        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['todate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;

        // ✅ Add download param
        if (event.isDownload == true) queryParams['download'] = "pdf";

        developer.log('🧾 Query Params: $queryParams');

        String url;
        if (event.isSuperUser == true) {
          url = '${ApiConstants.baseUrl}${ApiConstants.getAllSalesLeadsForSuperUser}';
        } else {
          final factoryId = PrefUtils.getFactoryId();
          url = '${ApiConstants.baseUrl}${ApiConstants.getAllSalesLeadsForSubUser}/$factoryId';
        }
        developer.log('🧾 url: $url');
        final uri = Uri.parse(url).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        // ✅ Emit Loading only if NOT downloading
        if (event.isDownload == false) {
          emit(SalesLoading());
        }

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        // ✅ Handle PDF download separately
        final contentType = response.headers['content-type'] ?? '';
        if (event.isDownload == true && contentType.contains('application/pdf')) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/sales_leads_subuser.pdf'); // Unique name
          await file.writeAsBytes(bytes);
          await OpenFile.open(file.path);
          return; // Stop execution here
        }

        developer.log('response: ${response.body}');
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          emit(SalesSuccess(data));
        } else {
          emit(SalesError(data['message'] ?? 'Failed to fetch sales leads. Status: ${response.statusCode}'));
        }
      } catch (e) {
        developer.log('catchError : ${e.toString()}');
        emit(SalesError('Oops! Something went wrong. Please try again later.'));
      }
    });

    on<GetSalesReportEvent>((event, emit) async {
      // ✅ Bypass cache check if downloading
      // if (event.isDownload == false &&
      //     lastReportData != null &&
      //     event.fromDate == null &&
      //     event.toDate == null &&
      //     (event.factory == null || event.factory!.isEmpty)) {
      //   emit(SalesReportSuccess({'data': lastReportData}));
      //   return;
      // }

      try {
        final token = PrefUtils.getToken();
        final url = '${ApiConstants.baseUrl}/api/saleslead/report';
        var queryParams = <String, String>{};

        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['todate'] = event.toDate!;
        if (event.factory != null && event.factory!.isNotEmpty) queryParams['factoryname'] = event.factory!;
        developer.log('🧾 queryParams: $queryParams');
        // ✅ Add download param
        if (event.isDownload == true) queryParams['download'] = "pdf";
        developer.log('🧾report url: $url');
        final uri = Uri.parse(url).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        // ✅ Emit Loading only if NOT downloading
        if (event.isDownload == false) {
          emit(SalesLoading());
        }

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        // ✅ Handle PDF download separately
        final contentType = response.headers['content-type'] ?? '';
        if (event.isDownload == true && contentType.contains('application/pdf')) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/sales_report.pdf'); // Unique name
          await file.writeAsBytes(bytes);
          await OpenFile.open(file.path);
          return; // Stop execution here
        }

        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          emit(SalesReportSuccess(data));
        } else {
          emit(SalesError(data['message'] ?? 'Failed to fetch sales report. Status: ${response.statusCode}'));
        }
      } catch (e) {
        developer.log('SalesReportError: ${e.toString()}');
        emit(SalesError('Something went wrong while fetching sales report.'));
      }
    });

    on<CreateSalesLeadEvent>((event, emit) async {
      emit(SalesLoading());
      try {
        final token = PrefUtils.getToken();
        final url = ApiConstants.baseUrl + '/api/saleslead/create';
        final body = jsonEncode({
          "customername": event.customerName,
          "phoneno": event.phoneNo,
          "address": event.address,
          "city": event.city,
          "factory": event.factoryId,
          "items": event.finalQCItems,
        });

        developer.log('Creating Sales Lead with body: $body');
        developer.log('Creating Sales Lead with url: $url');

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );

        developer.log('Create Response: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          emit(SalesCreateSuccess(data));
        } else {
          emit(SalesError('Failed to create sales lead. Status: ${response.statusCode}'));
        }
      } catch (e) {
        developer.log('CreateSalesLeadError: ${e.toString()}');
        emit(SalesError('Something went wrong while creating sales lead.'));
      }
    });

    on<UpsertLoadingEvent>((event, emit) async {
      emit(SalesLoading());
      try {
        final token = PrefUtils.getToken();
        final url = ApiConstants.baseUrl + ApiConstants.loadProducts;

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $token';

        // 🧾 Add only non-null/non-empty normal fields
        void addField(String key, String? value) {
          if (value != null && value.trim().isNotEmpty) {
            request.fields[key] = value;
          }
        }

        addField('salesleadId', event.salesLeadId);
        addField('drivername', event.driverName);
        addField('phoneno', event.phoneNo);
        addField('ownername', event.ownerName);
        addField('ownerphoneno', event.ownerPhoneNo);
        addField('initialweight', event.initialWeight);
        addField('finalweight', event.finalWeight);

        // 🖼️ Add image files if provided
        if (event.adharCard != null) {
          request.files.add(await http.MultipartFile.fromPath('adharcard', event.adharCard!.path));
        }
        if (event.driverLicence != null) {
          request.files.add(await http.MultipartFile.fromPath('driverlicence', event.driverLicence!.path));
        }
        if (event.vehicleRC != null) {
          request.files.add(await http.MultipartFile.fromPath('vehiclerc', event.vehicleRC!.path));
        }
        if (event.deliveryProof != null) {
          request.files.add(await http.MultipartFile.fromPath('deliveryproof', event.deliveryProof!.path));
        }

        developer.log('📦 Uploading loading data: ${request.fields}');
        developer.log('📤 Files count: ${request.files.length}');

        // Send request
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        developer.log('Loading Upsert Response: ${response.body}');
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(SalesLoadingUpsertSuccess(data: data, isSave: event.isSave ?? false));
        } else {
          emit(SalesError(data['message'] ?? 'Failed to load product.'));
        }
      } catch (e) {
        developer.log('LoadingUpsertError: ${e.toString()}');
        emit(SalesError('Something went wrong while uploading loading data.'));
      }
    });

    on<AcceptSalesLeadEvent>((event, emit) async {
      emit(AcceptSalesLeadLoading());

      try {
        final token = PrefUtils.getToken();
        final url = '${ApiConstants.baseUrl}/api/saleslead/acceptlead/${event.leadId}';

        developer.log('Accepting lead: $url');
        developer.log('Accepting lead: $token');

        final response = await http.patch(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({}),
        );

        developer.log('AcceptLead Response: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          emit(AcceptSalesLeadSuccess(data));
        } else {
          final data = jsonDecode(response.body);
          emit(AcceptSalesLeadError(data['message'] ?? 'Failed to accept lead.'));
        }
      } catch (e) {
        developer.log('AcceptLeadError: ${e.toString()}');
        emit(AcceptSalesLeadError('Something went wrong while accepting the lead.'));
      }
    });

  }
}
