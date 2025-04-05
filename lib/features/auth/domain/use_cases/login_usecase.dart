import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, Usuario>> call(String email, String password) {
    return repository.login(email, password);
  }
}