import 'package:dfapi_auth/bloc/auth_event.dart';
import 'package:dfapi_auth/models/login_model.dart';

import 'bloc/auth_bloc.dart';

class DfApiAppFunctions {
  static AuthBloc _bloc;
  // AuthRepository _repository;

  DfApiAppFunctions(AuthBloc bloc) {
    _bloc = bloc;
    // _repository = GetIt.instance<AuthRepositoryContract>();
  }

  void logOut() => _bloc.add(LogOut());

  void logIn(String username, String password) =>
      _bloc.add(LogIn(LoginModel(username, password)));
}
