import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteOtherUserUsecase {
  final UsuarioRepository repository;

  DeleteOtherUserUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteOtherUser(id);
  }
}
