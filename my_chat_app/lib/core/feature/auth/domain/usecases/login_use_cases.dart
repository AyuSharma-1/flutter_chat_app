import 'package:my_chat_app/core/feature/auth/domain/entities/user_entity.dart';
import 'package:my_chat_app/core/feature/auth/domain/repositories/auth_repository.dart';

class LoginUseCases {
  final AuthRepository repository;

  LoginUseCases({required this.repository});

  Future<UserEntity> call(String email, String password){
    return repository.login(email, password);
  }
}