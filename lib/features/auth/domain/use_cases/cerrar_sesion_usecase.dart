import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CerrarSesionUseCase {
  final AuthRepository repository;

  CerrarSesionUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.cerrarSesion();
  }
}
