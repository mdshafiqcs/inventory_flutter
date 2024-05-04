import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_flutter/core/constants/pallete.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../core/utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.loading,
    this.height,
    this.width,
    this.fontSize,
    this.loaderSize,
    this.imagePath,
    this.radius,
  });

  final String text;
  final VoidCallback onPressed;
  final String? imagePath;
  final bool loading;
  final double? height, width, fontSize, loaderSize, radius;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          radius ?? setSize(context: context, mobile: 8.r, tablet: 8),
        ),
      ),
      height: height ?? setSize(context: context, mobile: 45.w, tablet: 48),
      minWidth: width,
      color: kBaseColor,
      onPressed: onPressed,
      child: imagePath == null
          ? loading
              ? SizedBox(
                  height: loaderSize ?? setSize(context: context, mobile: 35.w, tablet: 37),
                  width: loaderSize ?? setSize(context: context, mobile: 35.w, tablet: 37),
                  child: const LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: [Color(0xFFffffff)],
                    strokeWidth: 5,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize ?? setSize(context: context, mobile: 16.w, tablet: 18),
                    color: whiteColor,
                  ),
                )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath!,
                  width: setSize(context: context, mobile: 35.w, tablet: 38),
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 20),
                loading
                    ? SizedBox(
                        height: loaderSize ?? setSize(context: context, mobile: 35.w, tablet: 37),
                        width: loaderSize ?? setSize(context: context, mobile: 35.w, tablet: 37),
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballSpinFadeLoader,
                          colors: const [Color(0xFFffffff)],
                          strokeWidth: setSize(context: context, mobile: 5.w, tablet: 7),
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize ?? setSize(context: context, mobile: 16.w, tablet: 18),
                          color: whiteColor,
                        ),
                      )
              ],
            ),
    );
  }
}
