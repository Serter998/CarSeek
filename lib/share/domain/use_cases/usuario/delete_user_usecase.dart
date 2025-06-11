import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteUserUsecase {
  final UsuarioRepository repository;

  DeleteUserUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteUser(id);
  }
}
