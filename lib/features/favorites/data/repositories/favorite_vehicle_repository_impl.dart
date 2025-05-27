import 'dart:async';
import 'dart:io';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/features/favorites/data/models/favorito_model.dart';
import 'package:car_seek/features/favorites/data/sources/favorito_source.dart';
import 'package:car_seek/features/favorites/domain/entities/favorito.dart';
import 'package:car_seek/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoritoSource favoritoSource;

  FavoriteRepositoryImpl({required this.favoritoSource});

  @override
  Future<Either<Failure, Favorito>> getFavoritoById(String id) async {
    try {
      final favorito = await favoritoSource.getFavoritoById(id);
      return favorito != null
          ? Right(favorito)
          : Left(DatabaseFailure(
        customMessage: 'Favorito no encontrado',
        errorCode: 'favorito_not_found',
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
        customMessage: 'Error al obtener favorito: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Favorito>>> getAllFavoritos() async {
    try {
      final favoritos = await favoritoSource.getAllFavoritos();
      return Right(favoritos);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener lista de favoritos',
        errorCode: 'favorito_list_error',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Favorito>>> getFavoritosByUserId(String idUsuario) async {
    try {
      final favoritos = await favoritoSource.getFavoritosByUserId(idUsuario);
      return Right(favoritos);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener favoritos del usuario',
        errorCode: 'favorito_user_list_error',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> createFavorito(Favorito favorito) async {
    try {
      if (favorito.idUsuario.isEmpty || favorito.idVehiculo.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID usuario y vehículo son requeridos',
          errorCode: 'required_fields_missing',
        ));
      }

      await favoritoSource.createFavorito(FavoritoModel.fromEntity(favorito));
      return const Right(null);
    } on FormatException catch (e) {
      return Left(ValidationFailure(
        customMessage: 'Datos inválidos: ${e.message}',
      ));
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al crear favorito: ${e.toString()}',
        errorCode: 'favorito_creation_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateFavorito(Favorito favorito) async {
    try {
      if (favorito.idFavorito.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de favorito requerido',
          errorCode: 'missing_favorito_id',
        ));
      }

      await favoritoSource.updateFavorito(FavoritoModel.fromEntity(favorito));
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al actualizar favorito',
        errorCode: 'favorito_update_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFavorito(String id) async {
    try {
      if (id.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de favorito requerido',
          errorCode: 'missing_favorito_id',
        ));
      }

      await favoritoSource.deleteFavorito(id);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al eliminar favorito',
        errorCode: 'favorito_deletion_failed',
      ));
    }
  }
}
