import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:car_seek/share/data/models/usuario_model.dart';

abstract class AuthSource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String email, String password);
  Future<void> cerrarSesion();
  User? getCurrentUser();
}

class AuthSourceImpl implements AuthSource {
  final String _apiKey;

  AuthSourceImpl(this._apiKey);

  /*void authenticate() {
    print("Using API key: $apiKey");
  }*/

  final SupabaseClient supabaseClient = SupabaseClient(
      dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_KEY']!);

  Future<AuthResponse> register(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signUp(
          email: email, password: password);
      return response;
    } catch (e) {
      throw Exception("Error en el registro: ${e.toString()}");
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
          email: email, password: password);
      return response;
    } catch (e) {
      throw Exception("Error al iniciar sesión: ${e.toString()}");
    }
  }

  @override
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception("Error al cerrar sesión: ${e.toString()}");
    }
  }
}
