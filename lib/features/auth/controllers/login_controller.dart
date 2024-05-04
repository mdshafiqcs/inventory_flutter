// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/app_helper.dart';
import '../../../core/constants/shared_pref_keys.dart';
import '../../../core/providers/common_providers.dart';
import '../../home/screens/home_screen.dart';
import '../repositories/auth_repo.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, LoginControllerData>((ref) {
  return LoginController(authRepo: ref.watch(authRepoProvider), ref: ref);
});

class LoginController extends StateNotifier<LoginControllerData> {
  LoginController({required AuthRepo authRepo, required Ref ref})
      : _authRepo = authRepo,
        _ref = ref,
        super(LoginControllerData());
  final AuthRepo _authRepo;
  final Ref _ref;

  void login({required BuildContext context, required String email, required String password}) async {
    if (!state.checkingSignin) {
      state = state.copyWith(checkingSignin: true);

      String body = jsonEncode({
        "email": email,
        "password": password,
      });

      final result = await _authRepo.login(body);

      state = state.copyWith(checkingSignin: false);

      result.fold(
        (failure) => showError(context: context, error: failure.message),
        (user) async {
          final pref = await SharedPreferences.getInstance();
          await pref.setBool(SharedPrefKeys.isLoggedIn, true);
          await pref.setInt(SharedPrefKeys.userId, user.id);
          await pref.setString(SharedPrefKeys.email, user.email);
          await pref.setString(SharedPrefKeys.userName, user.name);

          _ref.read(secureStorageProvider).write(key: SharedPrefKeys.accessToken, value: user.token);

          Get.offAll(() => const HomeScreen());
        },
      );
    }
  }

  set({
    String? email,
    String? password,
    bool? obscureText,
    bool? checkingSignin,
  }) {
    if (email != null) {
      state = state.copyWith(email: email);
    }
    if (password != null) {
      state = state.copyWith(password: password);
    }
    if (obscureText != null) {
      state = state.copyWith(obscureText: obscureText);
    }

    if (checkingSignin != null) {
      state = state.copyWith(checkingSignin: checkingSignin);
    }
  }
}

class LoginControllerData {
  final String email;
  final String password;
  final bool checkingSignin;
  final bool obscureText;
  LoginControllerData({
    this.email = "",
    this.password = "",
    this.checkingSignin = false,
    this.obscureText = true,
  });

  LoginControllerData copyWith({
    String? email,
    String? password,
    bool? checkingSignin,
    bool? obscureText,
  }) {
    return LoginControllerData(
      email: email ?? this.email,
      password: password ?? this.password,
      checkingSignin: checkingSignin ?? this.checkingSignin,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  String toString() {
    return 'LoginControllerData(email: $email, password: $password, checkingSignin: $checkingSignin, obscureText: $obscureText)';
  }

  @override
  bool operator ==(covariant LoginControllerData other) {
    if (identical(this, other)) return true;

    return other.email == email && other.password == password && other.checkingSignin == checkingSignin && other.obscureText == obscureText;
  }

  @override
  int get hashCode {
    return email.hashCode ^ password.hashCode ^ checkingSignin.hashCode ^ obscureText.hashCode;
  }
}
