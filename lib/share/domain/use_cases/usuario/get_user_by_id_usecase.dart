import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserByIdUsecase {
  final UsuarioRepository repository;

  GetUserByIdUsecase({required this.repository});

  Future<Either<Failure, Usuario>> call(String id) {
    return repository.getUserById(id);
  }
}