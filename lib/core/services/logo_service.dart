import 'package:supabase_flutter/supabase_flutter.dart';

class LogoService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<String> getLogoUrl() async {
    try {
      final signedUrl = await _supabaseClient.storage
          .from('logocarseek')
          .createSignedUrl('logo0.png', 3600);

      return signedUrl;
    } catch (e) {
      throw Exception('Error al obtener el logo: $e');
    }
  }
}