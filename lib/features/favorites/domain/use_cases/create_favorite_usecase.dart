import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/favorites/domain/entities/favorito.dart';
import 'package:car_seek/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class CreateFavoritoUseCase {
  final FavoriteRepository repository;

  CreateFavoritoUseCase({required this.repository});

  Future<Either<Failure, void>> call(Favorito favorito) {
    return repository.createFavorito(favorito);
  }
}
