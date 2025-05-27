import 'package:car_seek/features/favorites/data/models/favorito_model.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FavoritoSource {
  Future<FavoritoModel?> getFavoritoById(String id);

  Future<List<FavoritoModel>> getAllFavoritos();

  Future<List<FavoritoModel>> getFavoritosByUserId(String idUsuario);

  Future<void> createFavorito(FavoritoModel favorito);

  Future<void> updateFavorito(FavoritoModel favorito);

  Future<void> deleteFavorito(String id);

}


class FavoritoSourceImpl implements FavoritoSource {
  final String _apiKey;

  FavoritoSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<void> createFavorito(FavoritoModel favorito) async {
    await supabaseClient.from('favoritos').insert(favorito.toJson());
  }

  @override
  Future<void> deleteFavorito(String id) async {
    await supabaseClient.from('favoritos').delete().eq('id_favorito', id);
  }

  @override
  Future<List<FavoritoModel>> getAllFavoritos() async {
    try {
      final List<dynamic> result = await supabaseClient.from('favoritos').select();

      return result.map((json) => FavoritoModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('❌ Error al obtener favoritos: $e');
      print('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<FavoritoModel?> getFavoritoById(String id) async {
    final response = await supabaseClient
        .from('favoritos')
        .select()
        .eq('id_favorito', id)
        .maybeSingle();

    if (response != null) {
      return FavoritoModel.fromJson(response);
    }
    return null;
  }

  @override
  Future<void> updateFavorito(FavoritoModel favorito) async {
    await supabaseClient
        .from('favoritos')
        .update(favorito.toJson())
        .eq('id_favorito', favorito.idFavorito);
  }

  @override
  Future<List<FavoritoModel>> getFavoritosByUserId(String idUsuario) async {
    try {
      final List<dynamic> result = await supabaseClient
          .from('favoritos')
          .select()
          .eq('id_usuario', idUsuario);

      return result.map((json) => FavoritoModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('❌ Error al obtener favoritos del usuario: $e');
      print('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
