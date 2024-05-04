import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:inventory_flutter/models/inventory.dart';
import 'package:inventory_flutter/models/item.dart';

import '../../../core/common/api.dart';
import '../../../core/common/app_helper.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/providers/common_providers.dart';

final itemRepoProvider = Provider<ItemRepo>((ref) {
  return ItemRepo(api: ref.read(apiProvider));
});

class ItemRepo {
  final API _api;

  ItemRepo({required API api}) : _api = api;

  FutureEither<List<Item>> getItems(int inventoryId) async {
    final result = await _api.getRequest(apiEndpoint: ApiEndpoints.getItems(inventoryId));

    return result.fold(
      (failure) => left(failure),
      (Response response) {
        try {
          final json = jsonDecode(response.body)["data"] as List<dynamic>;
          final items = json.map((p) => Item.fromMap(p)).toList();

          return right(items);
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

  FutureEither<Success> deleteItem(int id) async {
    final result = await _api.deleteRequest(apiEndpoint: ApiEndpoints.deleteItem(id));

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

  FutureEither<Success> createItem(Item item, String imagePath) async {
    try {
      final token = await getToken();
      var headers = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(ApiEndpoints.createItem);

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(headers);

      String ext = imagePath.split('.').last;

      var file = await http.MultipartFile.fromPath("image", imagePath, contentType: MediaType('image', ext));
      request.files.add(file);

      request.fields["inventory_id"] = item.inventoryId.toString();
      request.fields["name"] = item.name;
      request.fields["description"] = item.description;
      request.fields["qty"] = item.qty.toString();

      final response = await request.send();

      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      final json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Success success = Success.fromMap(json);

        success.data = Item.fromMap(json["data"]);

        return right(success);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, json);

        return left(Failure(message: errorMessage));
      }
    } on SocketException {
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException {
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException {
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException {
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      log(e.toString());
      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }

  FutureEither<Success> updateItem(Item item, String imagePath) async {
    try {
      final token = await getToken();
      var headers = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(ApiEndpoints.updateItem);

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(headers);

      if (imagePath.isNotEmpty) {
        String ext = imagePath.split('.').last;

        var file = await http.MultipartFile.fromPath("image", imagePath, contentType: MediaType('image', ext));
        request.files.add(file);
      }

      request.fields["id"] = item.id.toString();
      request.fields["name"] = item.name;
      request.fields["description"] = item.description;
      request.fields["qty"] = item.qty.toString();

      final response = await request.send();

      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      final json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Success success = Success.fromMap(json);

        success.data = Item.fromMap(json["data"]);

        return right(success);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, json);

        return left(Failure(message: errorMessage));
      }
    } on SocketException {
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException {
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException {
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException {
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      log(e.toString());
      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }
}
