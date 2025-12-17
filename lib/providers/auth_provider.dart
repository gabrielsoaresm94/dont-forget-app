import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'uuid_provider.dart';

final authSecret = dotenv.env['JWT_SECRET'] ?? "secret";

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(authSecret);
});

final bearerTokenProvider = FutureProvider<String>((ref) async {
  final uuid = await ref.watch(uuidProvider.future);
  final auth = ref.watch(authServiceProvider);
  return auth.getValidToken(uuid);
});
