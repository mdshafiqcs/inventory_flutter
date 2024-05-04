import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_strings.dart';
import '../../../core/utils/utils.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/unfocus_ontap.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  handleSignup() {
    if (_signupFormKey.currentState != null) {
      if (_signupFormKey.currentState!.validate()) {
        ref.watch(signupControllerProvider.notifier).signUp(
              context: context,
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              key: _signupFormKey,
              child: ListView(
                children: [
                  Image.asset(ImageStrings.logo),
                  Text(
                    "Create New Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: setSize(context: context, mobile: 20.w, tablet: 22)),
                  ),
                  SizedBox(height: 20.w),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 15.w),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Name is required"),
                        MinLengthValidator(3, errorText: "Name must be at lest 3 character long"),
                      ],
                    ).call,
                  ),
                  SizedBox(height: 10.w),
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
                    obscureText: ref.watch(signupControllerProvider).obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: "Password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    ),
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Password is required"),
                        MinLengthValidator(6, errorText: "Password must be at lest 6 character long."),
                      ],
                    ).call,
                  ),
                  SizedBox(height: 20.w),
                  CustomButton(
                    text: "Submit",
                    onPressed: handleSignup,
                    loading: ref.watch(signupControllerProvider).checkingSignup,
                  ),
                  SizedBox(height: 10.w),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back to login",
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
