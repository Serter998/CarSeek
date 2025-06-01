import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:car_seek/share/domain/repositories/conversacion_repository.dart';
import 'package:dartz/dartz.dart';

class CreateConversacionUsecase {
  final ConversacionRepository repository;

  CreateConversacionUsecase({required this.repository});

  Future<Either<Failure, void>> call(Conversacion conversacion) {
    return repository.createConversacion(ConversacionModel.fromEntity(conversacion));
  }
}