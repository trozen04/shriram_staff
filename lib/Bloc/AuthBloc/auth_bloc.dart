import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Constants/ApiConstants.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<LoginRequestEventHandler>((event, emit) async {
      emit(LoginLoading());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.login;
        developer.log('url login: $url');
        final body = {
          'email': event.email,
          'password': event.password,
        };

        developer.log('LoginLoading body:$body');
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        developer.log('response Login: ${response.body}');

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          developer.log('response Login: ${data}');
          emit(LoginSuccess(response: data));
        } else {
          emit(LoginError(message: data['message'] ?? 'Login request failed'));
        }
      } catch (e) {
        developer.log('catchErrorlogin: ${e.toString()}');
        emit(LoginError(
            message: 'Oops! Something went wrong. Please try again later.',
          ),
        );
      }
    });

  }
}
