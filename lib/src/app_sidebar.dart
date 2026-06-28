import 'package:flutter/material.dart';
import 'nav_models.dart';
import 'sidebar_footer.dart';
import 'sidebar_header.dart';
import 'sidebar_nav.dart';
import 'sidebar_tile.dart';

/// The desktop / tablet side rail: header (logo + title), scrollable nav
/// (leaves + collapsible groups) and a pinned account/logout footer.
/// Width-animates between the expanded panel and the icon-only rail.
///
/// Purely presentational: all selection / open / collapse state and routing
/// are passed in, so it can be dropped into any app.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.collapsed,
    required this.appTitle,
    required this.onToggleCollapse,
    required this.onNavigate,
    required this.isActive,
    required this.isGroupOpen,
    required this.onToggleGroup,
    required this.onLogout,
    this.logo,
    this.titleStyle,
    this.logoutLabel = 'Logout',
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.onProfileTap,
  });

  final List<NavItem> items;
  final bool collapsed;
  final String appTitle;
  final Widget? logo;
  final TextStyle? titleStyle;
  final String logoutLabel;
  final VoidCallback onToggleCollapse;
  final void Function(String route) onNavigate;
  final bool Function(String route) isActive;
  final bool Function(NavGroup group) isGroupOpen;
  final void Function(NavGroup group) onToggleGroup;
  final VoidCallback onLogout;
  final String? userName;
  final String? userEmail;
  final Widget? userAvatar;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = collapsed ? 72.0 : 256.0;

    return AnimatedContainer(
      width: width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outline.withValues(alpha: 0.12)),
        ),
      ),
      // Pin the content to the target width and clip while the container's
      // width animates, so tiles never reflow into an overflow mid-animation.
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: width,
          maxWidth: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SidebarHeader(
                appTitle: appTitle,
                collapsed: collapsed,
                onToggle: onToggleCollapse,
                logo: logo,
                titleStyle: titleStyle,
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    children: [for (final item in items) _navItem(item)],
                  ),
                ),
              ),
              SidebarFooter(
                collapsed: collapsed,
                onLogout: onLogout,
                logoutLabel: logoutLabel,
                userName: userName,
                userEmail: userEmail,
                userAvatar: userAvatar,
                onProfileTap: onProfileTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(NavItem item) {
    switch (item) {
      case NavLeaf(:final action):
        return SidebarTile(
          icon: action.icon,
          label: action.label,
          selected: isActive(action.route),
          collapsed: collapsed,
          onTap: () => onNavigate(action.route),
        );
      case NavBranch(:final group):
        return collapsed
            ? SidebarCollapsedGroup(
                group: group,
                isActive: isActive,
                onNavigate: onNavigate,
              )
            : SidebarGroup(
                group: group,
                open: isGroupOpen(group),
                onToggle: () => onToggleGroup(group),
                isActive: isActive,
                onNavigate: onNavigate,
              );
    }
  }
}
