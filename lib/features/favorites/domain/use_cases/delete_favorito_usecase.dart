import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteFavoritoUseCase {
  final FavoriteRepository repository;

  DeleteFavoritoUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteFavorito(id);
  }
}
