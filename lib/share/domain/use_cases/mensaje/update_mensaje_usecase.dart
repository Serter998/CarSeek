import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/data/models/mensaje_model.dart';
import 'package:car_seek/share/domain/entities/mensaje.dart';
import 'package:car_seek/share/domain/repositories/mensaje_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateMensajeUsecase {
  final MensajeRepository repository;

  UpdateMensajeUsecase({required this.repository});

  Future<Either<Failure, void>> call(Mensaje mensaje) {
    return repository.updateMensaje(MensajeModel.fromEntity(mensaje));
  }
}