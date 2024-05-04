// ignore_for_file: prefer_const_declarations

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../common/config.dart';
import '../utils/platform_utils.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static final String _localMobileBaseUrl = Platform.isAndroid ? "http://10.0.2.2:8000/api" : "http://127.0.0.1:8000/api";
  static const String _localDesktopBaseUrl = "http://127.0.0.1:8000/api";
  static const String _localWebBaseUrl = "http://127.0.0.1:8000/api";

  static final String _localMobileSocketUrl = Platform.isAndroid ? "http://10.0.2.2:8000" : "http://127.0.0.1:8000"; //10.0.2.2
  static const String _localDesktopSocketUrl = "http://127.0.0.1:8000";
  static const String _localWebSocketUrl = "http://127.0.0.1:8000";

  static final String _localMobileImageUrl = Platform.isAndroid ? "http://10.0.2.2:8000/" : "http://127.0.0.1:8000/";
  static const String _localDesktopImageUrl = "http://127.0.0.1:8000/";
  static const String _localWebImageUrl = "http://127.0.0.1:8000/";

  static const String _serverBaseUrl = 'https://api.dailycourierservice.com//user';
  static const String _serverSocketUrl = 'https://api.dailycourierservice.com';
  static const String _serverImageUrl = 'https://api.dailycourierservice.com/';

  static String get baseUrl => _getBaseUrl;
  static String get socketUrl => _getSocketUrl;
  static String get imageUrl => _getImageUrl;

  static String get register => "$baseUrl/register";
  static String get login => "$baseUrl/login";
  static String get logout => "$baseUrl/logout";

  //inventories
  static String get allInventories => "$baseUrl/inventory/all";
  static String get createInventory => "$baseUrl/inventory/create";

  static String get updateInventory => "$baseUrl/inventory/update";

  static String deleteInventory(int id) {
    return "$baseUrl/inventory/delete/id=$id";
  }

  // items // item/inventoryid=7/all
  static String get createItem => "$baseUrl/item/create";

  static String getItems(int id) {
    return "$baseUrl/item/inventoryid=$id/all";
  }

  static String deleteItem(int id) {
    return "$baseUrl/item/delete/id=$id";
  }

  static String get user => baseUrl;

  static String get _getImageUrl {
    if (PlatformUtils.isMobile) {
      return AppConfig.isDevMode ? _localMobileImageUrl : _serverImageUrl;
    } else if (PlatformUtils.isDesktop) {
      return AppConfig.isDevMode ? _localDesktopImageUrl : _serverImageUrl;
    } else if (kIsWeb) {
      return AppConfig.isDevMode ? _localWebImageUrl : _serverImageUrl;
    } else {
      return "";
    }
  }

  static String get _getBaseUrl {
    if (PlatformUtils.isMobile) {
      return AppConfig.isDevMode ? _localMobileBaseUrl : _serverBaseUrl;
    } else if (PlatformUtils.isDesktop) {
      return AppConfig.isDevMode ? _localDesktopBaseUrl : _serverBaseUrl;
    } else if (kIsWeb) {
      return AppConfig.isDevMode ? _localWebBaseUrl : _serverBaseUrl;
    } else {
      return "";
    }
  }

  static String get _getSocketUrl {
    if (PlatformUtils.isMobile) {
      return AppConfig.isDevMode ? _localMobileSocketUrl : _serverSocketUrl;
    } else if (PlatformUtils.isDesktop) {
      return AppConfig.isDevMode ? _localDesktopSocketUrl : _serverSocketUrl;
    } else if (kIsWeb) {
      return AppConfig.isDevMode ? _localWebSocketUrl : _serverSocketUrl;
    } else {
      return "";
    }
  }
}
