import 'package:dfapi_auth/models/authentication_response.dart';
import 'package:dfapi_auth/models/dfapi_user_info.dart';
import 'package:dfapi_auth/models/response.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class UnInitialized extends AuthState {}

class Loading extends AuthState {
  final bool showSplash;

  Loading(this.showSplash);

  @override
  List<Object> get props => [showSplash];
}

class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final DfApiUserInfo userInfo;

  Authenticated(this.token, this.userInfo);

  Authenticated.fromResponse(Response<AuthenticationResponse> response)
      : token = response.value.token,
        userInfo = response.value.userInfo;

  @override
  List<Object> get props => [token];
}

class Failed extends AuthState {
  final String message;

  Failed(this.message);

  @override
  List<Object> get props => [message];
}
