import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:car_seek/share/domain/repositories/conversacion_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllConversacionesByCurrentUserUseCase {
  final ConversacionRepository repository;

  GetAllConversacionesByCurrentUserUseCase({required this.repository});

  Future<Either<Failure, List<Conversacion>?>> call() {
    return repository.getAllConversacionesByCurrentUser();
  }
}