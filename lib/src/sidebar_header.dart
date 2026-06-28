import 'package:flutter/material.dart';

/// Sidebar header with an optional [logo], the [appTitle] and the collapse
/// toggle. Cross-fades between the expanded and collapsed (rail) layouts.
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    super.key,
    required this.appTitle,
    required this.collapsed,
    required this.onToggle,
    this.logo,
    this.titleStyle,
  });

  final String appTitle;
  final bool collapsed;
  final VoidCallback onToggle;

  /// Optional brand mark shown before the title (and alone in the collapsed
  /// rail). Sized to a 32px (expanded) / 28px (collapsed) rounded box.
  final Widget? logo;

  /// Overrides the resolved title text style.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: collapsed ? _collapsed(context) : _expanded(context),
      ),
    );
  }

  Widget _logoBox(double size) {
    if (logo == null) return SizedBox(width: size, height: size);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: size, height: size, child: logo),
    );
  }

  Widget _expanded(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowText = constraints.maxWidth > 140;
        final canShowButton = constraints.maxWidth > 90;

        return Container(
          key: const ValueKey('expanded'),
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 120 ? 6 : 16,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: Row(
            children: [
              _logoBox(32),
              if (canShowText) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    appTitle,
                    style:
                        titleStyle ??
                        textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              if (canShowButton)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    icon: Icon(
                      Icons.chevron_left,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: onToggle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _collapsed(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _logoBox(28),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}
