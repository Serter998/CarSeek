import 'package:car_seek/share/data/models/vehiculo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VehiculoSource {
  Future<VehiculoModel?> getVehiculoById(String id);

  Future<List<VehiculoModel>> getAllVehiculos();

  Future<void> createVehiculo(VehiculoModel vehiculo);

  Future<void> updateVehiculo(VehiculoModel vehiculo);

  Future<void> deleteVehiculo(String id);
}

class VehiculoSourceImpl implements VehiculoSource {
  final String _apiKey;

  VehiculoSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_KEY']!,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

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
    final response = await supabaseClient.from('vehiculos').select();
    return response.map((json) => VehiculoModel.fromJson(json)).toList();
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
        .eq('id_vehiculo', vehiculo.idVehiculo);
  }
}
