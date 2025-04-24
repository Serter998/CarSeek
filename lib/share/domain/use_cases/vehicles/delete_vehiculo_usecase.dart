import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteVehiculoUseCase {
  final VehiculoRepository repository;

  DeleteVehiculoUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteVehiculo(id);
  }
}