import 'package:get_it/get_it.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repository_contracts/auth_repository_contract.dart';
import 'models/dfapi_user_info.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'models/response.dart';

class DfApiAppFunctions {
  static AuthBloc _bloc;
  AuthRepository _repository;

  DfApiAppFunctions(AuthBloc bloc) {
    _bloc = bloc;
    _repository = GetIt.instance<AuthRepositoryContract>();
  }

  void logOut() => _bloc.add(AuthEvent.LoggedOut);

  void logIn() => _bloc.add(AuthEvent.BeforeLogIn);

  Future<Response<DfApiUserInfo>> getUserInfo() async =>
      await _repository.getUserInfo();

  Future<Response<String>> getToken() async => _repository.getToken();

  Future<bool> hasAuthenticated() async => _repository.hasAuthenticated();
}
