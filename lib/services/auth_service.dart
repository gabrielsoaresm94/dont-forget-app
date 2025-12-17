import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../utils/secure_storage.dart';

class AuthService {
  static const tokenKey = 'jwt_token';
  static const expiresKey = 'jwt_expires';

  final String secret;

  AuthService(this.secret);

  Future<String> getValidToken(String uuid) async {
    final savedToken = await SecureStorage.read(tokenKey);
    final savedExp = await SecureStorage.read(expiresKey);

    if (savedToken != null && savedExp != null) {
      final expiresAt = DateTime.parse(savedExp);

      if (DateTime.now().isBefore(expiresAt)) {
        return savedToken;
      }
    }

    return await _generateToken(uuid);
  }

  Future<String> _generateToken(String uuid) async {
    final now = DateTime.now();

    final payload = {
      "sub": "1234567890",
      "name": "John Doe",
      "admin": false,
      "iat": (now.millisecondsSinceEpoch / 1000).round(),
      "device_token": "123",
      "user_id": uuid,
    };

    final expiresIn = Duration(hours: 12);

    final jwt = JWT(
      payload,
      issuer: dotenv.env['JWT_ISSUER'] ?? "issuer",
      audience: Audience([dotenv.env['JWT_AUDIENCE'] ?? "audience"]),
    );

    final token = jwt.sign(
      SecretKey(secret),
      algorithm: JWTAlgorithm.HS256,
      expiresIn: expiresIn,
    );

    final expiresAt = now.add(expiresIn);

    await SecureStorage.write(tokenKey, token);
    await SecureStorage.write(expiresKey, expiresAt.toIso8601String());

    return token;
  }
}
