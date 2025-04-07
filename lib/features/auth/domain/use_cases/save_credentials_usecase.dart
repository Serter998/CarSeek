import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SaveCredentialsUsecase {
  final AuthRepository repository;

  SaveCredentialsUsecase({required this.repository});

  Future<Either<Failure, void>> call(String email, String password) {
    return repository.saveCredentials(email, password);
  }
}
