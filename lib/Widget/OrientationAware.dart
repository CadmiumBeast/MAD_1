import 'package:flutter/material.dart';

class OrientationAwareWidget extends StatelessWidget {
  final Widget portraitWidget;
  final Widget landscapeWidget;

  const OrientationAwareWidget({
    super.key,
    required this.portraitWidget,
    required this.landscapeWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandscape ? landscapeWidget : portraitWidget;
  }
}
