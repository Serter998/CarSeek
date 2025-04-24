import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoadCredentialsUsecase {
  final AuthRepository repository;

  LoadCredentialsUsecase({required this.repository});

  Future<Either<Failure, Map<String, String?>>> call() {
    return repository.loadCredentials();
  }
}
