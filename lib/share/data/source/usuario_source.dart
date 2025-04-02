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
      dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_KEY']!);

  @override
  Future<void> createUser(UsuarioModel usuario) async {
    try {
      await supabaseClient.from('usuarios').insert(usuario.toJson());
    } catch (e) {
      throw Exception("Error al crear el usuario: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await supabaseClient.from('usuarios').delete().eq('id_usuario', id);
    } catch (e) {
      throw Exception("Error al borrar el usuario: ${e.toString()}");
    }
  }

  @override
  Future<List<UsuarioModel>> getAllUsers() async {
    try {
      final response = await supabaseClient.from('usuarios').select();
      return response.map((json) => UsuarioModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error al obtener usuarios: ${e.toString()}");
    }
  }

  @override
  Future<UsuarioModel?> getUserById(String id) async {
    try {
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
    } catch (e) {
      throw Exception("Error al obtener el usuario: ${e.toString()}");
    }
  }

  @override
  Future<void> updateUser(UsuarioModel usuario) async {
    try {
      await supabaseClient
          .from('usuarios')
          .update(usuario.toJson())
          .eq('id_usuario', usuario.id);
    } catch (e) {
      throw Exception("Error al crear el usuario: ${e.toString()}");
    }
  }
}
