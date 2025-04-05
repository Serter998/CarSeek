import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSource {
  Future<AuthResponse> register(String email, String password);

  Future<AuthResponse> login(String email, String password);

  Future<void> cerrarSesion();

  User? getCurrentUser();
}

class AuthSourceImpl implements AuthSource {
  final String _apiKey;

  AuthSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_KEY']!,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

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
}
