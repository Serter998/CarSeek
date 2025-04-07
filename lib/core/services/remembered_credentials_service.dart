import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RememberedCredentialsService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'remembered_email', value: email);
    await _storage.write(key: 'remembered_password', value: password);
  }

  Future<void> deleteCredentials() async {
    await _storage.delete(key: 'remembered_email');
    await _storage.delete(key: 'remembered_password');
  }

  Future<Map<String, String?>> loadCredentials() async {
    final rememberedEmail = await _storage.read(key: 'remembered_email');
    final rememberedPassword = await _storage.read(key: 'remembered_password');
    return {
      'email': rememberedEmail,
      'password': rememberedPassword,
    };
  }
}
