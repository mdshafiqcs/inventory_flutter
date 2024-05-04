import 'package:flutter/material.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

double setSize({required BuildContext context, required double mobile, required double tablet, double? desktop}) {
  double desktop = mobile;

  if (isMobile) {
    if (MediaQuery.of(context).size.width <= 450) {
      return mobile;
    } else {
      return tablet;
    }
  } else if (isDesktop || kIsWeb) {
    return desktop;
  }
  return mobile;
}

bool get isMobile {
  if (kIsWeb) {
    return false;
  } else {
    return Platform.isIOS || Platform.isAndroid;
  }
}

bool get isDesktop {
  if (kIsWeb) {
    return false;
  } else {
    return Platform.isLinux || Platform.isFuchsia || Platform.isWindows || Platform.isMacOS;
  }
}
