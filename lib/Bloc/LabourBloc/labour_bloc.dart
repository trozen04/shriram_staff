import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'labour_event.dart';
part 'labour_state.dart';

class LabourBloc extends Bloc<LabourEvent, LabourState> {
  LabourBloc() : super(LabourInitialState()) {

    on<GetAllLabourEventHandler>((event, emit) async {
      emit(LabourLoadingState());
      try {
        final userToken = PrefUtils.getToken();
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getAllLabourCharge);

        Map<String, String> queryParams = {};
        if (event.fromDate != null) queryParams['fromdate'] = event.fromDate!;
        if (event.toDate != null) queryParams['todate'] = event.toDate!;
        if (event.search != null && event.search!.isNotEmpty) queryParams['search'] = event.search!;
        if (event.factory != null) queryParams['factoryname'] = event.factory!;
        if (event.status != null && event.status!.isNotEmpty) queryParams['status'] = event.status!;

        final finalUri = queryParams.isNotEmpty ? uri.replace(queryParameters: queryParams) : uri;

        developer.log("📤 Labour API Request: $finalUri");

        final response = await http.get(
          finalUri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log("📥 Labour Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          emit(LabourSuccessState(data['data'] ?? []));
        } else {
          emit(LabourErrorState('Failed to load labour charges'));
        }
      } catch (e) {
        developer.log("❌ LabourBloc Error: $e");
        emit(LabourErrorState('Oops! Something went wrong. Please try again later.'));
      }
    });


    /// Create Labour
    on<CreateLabourEvent>((event, emit) async {
      emit(LabourLoadingState());
      try {
        final userToken = PrefUtils.getToken();
        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.createLabourCharge);
        developer.log("📤 Create Labour Request: $uri");
        developer.log("📤 Create Labour Request: $userToken");

        final body = json.encode({
          "labourItems": event.labourItems,
        });

        developer.log("📤 Create Labour Request: $body");

        final response = await http.post(uri, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        }, body: body);

        developer.log("📥 Response: ${response.statusCode}");
        developer.log(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = json.decode(response.body);
          emit(LabourCreateSuccessState(data));
        } else {
          emit(LabourErrorState('Failed to create labour charges'));
        }
      } catch (e) {
        developer.log("❌ LabourBloc Error: $e");
        emit(LabourErrorState('Oops! Something went wrong. Please try again later.'));
      }
    });

  }
}
