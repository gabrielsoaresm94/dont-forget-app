import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:5000",
      contentType: "application/json",
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (req, handler) async {
        final token = await ref.read(bearerTokenProvider.future);
        req.headers["Authorization"] = "Bearer $token";
        return handler.next(req);
      },
    ),
  );

  return dio;
});
