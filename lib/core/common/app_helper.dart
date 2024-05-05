import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:uuid/uuid.dart';

import '../constants/pallete.dart';
import '../constants/shared_pref_keys.dart';
import '../utils/utils.dart';

const _secureStorage = FlutterSecureStorage();

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<String> getToken() async {
  String token = await _secureStorage.read(key: SharedPrefKeys.accessToken) ?? "";

  return token;
}

String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
  return DateFormat(format).format(date);
}

showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message)),
    );
}

String getNumberFormated(num number) {
  var numberFormater = NumberFormat('#,##,###.##');
  return numberFormater.format(number);
}

showError({required BuildContext context, required String error, String? title, VoidCallback? onTap}) {
  Get.defaultDialog(
    barrierDismissible: false,
    backgroundColor: whiteColor,
    title: title ?? "Opps!",
    titleStyle: TextStyle(
      fontSize: setSize(context: context, mobile: 15.w, tablet: 20),
      fontWeight: FontWeight.w500,
    ),
    content: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      error,
                      style: TextStyle(fontSize: setSize(context: context, mobile: 15.w, tablet: 20)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: setSize(context: context, mobile: 12.w, tablet: 15)),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              color: kBaseColor,
              onPressed: onTap ?? () => Get.back(),
              height: setSize(context: context, mobile: 30.w, tablet: 35),
              child: Text(
                "Ok",
                style: TextStyle(
                  fontSize: setSize(context: context, mobile: 15.w, tablet: 18),
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

copyToClipboard({required String text}) {
  FlutterClipboard.copy(text).then(
    (value) => Get.rawSnackbar(
      maxWidth: 100.w,
      message: 'Copied',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      borderRadius: 8.0,
      margin: const EdgeInsets.all(20.0),
      duration: const Duration(seconds: 1), // Set the duration for the short message
    ),
  );
}

String getErrorMessage(int statusCode, json) {
  switch (statusCode) {
    case 400:
      return json['message'] ?? "Something went wrong";

    case 401:
      return "unauthenticated";

    case 403:
      return json['message'] ?? "Forbidden";

    case 404:
      return json['message'] ?? "Not found";

    case 422:
      return json['message'] ?? "Fields Required";

    default:
      return 'Something Went Wrong';
  }
}

showCustomDialog({required BuildContext context, required String message, required String title, VoidCallback? onTap}) {
  Get.defaultDialog(
    barrierDismissible: false,
    title: title,
    titleStyle: TextStyle(
      fontSize: setSize(context: context, mobile: 15.w, tablet: 20),
      fontWeight: FontWeight.w500,
    ),
    content: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: setSize(context: context, mobile: 15.w, tablet: 20)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: setSize(context: context, mobile: 12.w, tablet: 15)),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              height: setSize(context: context, mobile: 30.w, tablet: 35),
              color: kBaseColor,
              onPressed: onTap ?? () => Get.back(),
              child: Text(
                "Ok",
                style: TextStyle(fontSize: setSize(context: context, mobile: 15.w, tablet: 18), color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String getCustomDate(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime time = DateTime.parse(date).toLocal();
  int month = time.month;
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';
  String newMonth = month < 10 ? '0$month' : '$month';

  String newDate = '$newDay-$newMonth-$year';

  return newDate;
}

String getTime(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime time = DateTime.parse(date).toLocal();
  int month = time.month;
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';
  String newMonth = month < 10 ? '0$month' : '$month';

  String newDate = '$newDay-$newMonth-$year';

  return newDate;
}

String getTimeAmPm(String date) {
  if (date.isEmpty) {
    return "";
  } else {
    DateTime dateTime = DateTime.parse(date).toLocal();

    String formattedTime = DateFormat.jm().format(dateTime);

    return formattedTime; // Output: 5:10 PM
  }
}

String getTimeAgo(String time) {
  if (time.isEmpty) {
    return '';
  } else {
    DateTime dbDate = DateTime.parse(time);
    final currDate = DateTime.now();

    var difference = currDate.difference(dbDate).inMinutes;

    if (difference < 1) {
      return "Just Now";
    } else if (difference < 60) {
      return "$difference min ago";
    } else if (difference < 1440) {
      return "${(difference / 60).toStringAsFixed(0)} hr ago";
    } else if (difference < 43200) {
      return "${(difference / 1440).toStringAsFixed(0)} days ago";
    } else if (difference < 518400) {
      return "${(difference / 43200).toStringAsFixed(0)} months ago";
    } else {
      return "${(difference / 518400).toStringAsFixed(1)} years ago";
    }
  }
}

String get uniqueId {
  String uuid = const Uuid().v4();
  int rand = Random(1).nextInt(99999) + 10000;
  var time = DateTime.now().microsecondsSinceEpoch;
  return "$uuid-$rand-$time";
}

showLoader(BuildContext context) {
  Get.dialog(Center(
    child: SizedBox(
      width: setSize(context: context, mobile: 190.w, tablet: 230),
      height: setSize(context: context, mobile: 190.w, tablet: 230),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(setSize(context: context, mobile: 16, tablet: 15)),
        ),
        child: Padding(
          padding: EdgeInsets.all(setSize(context: context, mobile: 12.w, tablet: 16)),
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotatePulse,
            colors: const [kBaseColor],
            strokeWidth: setSize(context: context, mobile: 3.w, tablet: 5),
          ),
        ),
      ),
    ),
  ));
}

closeLoader() {
  bool opended = Get.isDialogOpen ?? false;

  if (opended) {
    Get.back();
  }
}

// logout
// Future<void> logout({required WidgetRef ref}) async {
//   ref.watch(dashboardControllerProvider.notifier).set(dashboardPage: false);

//   final pref = await SharedPreferences.getInstance();

//   pref.clear();

//   await _secureStorage.delete(key: SharedPrefKeys.accessToken);

//   ref.read(authTokenProvider.notifier).update((state) => null);

//   Get.offAll(() => const LoginScreen());
// }
