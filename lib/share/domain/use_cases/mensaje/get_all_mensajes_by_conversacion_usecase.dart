import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/mensaje.dart';
import 'package:car_seek/share/domain/repositories/mensaje_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllMensajesByConversacionUsecase {
  final MensajeRepository repository;

  GetAllMensajesByConversacionUsecase({required this.repository});

  Future<Either<Failure, List<Mensaje>?>> call(String idConversacion) {
    return repository.getAllMensajesByConversacion(idConversacion);
  }
}