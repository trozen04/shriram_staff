import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'factory_event.dart';
part 'factory_state.dart';

class FactoryBloc extends Bloc<FactoryEvent, FactoryState> {
  FactoryBloc() : super(FactoryInitial()) {

    on<FactoryEventHandler>((event, emit) async {
      emit(FactoryLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.getAllFactory;
        final userToken = PrefUtils.getToken();
        //developer.log('Factory API userToken: $userToken');

        final uri = Uri.parse(url);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        // developer.log('Factory API URL: $uri');
        // developer.log('Factory API response: ${response.statusCode}\n${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(FactorySuccessState(factoryData: responseData));
        } else {
          emit(
            FactoryErrorState(
              message: responseData['message'] ?? 'Failed to fetch factories.',
            ),
          );
        }
      } catch (e) {
        developer.log('Factory API error: $e');
        emit(
          FactoryErrorState(
            message: 'Oops! Something went wrong. Please try again later.',
          ),
        );
      }
    });

    /// Insert / Update factory inventory
    on<InsertFactoryInventoryEvent>((event, emit) async {
      emit(FactoryLoadingState());
      try {
        final factoryId = PrefUtils.getFactoryId();
        final token = PrefUtils.getToken();
        final url = '${ApiConstants.baseUrl}/api/factoryinventory/insert/${factoryId}';
        final uri = Uri.parse(url);

        developer.log('Inserting inventory for factory ${factoryId}');
        developer.log('Inventory Data: ${event.inventoryData}');

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(event.inventoryData),
        );

        final data = jsonDecode(response.body);
        developer.log('Insert Inventory Response: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(FactoryInventorySuccessState(responseData: data));
        } else {
          emit(FactoryErrorState(
            message: data['message'] ?? 'Failed to insert inventory.',
          ));
        }
      } catch (e) {
        developer.log('InsertInventoryError: $e');
        emit(FactoryErrorState(
          message: 'Something went wrong while inserting inventory.',
        ));
      }
    });

  }
}
