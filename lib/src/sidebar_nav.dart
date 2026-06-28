import 'package:flutter/material.dart';
import 'nav_models.dart';
import 'sidebar_tile.dart';

/// Expanded group: a toggle header with a rotating chevron and, when [open],
/// the children indented behind a vertical guide line.
class SidebarGroup extends StatelessWidget {
  const SidebarGroup({
    super.key,
    required this.group,
    required this.open,
    required this.onToggle,
    required this.isActive,
    required this.onNavigate,
  });

  final NavGroup group;
  final bool open;
  final VoidCallback onToggle;
  final bool Function(String route) isActive;
  final void Function(String route) onNavigate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final containsActive = group.children.any((c) => isActive(c.route));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SidebarTile(
          icon: group.icon,
          label: group.title,
          // Highlight the header only while collapsed-but-active, so the user
          // can still see which section they're in.
          selected: containsActive && !open,
          collapsed: false,
          onTap: onToggle,
          trailing: AnimatedRotation(
            turns: open ? 0.25 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.only(left: 18, top: 2, bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final child in group.children)
                            SidebarTile(
                              icon: child.icon,
                              label: child.label,
                              selected: isActive(child.route),
                              collapsed: false,
                              iconSize: 18,
                              fontSize: 13.5,
                              height: 34,
                              onTap: () => onNavigate(child.route),
                            ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

/// Collapsed (icon-only) group: a single icon tile whose children open as a
/// flyout popup, mirroring shadcn's icon-rail submenu behaviour.
class SidebarCollapsedGroup extends StatelessWidget {
  const SidebarCollapsedGroup({
    super.key,
    required this.group,
    required this.isActive,
    required this.onNavigate,
  });

  final NavGroup group;
  final bool Function(String route) isActive;
  final void Function(String route) onNavigate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final containsActive = group.children.any((c) => isActive(c.route));
    final fg = containsActive
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.70);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: PopupMenuButton<NavAction>(
        tooltip: group.title,
        position: PopupMenuPosition.under,
        offset: const Offset(8, 0),
        color: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
        ),
        onSelected: (a) => onNavigate(a.route),
        itemBuilder: (_) => [
          PopupMenuItem<NavAction>(
            enabled: false,
            height: 32,
            child: Text(
              group.title,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final child in group.children)
            PopupMenuItem<NavAction>(
              value: child,
              height: 40,
              child: Row(
                children: [
                  Icon(
                    child.icon,
                    size: 20,
                    color: isActive(child.route)
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    child.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5,
                      color: isActive(child.route)
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: isActive(child.route)
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
        // PopupMenuButton already wraps its child in a tooltip (group.title),
        // so no extra Tooltip here.
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: containsActive
                ? colorScheme.primary.withValues(alpha: 0.10)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(group.icon, size: 22, color: fg),
        ),
      ),
    );
  }
}
