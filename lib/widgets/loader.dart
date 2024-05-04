import 'package:flutter/widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../core/constants/pallete.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: 30,
      child: LoadingIndicator(
        indicatorType: Indicator.ballPulse,
        colors: [kBaseColor],
        strokeWidth: 3,
      ),
    );
  }
}
