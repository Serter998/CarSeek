import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:dartz/dartz.dart';

abstract class VehiculoRepository {
  Future<Either<Failure, Vehiculo>> getVehiculoById(String id);
  Future<Either<Failure, List<Vehiculo>>> getAllVehiculos();
  Future<Either<Failure, void>> createVehiculo(Vehiculo vehiculo);
  Future<Either<Failure, void>> updateVehiculo(Vehiculo vehiculo);
  Future<Either<Failure, void>> deleteVehiculo(String id);
  Future<Either<Failure, List<Vehiculo>>> getVehiculosDestacados();
  Future<Either<Failure, List<Vehiculo>>> searchVehiculos(String query);
  Future<Either<Failure, List<Vehiculo>>> getVehiculosFiltrados(String query, FiltroVehiculo? filtro);
  Future<Either<Failure, List<Vehiculo>?>> getAllVehiculosByCurrentUser();
  Future<Either<Failure, List<Vehiculo>>> getVehiculosByIds(List<String> ids);
}
