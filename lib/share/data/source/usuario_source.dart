import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UsuarioSource {
  Future<UsuarioModel?> getUserById(String id);

  Future<List<UsuarioModel>> getAllUsers();

  Future<void> createUser(UsuarioModel usuario);

  Future<void> updateUser(UsuarioModel usuario);

  Future<void> deleteUser(String id);
}

class UsuarioSourceImpl implements UsuarioSource {
  final String _apiKey;

  UsuarioSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_KEY']!,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  @override
  Future<void> createUser(UsuarioModel usuario) async {
    await supabaseClient.from('usuarios').insert(usuario.toJson());
  }

  @override
  Future<void> deleteUser(String id) async {
    await supabaseClient.from('usuarios').delete().eq('id_usuario', id);
    await supabaseClient.auth.admin.deleteUser(id);
  }

  @override
  Future<List<UsuarioModel>> getAllUsers() async {
    final response = await supabaseClient.from('usuarios').select();
    return response.map((json) => UsuarioModel.fromJson(json)).toList();
  }

  @override
  Future<UsuarioModel?> getUserById(String id) async {
    final response =
        await supabaseClient
            .from('usuarios')
            .select()
            .eq('id_usuario', id)
            .maybeSingle();

    if (response != null) {
      return UsuarioModel.fromJson(response);
    }
    return null;
  }

  @override
  Future<void> updateUser(UsuarioModel usuario) async {
    await supabaseClient
        .from('usuarios')
        .update(usuario.toJson())
        .eq('id_usuario', usuario.id);
  }
}
