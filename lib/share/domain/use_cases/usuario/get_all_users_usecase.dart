import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUsersUsecase {
  final UsuarioRepository repository;

  GetAllUsersUsecase({required this.repository});

  Future<Either<Failure, List<Usuario>>> call() {
    return repository.getAllUsers();
  }
}