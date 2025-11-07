import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shree_ram_staff/Constants/ApiConstants.dart';

import '../../utils/pref_utils.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesInitial()) {

    on<GetAllSalesLeadsSuperUserEvent>((event, emit) async {
      emit(SalesLoading());

      try {
        final token = PrefUtils.getToken();
        var queryParams = <String, String>{};
        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromDate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['toDate'] = event.toDate!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;
        if (event.factory != null && event.factory!.isNotEmpty) queryParams['factoryname'] = event.factory!;
        // Build final URI safely
        developer.log('🧾 Query Params: $queryParams');

        final url = ApiConstants.baseUrl + ApiConstants.getAllSalesLeadsForSuperUser;
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

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(SalesSuccess(data));
        } else {
          emit(SalesError('Failed to fetch sales leads. Status: ${response.statusCode}'));
        }
      } catch (e) {
        developer.log('catchError : ${e.toString()}');
        emit(SalesError('Oops! Something went wrong. Please try again later.'));
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
          "factoryname": event.factoryId,
          "finalQCItems": event.finalQCItems,
        });

        developer.log('Creating Sales Lead with body: $body');

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
  }
}
