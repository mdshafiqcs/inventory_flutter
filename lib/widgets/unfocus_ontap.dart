import 'package:flutter/material.dart';

class UnfocusOnTap extends StatefulWidget {
  const UnfocusOnTap({super.key, required this.child});
  final Widget child;

  @override
  State<UnfocusOnTap> createState() => _UnfocusOnTapState();
}

class _UnfocusOnTapState extends State<UnfocusOnTap> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus all text fields when tapping outside of them
        FocusScope.of(context).unfocus();
      },
      child: widget.child,
    );
  }
}
