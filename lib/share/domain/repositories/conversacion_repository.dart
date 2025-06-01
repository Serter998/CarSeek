import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:dartz/dartz.dart';

abstract class ConversacionRepository {
  Future<Either<Failure, List<ConversacionModel>?>> getAllConversacionesByCurrentUser();
  Future<Either<Failure, void>> createConversacion(ConversacionModel conversacion);
  Future<Either<Failure, void>> deleteConversacion(String id);
}