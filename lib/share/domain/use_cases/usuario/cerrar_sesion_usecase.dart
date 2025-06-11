import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class CerrarSesionUseCase {
  final UsuarioRepository repository;

  CerrarSesionUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.cerrarSesion();
  }
}
