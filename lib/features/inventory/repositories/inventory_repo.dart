import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:inventory_flutter/models/inventory.dart';

import '../../../core/common/api.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/providers/common_providers.dart';

final inventoryRepoProvider = Provider<InventoryRepo>((ref) {
  return InventoryRepo(api: ref.read(apiProvider));
});

class InventoryRepo {
  final API _api;

  InventoryRepo({required API api}) : _api = api;

  FutureEither<List<Inventory>> getInventories() async {
    final result = await _api.getRequest(apiEndpoint: ApiEndpoints.allInventories);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final json = jsonDecode(response.body)["data"] as List<dynamic>;
          final inventories = json.map((p) => Inventory.fromMap(p)).toList();

          return right(inventories);
        } catch (e) {
          return left(Failure(message: ErrorMessage.failedToParseJson));
        }
      },
    );
  }

  FutureEither<Success> createInventory(String body) async {
    final result = await _api.postRequest(apiEndpoint: ApiEndpoints.createInventory, body: body);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final map = jsonDecode(response.body);

          var success = Success.fromMap(map);
          success.data = Inventory.fromMap(map["data"]);

          return right(success);
        } catch (e) {
          return left(Failure(message: ErrorMessage.failedToParseJson));
        }
      },
    );
  }

  FutureEither<Success> updateInventory(String body) async {
    final result = await _api.putRequest(apiEndpoint: ApiEndpoints.updateInventory, body: body);

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final map = jsonDecode(response.body);

          var success = Success.fromMap(map);
          success.data = Inventory.fromMap(map["data"]);

          return right(success);
        } catch (e) {
          return left(Failure(message: ErrorMessage.failedToParseJson));
        }
      },
    );
  }

  FutureEither<Success> deleteInventory(int id) async {
    final result = await _api.deleteRequest(apiEndpoint: ApiEndpoints.deleteInventory(id));

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
