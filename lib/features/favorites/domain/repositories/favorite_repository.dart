import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/favorites/domain/entities/favorito.dart';
import 'package:dartz/dartz.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, Favorito>> getFavoritoById(String id);
  Future<Either<Failure, List<Favorito>>> getAllFavoritos();
  Future<Either<Failure, List<Favorito>>> getFavoritosByUserId(String idUsuario);
  Future<Either<Failure, void>> createFavorito(Favorito favorito);
  Future<Either<Failure, void>> updateFavorito(Favorito favorito);
  Future<Either<Failure, void>> deleteFavorito(String id);
}
