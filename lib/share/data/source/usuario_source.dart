import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UsuarioSource {
  Future<UsuarioModel?> getUserById(String id);
  Future<List<UsuarioModel>?> getAllUsers();
  Future<void> updateUser(UsuarioModel usuario);
  Future<void> deleteUser(String id);
  Future<void> cerrarSesion();
  Future<User?> getCurrentUser();
  Future<UsuarioModel?> getCurrentUsuario();
}

class UsuarioSourceImpl implements UsuarioSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _apiKey;

  UsuarioSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<void> deleteUser(String id) async {
    await supabaseClient.from('usuarios').delete().eq('id_usuario', id);
    await supabaseClient.auth.admin.deleteUser(id);
  }

  @override
  Future<List<UsuarioModel>?> getAllUsers() async {
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

  @override
  Future<User?> getCurrentUser() async {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> cerrarSesion() async {
    await supabaseClient.auth.signOut();
    await _storage.deleteAll();
  }

  @override
  Future<UsuarioModel?> getCurrentUsuario() async {
    User? user = await getCurrentUser();
    if(user != null) {
      return await getUserById(user.id);
    } else {
      return null;
    }
  }
}
