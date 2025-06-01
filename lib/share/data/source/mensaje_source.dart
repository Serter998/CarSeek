import 'package:car_seek/share/data/models/mensaje_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MensajeSource {
  Future<List<MensajeModel>?> getAllMensajesByConversacion(String idConversacion);
  Future<void> createMensaje(MensajeModel mensaje);
  Future<void> updateMensaje(MensajeModel mensaje);
  Future<void> deleteMensaje(String id);
}

class MensajeSourceImpl implements MensajeSource {
  final String _apiKey;

  MensajeSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<void> createMensaje(MensajeModel mensaje) async {
    await supabaseClient.from('mensajes').insert(mensaje.toJson());
  }

  @override
  Future<void> deleteMensaje(String id) async {
    await supabaseClient.from('mensajes').delete().eq('id', id);
  }

  @override
  Future<void> updateMensaje(MensajeModel mensaje) async {
    await supabaseClient
        .from('mensajes')
        .update(mensaje.toJson())
        .eq('id', mensaje.id!);
  }

  @override
  Future<List<MensajeModel>?> getAllMensajesByConversacion(String idConversacion) async {
    final result = await supabaseClient
        .from('mensajes')
        .select()
        .eq('conversacion_id', idConversacion)
        .order('created_at', ascending: true);

    return result.map((json) => MensajeModel.fromJson(json)).toList();
  }
}