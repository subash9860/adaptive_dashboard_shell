import 'package:flutter/material.dart';

/// A single shadcn-style nav tile: rounded hover/active surface, leading icon,
/// optional label (hidden in [collapsed] rail mode) and optional [trailing].
///
/// Presentational and app-agnostic — reuse it for any sidebar row.
class SidebarTile extends StatelessWidget {
  const SidebarTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.onTap,
    this.iconSize = 20,
    this.fontSize = 14,
    this.height = 38,
    this.trailing,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double height;
  final Widget? trailing;

  /// Overrides the resolved foreground (icon + text) colour, e.g. logout error.
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fg =
        foreground ??
        (selected
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.72));

    final content = collapsed
        ? Center(
            child: Icon(icon, size: iconSize, color: fg),
          )
        : Row(
            children: [
              Icon(icon, size: iconSize, color: fg),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: fontSize,
                    height: 1.1,
                    color: fg,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              ?trailing,
            ],
          );

    Widget tile = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: colorScheme.onSurface.withValues(alpha: 0.05),
        splashColor: colorScheme.primary.withValues(alpha: 0.08),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.10)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 10),
          child: content,
        ),
      ),
    );

    if (collapsed) {
      tile = Tooltip(message: label, child: tile);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: tile,
      ),
    );
  }
}
