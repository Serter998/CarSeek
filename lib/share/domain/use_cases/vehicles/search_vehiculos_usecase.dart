import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class SearchVehiculosUseCase {
  final VehiculoRepository repository;

  SearchVehiculosUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>>> execute(String query) async {
    return await repository.searchVehiculos(query);
  }
}