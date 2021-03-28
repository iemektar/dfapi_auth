import 'package:dfapi_auth/data/repository_contracts/auth_repository_contract.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryContract _authRepository;
  AuthBloc(this._authRepository) : super(UnInitialized());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield Loading(true);
      if (!GetIt.I.isRegistered<SharedPreferences>()) {
        var pref = await SharedPreferences.getInstance();
        GetIt.I.registerLazySingleton<SharedPreferences>(() => pref);
      }

      var authDataResponse = _authRepository.getAuthData();

      if (!authDataResponse.isSuccess)
        yield UnAuthenticated();
      else
        yield Authenticated.fromResponse(authDataResponse);
    } else if (event is LogIn) {
      yield Loading(false);
      var response = await _authRepository.authenticate(event.model);

      if (response.isSuccess)
        yield Authenticated.fromResponse(response);
      else
        yield Failed(response.errorMessage);
    } else {
      yield Loading(false);
      var response = await _authRepository.logOut();
      if (response.isSuccess)
        yield UnAuthenticated();
      else
        yield Failed(response.errorMessage);
    }
  }
}
