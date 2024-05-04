// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/app_helper.dart';
import '../../../core/constants/shared_pref_keys.dart';
import '../../../core/providers/common_providers.dart';
import '../../home/screens/home_screen.dart';
import '../repositories/auth_repo.dart';

final signupControllerProvider = StateNotifierProvider<SignupController, SignupControllerData>((ref) {
  return SignupController(authRepo: ref.watch(authRepoProvider), ref: ref);
});

class SignupController extends StateNotifier<SignupControllerData> {
  SignupController({required Ref ref, required AuthRepo authRepo})
      : _ref = ref,
        _authRepo = authRepo,
        super(SignupControllerData());
  final Ref _ref;
  final AuthRepo _authRepo;

  signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    if (!state.checkingSignup) {
      set(checkingSignup: true);

      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      });

      final result = await _authRepo.signup(body);

      set(checkingSignup: false);

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

  void set({
    bool? checkingSignup,
    bool? obscureText,
  }) {
    if (checkingSignup != null) {
      state = state.copyWith(checkingSignup: checkingSignup);
    }
    if (obscureText != null) {
      state = state.copyWith(obscureText: obscureText);
    }
  }
}

class SignupControllerData {
  final bool checkingSignup;
  final bool obscureText;
  SignupControllerData({
    this.checkingSignup = false,
    this.obscureText = true,
  });

  SignupControllerData copyWith({
    bool? checkingSignup,
    bool? obscureText,
  }) {
    return SignupControllerData(
      checkingSignup: checkingSignup ?? this.checkingSignup,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  String toString() {
    return 'SignupControllerData( checkingSignup: $checkingSignup, obscureText: $obscureText)';
  }

  @override
  bool operator ==(covariant SignupControllerData other) {
    if (identical(this, other)) return true;

    return other.checkingSignup == checkingSignup && other.obscureText == obscureText;
  }

  @override
  int get hashCode {
    return checkingSignup.hashCode ^ obscureText.hashCode;
  }
}
