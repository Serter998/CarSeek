import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUsuarioUseCase {
  final UsuarioRepository repository;

  GetCurrentUsuarioUseCase({required this.repository});

  Future<Either<Failure, Usuario>> call() {
    return repository.getCurrentUsuario();
  }
}
