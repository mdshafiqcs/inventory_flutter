import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

import '../../../core/common/api.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/providers/common_providers.dart';

final homeRepoProvider = Provider<HomeRepo>((ref) {
  return HomeRepo(api: ref.read(apiProvider));
});

class HomeRepo {
  final API _api;

  HomeRepo({required API api}) : _api = api;

  FutureEither<Success> logout() async {
    final body = jsonEncode({"test": "Hello"});
    final result = await _api.postRequest(apiEndpoint: ApiEndpoints.logout, body: body);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final map = jsonDecode(response.body);

          return right(Success.fromMap(map));
        } catch (e) {
          return left(Failure(message: ErrorMessage.failedToParseJson));
        }
      },
    );
  }
}
