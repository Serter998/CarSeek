import 'package:dartz/dartz.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/%20favorites/domain/repositories/favorite_vehicle_repository.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

class GetFavoritesUseCase {
  final FavoriteVehicleRepository repository;

  GetFavoritesUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>>> call() {
    return repository.getFavorites();
  }
}
