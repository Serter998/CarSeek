import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehiculosFiltradosUseCase {
  final VehiculoRepository repository;

  GetVehiculosFiltradosUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>>> call({String query = '', FiltroVehiculo? filtro}) async {
    final result = await repository.getVehiculosFiltrados(query, filtro);
    return result;
  }
}
