import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'broker_event.dart';
part 'broker_state.dart';

class BrokerBloc extends Bloc<BrokerEvent, BrokerState> {
  BrokerBloc() : super(BrokerInitialState()) {

    on<GetAllBrokerEventHandler>((event, emit) async {
      emit(BrokerLoadingState());

      try {
        final url = ApiConstants.baseUrl + ApiConstants.getAllBroker;
        final token = PrefUtils.getToken();
        final queryParams = <String, String>{};

        if (event.page != null) queryParams['page'] = event.page.toString();
        if (event.limit != null) queryParams['limit'] = event.limit.toString();
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.fromDate != null && event.fromDate!.isNotEmpty) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null && event.toDate!.isNotEmpty) queryParams['todate'] = event.toDate!;
        if (event.factoryName != null && event.factoryName!.isNotEmpty) queryParams['factoryname'] = event.factoryName!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;

        // Build URI safely with query parameters
        final uri = Uri.parse(url).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

        developer.log('Broker API queryParams: $queryParams');
        developer.log('Broker API URL: $uri');

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        developer.log('Broker API response: ${response.statusCode}\n${response.body}');

        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(BrokerSuccessState(brokerData: responseData['brokers'] ?? []));
        } else {
          emit(BrokerErrorState(
            message: responseData['message'] ??
                'No records found. Please try adjusting your filters or search.',
          ));
        }
      } catch (e) {
        emit(BrokerErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ));
      }
    });



    on<ApproveRejectBrokerEvent>((event, emit) async {
      emit(BrokerApprovalLoadingState());

      try {
        final url = '${ApiConstants.baseUrl}/api/broker/approval/${event.brokerId}';
        final token = PrefUtils.getToken();

        final response = await http.patch(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'status': event.status}),
        );

        developer.log('Approve/Reject response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          emit(BrokerApprovalSuccessState(message: 'Broker ${event.status}d successfully'));
        } else {
          emit(BrokerApprovalErrorState(
              message: responseData['message'] ?? 'Failed to update status'));
        }
      } catch (e) {
        emit(BrokerApprovalErrorState(message: 'Oops! Something went wrong. Please try again later.'));
      }
    });


  }
}
