import 'package:car_seek/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../repositories/conversacion_repository.dart';

class DeleteConversacionUsecase {
  final ConversacionRepository repository;

  DeleteConversacionUsecase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteConversacion(id);
  }
}