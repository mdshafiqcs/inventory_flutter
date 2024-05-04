// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:inventory_flutter/core/common/app_helper.dart';

class API {
  final Client _client;
  final bool _logErrors;
  API({required Client client, bool logErrors = false})
      : _client = client,
        _logErrors = logErrors;

  FutureEither<Response> getRequest({required String apiEndpoint, bool requireAuth = true}) async {
    var headers = <String, String>{};

    String token = await getToken();

    if (requireAuth) {
      headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      };
    } else {
      headers = {
        "Accept": "application/json",
      };
    }

    var url = Uri.parse(apiEndpoint);

    try {
      final response = await _client.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(response);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, jsonDecode(response.body));
        if (_logErrors) {
          log("${HttpMethods.getMethod}, Status Code: ${response.statusCode}");
          log("API URL = $url");
          log("ErrorResponse: ${jsonDecode(response.body)}");
        }
        return left(Failure(message: errorMessage));
      }
    } on SocketException catch (e) {
      if (_logErrors) {
        log("SocketException : ${HttpMethods.getMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException catch (e) {
      if (_logErrors) {
        log("HttpException : ${HttpMethods.getMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException catch (e) {
      if (_logErrors) {
        log("FormatException : ${HttpMethods.getMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException catch (e) {
      if (_logErrors) {
        log("TimeoutException : ${HttpMethods.getMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      if (_logErrors) {
        log(" ${HttpMethods.getMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }

      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }

  FutureEither<Response> postRequest({required String apiEndpoint, required String body, bool requireAuth = true}) async {
    var headers = <String, String>{};

    String token = await getToken();

    if (requireAuth) {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
    } else {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
    }

    var url = Uri.parse(apiEndpoint);

    try {
      final response = await _client.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(response);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, jsonDecode(response.body));
        if (_logErrors) {
          log("${HttpMethods.postMethod}, Status Code: ${response.statusCode}");
          log("API URL = $url");
          log("body = $body");
          log("ErrorResponse: ${jsonDecode(response.body)}");
        }
        return left(Failure(message: errorMessage));
      }
    } on SocketException catch (e) {
      if (_logErrors) {
        log("SocketException : ${HttpMethods.postMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException catch (e) {
      if (_logErrors) {
        log("HttpException : ${HttpMethods.postMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException catch (e) {
      if (_logErrors) {
        log("FormatException : ${HttpMethods.postMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException catch (e) {
      if (_logErrors) {
        log("TimeoutException : ${HttpMethods.postMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      if (_logErrors) {
        log("${HttpMethods.postMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }

  FutureEither<Response> putRequest({required String apiEndpoint, required String body, bool requireAuth = true}) async {
    var headers = <String, String>{};

    String token = await getToken();

    if (requireAuth) {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
    } else {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
    }

    var url = Uri.parse(apiEndpoint);

    try {
      final response = await _client.put(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(response);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, jsonDecode(response.body));
        if (_logErrors) {
          log("${HttpMethods.putMethod}, Status Code: ${response.statusCode}");
          log("API URL = $url");
          log("body = $body");
          log("ErrorResponse: ${jsonDecode(response.body)}");
        }
        return left(Failure(message: errorMessage));
      }
    } on SocketException catch (e) {
      if (_logErrors) {
        log("SocketException : ${HttpMethods.putMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException catch (e) {
      if (_logErrors) {
        log("HttpException : ${HttpMethods.putMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException catch (e) {
      if (_logErrors) {
        log("FormatException : ${HttpMethods.putMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException catch (e) {
      if (_logErrors) {
        log("TimeoutException : ${HttpMethods.putMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      if (_logErrors) {
        log("${HttpMethods.putMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }

  FutureEither<Response> deleteRequest({required String apiEndpoint, String? body, bool requireAuth = true}) async {
    var headers = <String, String>{};

    String token = await getToken();

    if (requireAuth) {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
    } else {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
    }

    var url = Uri.parse(apiEndpoint);

    try {
      final response = await _client.delete(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(response);
      } else {
        final String errorMessage = getErrorMessage(response.statusCode, jsonDecode(response.body));
        if (_logErrors) {
          log("${HttpMethods.deleteMethod}, Status Code: ${response.statusCode}");
          log("API URL = $url");
          log("body = $body");
          log("ErrorResponse: ${jsonDecode(response.body)}");
        }
        return left(Failure(message: errorMessage));
      }
    } on SocketException catch (e) {
      if (_logErrors) {
        log("SocketException : ${HttpMethods.deleteMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.noInternetConnection));
    } on HttpException catch (e) {
      if (_logErrors) {
        log("HttpException : ${HttpMethods.deleteMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.httpError));
    } on FormatException catch (e) {
      if (_logErrors) {
        log("FormatException : ${HttpMethods.deleteMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.badResponseFormat));
    } on TimeoutException catch (e) {
      if (_logErrors) {
        log("TimeoutException : ${HttpMethods.deleteMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: ErrorMessage.timeOutError));
    } catch (e) {
      if (_logErrors) {
        log("${HttpMethods.deleteMethod} call on Api Endpoint = $apiEndpoint, exception is = ${e.toString()}");
      }
      return left(Failure(message: "Unknown Error occured, try again later"));
    }
  }

  static String getErrorMessage(int statusCode, json) {
    switch (statusCode) {
      case 400:
        return json['message'] ?? "Something went wrong";

      case 401:
        return ErrorMessage.unAuthenticated;

      case 403:
        return json['message'];

      case 404:
        return json['message'];

      case 422:
        final errors = json['errors'];
        return errors[errors.keys.elementAt(0)][0];

      default:
        return ErrorMessage.somethingWentWrong;
    }
  }
}

class HttpMethods {
  static const getMethod = "GET Method";
  static const postMethod = "POST Method";
  static const putMethod = "PUT Method";
  static const deleteMethod = "DELETE Method";
}

class Failure {
  final String message;
  final StackTrace stackTrace;

  Failure({
    required this.message,
    this.stackTrace = StackTrace.empty,
  });
}

class Success {
  final String message;
  Object? data;

  Success({
    required this.message,
    this.data,
  });

  factory Success.fromMap(Map<String, dynamic> map) {
    return Success(
      message: map['message'] != null ? map['message'] as String : "",
    );
  }

  @override
  String toString() => 'Success(message: $message, data: $data)';
}

class ErrorMessage {
  static const serverError = 'server_error';
  static const unAuthenticated = 'Unauthenticated';
  static const somethingWentWrong = 'Something Went Wrong';
  static const timeOutError = 'Server is Taking too much time to respond';
  static const noInternetConnection = 'No Internet Connection';
  static const httpError = "Cound not find";
  static const badResponseFormat = "Bad response format";

  static const getRequestMessage = "GET REQUEST FAILED";
  static const postRequestMessage = "POST REQUEST FAILED";
  static const putRequestMessage = "PUT REQUEST FAILED";
  static const deleteRequestMessage = "DELETE REQUEST FAILED";

  static const jsonParsingFailed = "FAILED TO PARSE JSON RESPONSE";

  static const authTokenEmpty = "AUTH TOKEN EMPTY";

  static const failedToParseJson = "Failed to Parse JSON Data";
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
