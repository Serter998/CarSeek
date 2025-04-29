import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUserUsecase {
  final UsuarioRepository repository;

  UpdateUserUsecase({required this.repository});

  Future<Either<Failure, void>> call(Usuario usuario) {
    return repository.updateUser(usuario);
  }
}