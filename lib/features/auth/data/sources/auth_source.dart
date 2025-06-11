import 'dart:async';
import 'dart:io';

import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSource {
  Future<AuthResponse> register(String email, String password);
  Future<void> createUser(UsuarioModel usuario);
  Future<AuthResponse> login(String email, String password, bool rememberMe);
  Future<Map<String, String?>> loadCredentials();
  Future<void> resetPassword(String email);
}

class AuthSourceImpl implements AuthSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _apiKey;

  AuthSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<AuthResponse> register(String email, String password) async {
    await _storage.deleteAll();
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> createUser(UsuarioModel usuario) async {
    await supabaseClient.from('usuarios').insert(usuario.toJson());
  }

  @override
  Future<AuthResponse> login(String email, String password, bool rememberMe) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (rememberMe) {
      await _storage.write(key: 'remembered_email', value: email);
      await _storage.write(key: 'remembered_password', value: password);
      await _storage.write(key: 'remember_me', value: 'true');
    } else {
      await _storage.delete(key: 'remembered_email');
      await _storage.delete(key: 'remembered_password');
      await _storage.delete(key: 'remember_me');
    }
    return response;
  }

  @override
  Future<Map<String, String?>> loadCredentials() async {
    final rememberedEmail = await _storage.read(key: 'remembered_email');
    final rememberedPassword = await _storage.read(key: 'remembered_password');
    final rememberMe = await _storage.read(key: 'remember_me');

    return {
      'email': rememberedEmail,
      'password': rememberedPassword,
      'rememberMe': rememberMe,
    };
  }

  @override
  Future<void> resetPassword(String email) async {
    final redirectTo = '${dotenv.env['APP_REDIRECT_URL']}/auth/reset-password';
    await supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }
}
