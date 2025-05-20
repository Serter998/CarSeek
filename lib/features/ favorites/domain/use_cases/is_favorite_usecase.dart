import 'package:dartz/dartz.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/%20favorites/domain/repositories/favorite_vehicle_repository.dart';

class IsFavoriteUseCase {
  final FavoriteVehicleRepository repository;
  IsFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String id) {
    return repository.isFavorite(id);
  }
}
