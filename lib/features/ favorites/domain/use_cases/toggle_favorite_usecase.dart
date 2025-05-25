import 'package:car_seek/features/%20favorites/domain/repositories/favorite_vehicle_repository.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

class ToggleFavoriteUseCase {
  final FavoriteVehicleRepository repository;
  ToggleFavoriteUseCase({required this.repository});

  Future<void> call(Vehiculo vehiculo) => repository.toggleFavorite(vehiculo);
}
