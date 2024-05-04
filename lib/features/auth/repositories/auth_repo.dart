import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

import '../../../core/common/api.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/providers/common_providers.dart';
import '../../../models/user.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(api: ref.read(apiProvider));
});

class AuthRepo {
  final API _api;

  AuthRepo({required API api}) : _api = api;

  FutureEither<User> signup(String body) async {
    final result = await _api.postRequest(apiEndpoint: ApiEndpoints.register, body: body, requireAuth: false);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final map = jsonDecode(response.body);

          return right(User.fromMap(map["data"]));
        } catch (e) {
          return left(Failure(message: e.toString()));
        }
      },
    );
  }

  FutureEither<User> login(String body) async {
    final result = await _api.postRequest(apiEndpoint: ApiEndpoints.login, body: body, requireAuth: false);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final map = jsonDecode(response.body);

          return right(User.fromMap(map["data"]));
        } catch (e) {
          return left(Failure(message: ErrorMessage.failedToParseJson));
        }
      },
    );
  }
}
