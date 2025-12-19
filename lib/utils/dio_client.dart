import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? "http://localhost:5000",
      contentType: "application/json",
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (req, handler) async {
        final token = await ref.read(bearerTokenProvider.future);
        req.headers["Authorization"] = "Bearer $token";
        req.headers["ngrok-skip-browser-warning"] = true;
        return handler.next(req);
      },
    ),
  );

  return dio;
});
