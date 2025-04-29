import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateVehiculoUseCase {
  final VehiculoRepository repository;

  UpdateVehiculoUseCase({required this.repository});

  Future<Either<Failure, void>> call(Vehiculo vehiculo) {
    return repository.updateVehiculo(vehiculo);
  }
}