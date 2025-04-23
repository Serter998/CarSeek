import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase({required this.repository});

  Future<Either<Failure, void>> call(String email) {
    return repository.resetPassword(email);
  }
}
