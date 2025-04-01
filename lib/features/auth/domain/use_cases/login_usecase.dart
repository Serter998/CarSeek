import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
