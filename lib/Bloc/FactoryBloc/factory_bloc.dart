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

  }
}
