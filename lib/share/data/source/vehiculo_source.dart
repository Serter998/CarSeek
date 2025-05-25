import 'package:car_seek/share/data/models/vehiculo_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VehiculoSource {
  Future<VehiculoModel?> getVehiculoById(String id);

  Future<List<VehiculoModel>> getAllVehiculos();
  
  Future<List<VehiculoModel>?> getAllVehiculosByCurrentUser();

  Future<void> createVehiculo(VehiculoModel vehiculo);

  Future<void> updateVehiculo(VehiculoModel vehiculo);

  Future<void> deleteVehiculo(String id);
}

class VehiculoSourceImpl implements VehiculoSource {
  final String _apiKey;

  VehiculoSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<void> createVehiculo(VehiculoModel vehiculo) async {
    await supabaseClient.from('vehiculos').insert(vehiculo.toJson());
  }

  @override
  Future<void> deleteVehiculo(String id) async {
    await supabaseClient.from('vehiculos').delete().eq('id_vehiculo', id);
  }

  @override
  Future<List<VehiculoModel>> getAllVehiculos() async {
    try {
      final List<dynamic> result = await supabaseClient
          .from('vehiculos')
          .select();

      return result.map((json) => VehiculoModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('❌ Error al obtener vehículos: $e');
      print('📍 StackTrace: $stackTrace');
      rethrow; // Esto relanza el error para que puedas manejarlo arriba si quieres
    }
  }

  @override
  Future<VehiculoModel?> getVehiculoById(String id) async {
    final response = await supabaseClient
        .from('vehiculos')
        .select()
        .eq('id_vehiculo', id)
        .maybeSingle();

    if (response != null) {
      return VehiculoModel.fromJson(response);
    }
    return null;
  }

  @override
  Future<void> updateVehiculo(VehiculoModel vehiculo) async {
    await supabaseClient
        .from('vehiculos')
        .update(vehiculo.toJson())
        .eq('id_vehiculo', vehiculo.idVehiculo!);
  }

  @override
  Future<List<VehiculoModel>?> getAllVehiculosByCurrentUser() async {
    String? idUsuario = supabaseClient.auth.currentUser!.id;
    if(idUsuario.isEmpty) {
      throw Exception("No se ha iniciado sesión.");
    }
    final List<dynamic> result = await supabaseClient
        .from('vehiculos')
        .select()
        .eq('id_usuario', idUsuario);

    return result.map((json) => VehiculoModel.fromJson(json)).toList();
  }
}
