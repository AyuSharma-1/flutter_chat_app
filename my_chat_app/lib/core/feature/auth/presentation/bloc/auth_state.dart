abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class AuthRegisterSuccess extends AuthSuccess {
  AuthRegisterSuccess({required super.message});
}

class AuthLoginSuccess extends AuthSuccess {
  AuthLoginSuccess({required super.message});
}

class AuthRegisterFailure extends AuthFailure {
  AuthRegisterFailure({required super.error});
}

class AuthLoginFailure extends AuthFailure {
  AuthLoginFailure({required super.error});
}
