import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../../models/user.dart';
import '../common/api.dart';
import '../common/config.dart';

final userProvider = StateProvider<User?>((ref) => null);

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final apiProvider = Provider<API>((ref) {
  return API(
    client: Client(),
    logErrors: AppConfig.logErrors,
  );
});
