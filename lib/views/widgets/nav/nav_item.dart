import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  const NavItem({super.key, 
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final IconData icon;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Icon(
          icon,
          size: 24,
          color: isSelected ? colorScheme.primary : colorScheme.outline,
        ),
      ),
    );
  }
}
