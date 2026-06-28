import 'package:flutter/material.dart';

/// Circular avatar: a custom widget when supplied, otherwise the user's
/// initials on a primary-tinted disc.
class SidebarAvatar extends StatelessWidget {
  const SidebarAvatar({
    super.key,
    required this.name,
    required this.size,
    this.custom,
  });

  final String name;
  final double size;
  final Widget? custom;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (custom != null) {
      return ClipOval(
        child: SizedBox(width: size, height: size, child: custom),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.14),
      ),
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
