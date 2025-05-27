import 'package:car_seek/features/favorites/domain/entities/favorito.dart';

class FavoritoModel extends Favorito{
  FavoritoModel({
    required super.idFavorito,
    required super.idUsuario,
    required super.idVehiculo,
    required super.createdAt,
  });

  factory FavoritoModel.fromJson(Map<String, dynamic> json) {
    return FavoritoModel(
      idFavorito: json['id_favorito'],
      idUsuario: json['id_usuario'],
      idVehiculo: json['id_vehiculo'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id_usuario': idUsuario,
      'id_vehiculo': idVehiculo,
      'created_at': createdAt.toIso8601String(),
    };

    if (idFavorito != null && idFavorito.isNotEmpty) {
      data['id_favorito'] = idFavorito;
    }

    return data;
  }


  factory FavoritoModel.fromEntity(Favorito favorito) {
    return FavoritoModel(
        idFavorito: favorito.idFavorito,
        idUsuario: favorito.idUsuario,
        idVehiculo: favorito.idVehiculo,
        createdAt: favorito.createdAt);
  }
}