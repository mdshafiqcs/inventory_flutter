import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/constants/app_strings.dart';

import 'core/constants/pallete.dart';
import 'features/splash_screen.dart';

main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  //
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kBaseColor),
          useMaterial3: false,
        ),
        defaultTransition: Transition.noTransition,
        home: const SplashScreen(),
      );
    });
  }
}
