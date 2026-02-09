import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_chat_app/core/feature/auth/domain/usecases/login_use_cases.dart';
import 'package:my_chat_app/core/feature/auth/domain/usecases/register_use_cases.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_event.dart';
import 'package:my_chat_app/core/feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = const FlutterSecureStorage();
  final RegisterUseCases registerUseCase;
  final LoginUseCases loginUseCase;
  AuthBloc({required this.registerUseCase, required this.loginUseCase})
    : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  String _errorMessage(Object error, String fallback) {
    final text = error.toString();
    const prefix = 'Exception: ';
    if (text.startsWith(prefix)) {
      final message = text.substring(prefix.length).trim();
      return message.isEmpty ? fallback : message;
    }
    return fallback;
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.call(
        event.username,
        event.email,
        event.password,
      );
      emit(AuthRegisterSuccess(message: 'User registered successfully'));
    } catch (e) {
      emit(AuthRegisterFailure(error: _errorMessage(e, 'Registration Failed')));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      emit(AuthLoginSuccess(message: 'User logged in successfully'));
    } catch (e) {
      emit(AuthLoginFailure(error: _errorMessage(e, 'User Failed to login')));
    }
  }
}
