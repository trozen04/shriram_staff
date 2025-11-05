import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'subusers_event.dart';
part 'subusers_state.dart';

class SubusersBloc extends Bloc<SubusersEvent, SubusersState> {
  SubusersBloc() : super(SubusersInitial()) {

    /// Fetch Subusers with pagination, search, and factory filter
    on<SubUsersFetchEvent>((event, emit) async {
      emit(SubusersLoadingState());

      try {
        final url = ApiConstants.baseUrl + ApiConstants.getSubUser;
        final userToken = PrefUtils.getToken(); // make sure this is async
        developer.log('Fetch Subusers API userToken: $userToken');

        // Build query parameters
        Map<String, String> queryParams = {
          'page': (event.page ?? 1).toString(), // default page 1
          'limit': (event.limit ?? 20).toString(), // default 20 per page
        };

        if (event.search != null && event.search!.isNotEmpty) {
          queryParams['search'] = event.search!;
        }

        if (event.factoryId != null && event.factoryId!.isNotEmpty) {
          queryParams['factory'] = event.factoryId!;
        }

        final uri = Uri.parse(url).replace(queryParameters: queryParams);

        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        );

        developer.log('Fetch Subusers response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(SubusersSuccessState(subusersData: responseData));
        } else {
          emit(SubusersErrorState(
            message: responseData['message'] ?? 'Failed to fetch subusers.',
          ));
        }
      } catch (e) {
        developer.log('Fetch Subusers error: $e');
        emit(SubusersErrorState(
          message: 'Something went wrong. Please try again later.',
        ));
      }
    });


    /// Create Subuser
    on<SubusersCreateEvent>((event, emit) async {
      emit(SubusersLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.createSubUser;
        final userToken = PrefUtils.getToken();
        developer.log('Create Subuser API userToken: $userToken');
        final body = {
          "name": event.name,
          "mobileno": event.mobileNo,
          "role": event.role,
          "authority": event.authority,
          "salary": event.salary,
          "factory": event.factoryId,
          "address": event.address,
          "password": event.password,
          "confirmPassword": event.confirmPassword,
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: jsonEncode(body),
        );

        developer.log('Create Subuser response: ${response.statusCode}\n${response.body}');
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(SubusersCreateSuccessState(createdData: responseData));
        } else {
          emit(SubusersErrorState(
            message: responseData['message'] ?? 'Failed to create subuser.',
          ));
        }
      } catch (e) {
        developer.log('Create Subuser error: $e');
        emit(SubusersErrorState(
          message: 'Something went wrong. Please try again later.',
        ));
      }
    });

  }
}
