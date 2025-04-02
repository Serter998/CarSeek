import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, Usuario>> call() {
    return repository.getCurrentUser();
  }
}