import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:car_seek/features/auth/data/models/user_model.dart';

abstract class AuthSource {
  Future<UserModel> register(String email, String password);
  Future<UserModel> login(String email, String password);
}

class AuthSourceImpl implements AuthSource {

  final String apiKey;

  AuthSourceImpl(this.apiKey);

  void authenticate() {
    print("Using API key: $apiKey");
  }

  final SupabaseClient supabaseClient = SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_KEY']!);

  Future<UserModel> register(String email, String password) async {
    final response = await supabaseClient.auth.signUp(email: email, password: password);

    return UserModel(id: response.user!.id, email: email);
  }

  Future<UserModel> login(String email, String password) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return UserModel(id: response.user!.id, email: email);
  }
}
