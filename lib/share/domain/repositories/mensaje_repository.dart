import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/data/models/mensaje_model.dart';
import 'package:dartz/dartz.dart';

abstract class MensajeRepository {
  Future<Either<Failure, List<MensajeModel>?>> getAllMensajesByConversacion(String idConversacion);
  Future<Either<Failure, void>> createMensaje(MensajeModel mensaje);
  Future<Either<Failure, void>> updateMensaje(MensajeModel mensaje);
  Future<Either<Failure, void>> deleteMensaje(String id);
}