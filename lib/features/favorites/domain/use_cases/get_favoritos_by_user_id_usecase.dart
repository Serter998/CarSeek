import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/favorites/domain/entities/favorito.dart';
import 'package:car_seek/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class GetFavoritosByUserIdUseCase {
  final FavoriteRepository repository;

  GetFavoritosByUserIdUseCase({required this.repository});

  Future<Either<Failure, List<Favorito>>> call(String idUsuario) {
    return repository.getFavoritosByUserId(idUsuario);
  }
}
