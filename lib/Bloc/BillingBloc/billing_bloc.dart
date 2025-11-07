import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shree_ram_staff/Constants/ApiConstants.dart';

import '../../utils/pref_utils.dart';

part 'billing_event.dart';
part 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  BillingBloc() : super(BillingInitialState()) {
    on<GetAllBillingEventHandler>((event, emit) async {
      emit(BillingLoadingState());
      try {
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getBillingData);
        final userToken = PrefUtils.getToken();
        final queryParams = {
          'page': event.page.toString(),
          'limit': event.limit.toString(),
          if (event.fromDate != null) 'fromDate': event.fromDate!,
          if (event.toDate != null) 'toDate': event.toDate!,
          if (event.search != null && event.search!.isNotEmpty)
            'search': event.search!,
          if (event.factoryId != null && event.factoryId!.isNotEmpty)
            'factoryname': event.factoryId!,
          if (event.status != null && event.status!.isNotEmpty)
            'status': event.status!,

        };

        final finalUri = uri.replace(queryParameters: queryParams);
        developer.log("📤 Billing API Request: $finalUri");

        final response = await http.get(
          finalUri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log("📥 Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          emit(BillingSuccessState(data));
        } else {
          emit(BillingErrorState('Failed to load billing data'));
        }
      } catch (e) {
        developer.log("❌ BillingBloc Error: $e");
        emit(BillingErrorState(e.toString()));
      }
    });

    /// Generate Billing
    on<GenerateBillingEvent>((event, emit) async {
      emit(BillingGenerateLoadingState());

      try {
        final url = ApiConstants.baseUrl + ApiConstants.generateBilling;
        final userToken = PrefUtils.getToken();


        developer.log('Generate Billing API userToken: $userToken');

        final body = {
          "finalQCId": event.finalQCId,
          "billingItems": event.billingItems,
          "deductions": event.deductions,
        };
        developer.log('Generate Billing API body: $body');

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: jsonEncode(body),
        );

        developer.log('Generate Billing response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(BillingGenerateSuccessState(billingData: responseData));
        } else {
          emit(BillingGenerateErrorState(
            message: responseData['message'] ?? 'Failed to generate billing.',
          ));
        }
      } catch (e) {
        developer.log('Generate Billing error: $e');
        emit(BillingGenerateErrorState(
          message: 'Something went wrong. Please try again later.',
        ));
      }
    });


  }
}
