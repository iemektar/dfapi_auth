import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({@required this.authRepository}) : super(UnInitialized());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    switch (event) {
      case AuthEvent.AppStarted:
        yield Loading(true);
        var hasAuthenticated = await authRepository.hasAuthenticated();
        if (hasAuthenticated) {
          var hasTokenExpired = await authRepository.hasTokenExpired();
          if (hasTokenExpired)
            add(AuthEvent.BeforeLogIn);
          else {
            var token = await authRepository.getToken();
            var userInfo = await authRepository.getUserInfo();

            if (!token.isSuccess || !userInfo.isSuccess)
              yield AuthenticationFailed("Auth data has corrupted.");
            else
              yield Authenticated(token.value, userInfo.value);
          }
        } else
          yield UnAuthenticated();
        break;

      case AuthEvent.BeforeLogIn:
        yield Loading(false);
        var response = await authRepository.authenticate();
        if (response.isSuccess)
          yield Authenticated(response.value.token, response.value.userInfo);
        else
          yield AuthenticationFailed(response.errorMessage);
        break;

      case AuthEvent.LoggedOut:
        yield Loading(false);
        await authRepository.logOut();
        yield UnAuthenticated();
        break;

      default:
        yield UnInitialized();
        break;
    }
  }
}
