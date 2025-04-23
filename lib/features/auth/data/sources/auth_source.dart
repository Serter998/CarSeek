import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String email, String password, bool rememberMe);
  Future<void> cerrarSesion();
  User? getCurrentUser();
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
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
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
    } else {
      await _storage.delete(key: 'remembered_email');
      await _storage.delete(key: 'remembered_password');
    }
    return response;
  }

  @override
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> cerrarSesion() async {
    await supabaseClient.auth.signOut();
    await _storage.deleteAll();
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

  @override
  Future<void> resetPassword(String email) async {
    final redirectTo = '${dotenv.env['APP_REDIRECT_URL']}/auth/reset-password';
    await supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }
}
