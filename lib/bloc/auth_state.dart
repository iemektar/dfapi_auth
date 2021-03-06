import 'package:dfapi_auth/models/dfapi_user_info.dart';
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

  @override
  List<Object> get props => [token];
}

class AuthenticationFailed extends AuthState {
  final String message;

  AuthenticationFailed(this.message);

  @override
  List<Object> get props => [message];
}
