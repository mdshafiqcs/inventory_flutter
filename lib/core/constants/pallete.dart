import 'package:flutter/material.dart';

const kBaseColor = Color(0xFF008080);
const kButtonColor = Color(0xFF008080);

const whiteColor = Colors.white;
const kBackgroundColor = Colors.white;
const greenColor = Colors.green;
const tealColor = Colors.teal;
const orangeColor = Color(0xFFFF7C52);

const textColor1 = Color.fromARGB(255, 16, 16, 16);
const textColor2 = Color.fromARGB(255, 172, 172, 172);
const textColor3 = Color(0xFF707070);
const textColor4 = Color(0xFF434242);
const textColor5 = Color(0xFF707070);
const facebookColor = Color(0xFF346DB4);

const MaterialColor kBaseColorToDark = MaterialColor(
  0xFF008080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xff007373), //10%
    100: Color(0xff006666), //20%
    200: Color(0xff005a5a), //30%
    300: Color(0xff004d4d), //40%
    400: Color(0xff004040), //50%
    500: Color(0xff003333), //60%
    600: Color(0xff002626), //70%
    700: Color(0xff001a1a), //80%
    800: Color(0xff000d0d), //90%
    900: Color(0xff000000), //100%
  },
);
const MaterialColor kBaseColorToLight = MaterialColor(
  0xFF008080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xff1a8d8d), //10%
    100: Color(0xff339999), //20%
    200: Color(0xff4da6a6), //30%
    300: Color(0xff66b3b3), //40%
    400: Color(0xff80c0c0), //50%
    500: Color(0xff99cccc), //60%
    600: Color(0xffb3d9d9), //70%
    700: Color(0xffcce6e6), //80%
    800: Color(0xffe6f2f2), //90%
    900: Color(0xffffffff), //100%
  },
);
