import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps [child] so that the system back button does not pop the route;
/// instead it closes the app via [SystemNavigator.pop].
class PopScopeExitApp extends StatelessWidget {
  const PopScopeExitApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) SystemNavigator.pop();
      },
      child: child,
    );
  }
}
