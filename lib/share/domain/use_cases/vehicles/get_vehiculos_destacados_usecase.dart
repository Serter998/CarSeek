import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehiculosDestacadosUseCase {
  final VehiculoRepository repository;

  GetVehiculosDestacadosUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>>> execute() async {
    return await repository.getVehiculosDestacados();
  }
}