import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'uuid_provider.dart';

// const authSecret = "SUA_SECRET_AQUI";
const authSecret = "a-string-secret-at-least-256-bits-long";

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(authSecret);
});

final bearerTokenProvider = FutureProvider<String>((ref) async {
  final uuid = await ref.watch(uuidProvider.future);
  final auth = ref.watch(authServiceProvider);
  return auth.getValidToken(uuid);
});
