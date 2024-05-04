import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/constants/pallete.dart';
import 'package:inventory_flutter/features/home/screens/home_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/shared_pref_keys.dart';
import '../core/utils/utils.dart';
import 'auth/screens/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  checkLogin() async {
    Future.delayed(const Duration(milliseconds: 300)).then((value) async {
      final pref = await SharedPreferences.getInstance();
      bool isLoggedIn = pref.getBool(SharedPrefKeys.isLoggedIn) ?? false;

      if (isLoggedIn) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: setSize(context: context, mobile: 40.w, tablet: 50),
          width: setSize(context: context, mobile: 40.w, tablet: 50),
          child: LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: const [kBaseColor],
            strokeWidth: setSize(context: context, mobile: 5.w, tablet: 7),
          ),
        ),
      ),
    );
  }
}
