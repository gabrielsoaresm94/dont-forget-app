import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../utils/secure_storage.dart';

final uuidProvider = FutureProvider<String>((ref) async {
  const key = 'device_uuid';
  final existing = await SecureStorage.read(key);

  if (existing != null) return existing;

  final newUuid = const Uuid().v4();
  await SecureStorage.write(key, newUuid);
  return newUuid;
});
