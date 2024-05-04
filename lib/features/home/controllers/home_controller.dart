// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/app_helper.dart';
import '../../auth/screens/login_screen.dart';
import '../repositories/home_repo.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeControllerData>((ref) {
  return HomeController(homeRepo: ref.watch(homeRepoProvider), ref: ref);
});

class HomeController extends StateNotifier<HomeControllerData> {
  HomeController({required HomeRepo homeRepo, required Ref ref})
      : _homeRepo = homeRepo,
        _ref = ref,
        super(HomeControllerData());
  final HomeRepo _homeRepo;
  final Ref _ref;

  void logout(BuildContext context) async {
    if (!state.checkingLogout) {
      state = state.copyWith(checkingLogout: true);

      final result = await _homeRepo.logout();

      state = state.copyWith(checkingLogout: false);

      result.fold(
        (failure) => showError(context: context, error: failure.message),
        (success) async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
          Get.offAll(() => const LoginScreen());
        },
      );
    }
  }

  set({
    bool? checkingLogout,
    bool? loadingInventories,
  }) {
    if (checkingLogout != null) {
      state = state.copyWith(checkingLogout: checkingLogout);
    }

    if (loadingInventories != null) {
      state = state.copyWith(loadingInventories: loadingInventories);
    }
  }
}

class HomeControllerData {
  final bool checkingLogout;
  final bool loadingInventories;
  HomeControllerData({
    this.checkingLogout = false,
    this.loadingInventories = false,
  });

  HomeControllerData copyWith({
    bool? checkingLogout,
    bool? loadingInventories,
  }) {
    return HomeControllerData(
      checkingLogout: checkingLogout ?? this.checkingLogout,
      loadingInventories: loadingInventories ?? this.loadingInventories,
    );
  }

  @override
  String toString() => 'HomeControllerData(checkingLogout: $checkingLogout, loadingInventories: $loadingInventories)';

  @override
  bool operator ==(covariant HomeControllerData other) {
    if (identical(this, other)) return true;

    return other.checkingLogout == checkingLogout && other.loadingInventories == loadingInventories;
  }

  @override
  int get hashCode => checkingLogout.hashCode ^ loadingInventories.hashCode;
}
