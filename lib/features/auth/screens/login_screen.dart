import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/constants/image_strings.dart';
import 'package:inventory_flutter/core/utils/utils.dart';
import 'package:inventory_flutter/features/auth/controllers/login_controller.dart';
import 'package:inventory_flutter/features/auth/screens/signup_screen.dart';
import 'package:inventory_flutter/widgets/custom_button.dart';
import 'package:inventory_flutter/widgets/unfocus_ontap.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _signinFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  handleLogin() {
    if (_signinFormKey.currentState != null) {
      if (_signinFormKey.currentState!.validate()) {
        ref.watch(loginControllerProvider.notifier).login(
              context: context,
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusOnTap(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            child: Form(
              key: _signinFormKey,
              child: ListView(
                children: [
                  Image.asset(ImageStrings.logo),
                  Text(
                    "Login to Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: setSize(context: context, mobile: 20.w, tablet: 22)),
                  ),
                  SizedBox(height: 20.w),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 15.w),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Email is required"),
                      EmailValidator(errorText: "Enter a valid email"),
                    ]).call,
                  ),
                  SizedBox(height: 10.w),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(fontSize: 15.w),
                    obscureText: ref.watch(loginControllerProvider).obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: MultiValidator([RequiredValidator(errorText: "Password is required"), MinLengthValidator(6, errorText: "Password must be at lest 6 character long.")]).call,
                  ),
                  SizedBox(height: 20.w),
                  CustomButton(
                    text: "Login",
                    onPressed: handleLogin,
                    loading: ref.watch(loginControllerProvider).checkingSignin,
                  ),
                  SizedBox(height: 10.w),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      "Create Account",
                      style: TextStyle(fontSize: 15.w),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
