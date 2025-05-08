import 'dart:async';
import 'dart:io';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/share/data/models/vehiculo_model.dart';
import 'package:car_seek/share/data/source/vehiculo_source.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class VehiculoRepositoryImpl implements VehiculoRepository {
  final VehiculoSource vehiculoSource;

  VehiculoRepositoryImpl({required this.vehiculoSource});

  @override
  Future<Either<Failure, Vehiculo>> getVehiculoById(String id) async {
    try {
      final vehiculo = await vehiculoSource.getVehiculoById(id);
      return vehiculo != null
          ? Right(vehiculo)
          : Left(DatabaseFailure(
        customMessage: 'Vehículo no encontrado',
        errorCode: 'vehicle_not_found',
        statusCode: 404,
      ));
    } on FormatException catch (e) {
      return Left(ValidationFailure(
        customMessage: 'Formato de datos inválido: ${e.message}',
        errorCode: 'invalid_data_format',
      ));
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(
        customMessage: 'Error al obtener vehículo: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Vehiculo>>> getAllVehiculos() async {
    try {
      final vehiculos = await vehiculoSource.getAllVehiculos();
      return Right(vehiculos);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener lista de vehículos',
        errorCode: 'vehicle_list_error',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> createVehiculo(Vehiculo vehiculo) async {
    try {
      if (vehiculo.marca.isEmpty || vehiculo.modelo.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'Marca y modelo son requeridos',
          errorCode: 'required_fields_missing',
        ));
      }

      if (vehiculo.anio < 1900 || vehiculo.anio > DateTime.now().year + 1) {
        return Left(ValidationFailure(
          customMessage: 'Año del vehículo no válido',
          errorCode: 'invalid_vehicle_year',
        ));
      }

      await vehiculoSource.createVehiculo(VehiculoModel.fromEntity(vehiculo));
      return const Right(null);
    } on FormatException catch (e) {
      return Left(ValidationFailure(
        customMessage: 'Datos de vehículo inválidos: ${e.message}',
      ));
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al crear vehículo: ${e.toString()}',
        errorCode: 'vehicle_creation_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateVehiculo(Vehiculo vehiculo) async {
    try {
      if (vehiculo.idVehiculo!.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de vehículo requerido',
          errorCode: 'missing_vehicle_id',
        ));
      }

      await vehiculoSource.updateVehiculo(VehiculoModel.fromEntity(vehiculo));
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al actualizar vehículo',
        errorCode: 'vehicle_update_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVehiculo(String id) async {
    try {
      if (id.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de vehículo requerido',
          errorCode: 'missing_vehicle_id',
        ));
      }

      await vehiculoSource.deleteVehiculo(id);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al eliminar vehículo',
        errorCode: 'vehicle_deletion_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Vehiculo>>> getVehiculosDestacados() async {
    try {
      final vehiculos = await vehiculoSource.getAllVehiculos();
      final destacados = vehiculos.where((v) => v.destacado == true).toList();

      if (destacados.isEmpty) {
        return Left(DatabaseFailure(
          customMessage: 'No hay vehículos destacados disponibles',
          errorCode: 'no_featured_vehicles',
          statusCode: 404,
        ));
      }

      return Right(destacados);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener vehículos destacados',
        errorCode: 'featured_vehicles_error',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Vehiculo>>> searchVehiculos(String query) async {
    try {
      if (query.isEmpty || query.length < 3) {
        return Left(ValidationFailure(
          customMessage: 'La búsqueda debe tener al menos 3 caracteres',
          errorCode: 'invalid_search_query',
        ));
      }

      final vehiculos = await vehiculoSource.getAllVehiculos();
      final resultados = vehiculos.where((v) =>
      v.marca.toLowerCase().contains(query.toLowerCase()) ||
          v.modelo.toLowerCase().contains(query.toLowerCase())).toList();

      if (resultados.isEmpty) {
        return Left(DatabaseFailure(
          customMessage: 'No se encontraron vehículos para "$query"',
          errorCode: 'no_vehicles_found',
          statusCode: 404,
        ));
      }

      return Right(resultados);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al buscar vehículos',
        errorCode: 'vehicle_search_error',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Vehiculo>>> getVehiculosFiltrados(String query, FiltroVehiculo? filtro) async {
    try {
      final vehiculos = await vehiculoSource.getAllVehiculos();

      var filtrados = vehiculos.where((v) =>
      v.titulo.toLowerCase().contains(query.toLowerCase()) ||
          v.marca.toLowerCase().contains(query.toLowerCase()) ||
          v.modelo.toLowerCase().contains(query.toLowerCase())
      ).toList();

      if (filtro != null) {
        switch (filtro) {
          case FiltroVehiculo.verificados:
            filtrados = filtrados.where((v) => v.verificado == true).toList();
            break;
          case FiltroVehiculo.precioAsc:
            filtrados.sort((a, b) => a.precio.compareTo(b.precio));
            break;
          case FiltroVehiculo.precioDesc:
            filtrados.sort((a, b) => b.precio.compareTo(a.precio));
            break;
          case FiltroVehiculo.anioAsc:
            filtrados.sort((a, b) => a.anio.compareTo(b.anio));
            break;
          case FiltroVehiculo.anioDesc:
            filtrados.sort((a, b) => b.anio.compareTo(a.anio));
            break;
          case FiltroVehiculo.kilometrosAsc:
            filtrados.sort((a, b) => a.kilometros.compareTo(b.kilometros));
            break;
          default:
            break;
        }
      }

      return Right(filtrados);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener vehículos filtrados: ${e.toString()}',
        errorCode: 'vehicle_filter_error',
      ));
    }
  }

}