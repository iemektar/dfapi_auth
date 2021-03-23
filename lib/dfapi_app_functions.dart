import 'package:dfapi_auth/bloc/auth_event.dart';
import 'package:get_it/get_it.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repository_contracts/auth_repository_contract.dart';

import 'bloc/auth_bloc.dart';

class DfApiAppFunctions {
  static AuthBloc _bloc;
  AuthRepository _repository;

  DfApiAppFunctions(AuthBloc bloc) {
    _bloc = bloc;
    _repository = GetIt.instance<AuthRepositoryContract>();
  }

  void logOut() => _bloc.add(LogOut());

  void logIn(String username, String password) =>
      _bloc.add(LogIn(username, password));
}
