import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Constants/ApiConstants.dart';
import '../../utils/pref_utils.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {

    on<FetchProfileEventHandler>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.profile;
        developer.log('url Profile: $url');
        final token = PrefUtils.getToken();

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        developer.log('response Profile: ${response.body}');

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          developer.log('response Profile: $data');
          emit(ProfileSuccessState(responseData: data));
        } else {
          emit(ProfileErrorState(message: data['message'] ?? 'Profile request failed'));
        }
      } catch (e) {
        developer.log('catchErrorProfile: ${e.toString()}');
        emit(ProfileErrorState(
          message: 'Oops! Something went wrong. Please try again later.',
        ),
        );
      }
    });
    
  }
}
