import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/repositories/mensaje_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteMensajeUsecase {
  final MensajeRepository repository;

  DeleteMensajeUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteMensaje(id);
  }
}