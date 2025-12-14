import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final storage = FlutterSecureStorage();

  static Future<void> write(String key, String value) =>
      storage.write(key: key, value: value);

  static Future<String?> read(String key) => storage.read(key: key);
}
