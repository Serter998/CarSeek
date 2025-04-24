import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class CreateVehiculoUseCase {
  final VehiculoRepository repository;

  CreateVehiculoUseCase({required this.repository});

  Future<Either<Failure, void>> call(Vehiculo vehiculo) {
    return repository.createVehiculo(vehiculo);
  }
}