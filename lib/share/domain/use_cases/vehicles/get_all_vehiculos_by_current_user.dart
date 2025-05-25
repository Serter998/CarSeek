import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllVehiculosByCurrentUserUseCase {
  final VehiculoRepository repository;

  GetAllVehiculosByCurrentUserUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>?>> call() {
    return repository.getAllVehiculosByCurrentUser();
  }
}