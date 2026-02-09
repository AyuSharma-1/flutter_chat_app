import 'package:my_chat_app/core/feature/auth/domain/entities/user_entity.dart';
import 'package:my_chat_app/core/feature/auth/domain/repositories/auth_repository.dart';

class RegisterUseCases {
  final AuthRepository repository;

  RegisterUseCases({required this.repository});

  Future<UserEntity> call(String username, String email, String password){
    return repository.register(username, email, password);
  }
}