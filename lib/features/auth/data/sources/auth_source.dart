import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSource {
  Future<AuthResponse> register(String email, String password);

  Future<AuthResponse> login(String email, String password);

  Future<void> cerrarSesion();

  User? getCurrentUser();

  Future<void> saveCredentials(String email, String password);
  Future<void> deleteCredentials();
  Future<Map<String, String?>> loadCredentials();
}

class AuthSourceImpl implements AuthSource {
  final String _apiKey;

  AuthSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_KEY']!,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<AuthResponse> register(String email, String password) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  @override
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> cerrarSesion() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'remembered_email', value: email);
    await _storage.write(key: 'remembered_password', value: password);
  }

  @override
  Future<void> deleteCredentials() async {
    await _storage.delete(key: 'remembered_email');
    await _storage.delete(key: 'remembered_password');
  }

  @override
  Future<Map<String, String?>> loadCredentials() async {
    final rememberedEmail = await _storage.read(key: 'remembered_email');
    final rememberedPassword = await _storage.read(key: 'remembered_password');
    return {
      'email': rememberedEmail,
      'password': rememberedPassword,
    };
  }
}
