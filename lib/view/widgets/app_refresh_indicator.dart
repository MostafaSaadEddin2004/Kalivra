import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
  });

  final RefreshCallback onRefresh;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: color ?? Theme.of(context).colorScheme.onTertiaryFixed,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

class RefreshableStateBox extends StatelessWidget {
  const RefreshableStateBox({
    super.key,
    required this.child,
    this.heightFactor = 0.68,
  });

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * heightFactor,
        child: child,
      ),
    );
  }
}
