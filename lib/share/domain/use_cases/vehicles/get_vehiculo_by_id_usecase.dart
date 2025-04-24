import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehiculoByIdUseCase {
  final VehiculoRepository repository;

  GetVehiculoByIdUseCase({required this.repository});

  Future<Either<Failure, Vehiculo>> call(String id) {
    return repository.getVehiculoById(id);
  }
}