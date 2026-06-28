import 'package:flutter/material.dart';
import 'app_sidebar.dart';
import 'breakpoints.dart';
import 'nav_models.dart';

/// Adaptive app shell: a collapsible side rail (desktop / tablet) plus an
/// optional bottom nav (mobile), wrapping a routed [child]. Presentational only
/// — it knows nothing about permissions, providers or routing. Callers pass the
/// already-filtered [items] / [mobileNavItems], the [currentRoute], and the
/// [onNavigate] / [onLogout] callbacks.
///
/// The side menu is a custom, shadcn-style rail (no external package): rounded
/// hover/active tiles, collapsible groups with an indented guide line, and an
/// icon-only collapsed mode whose groups open as a flyout popup. It composes
/// the smaller [AppSidebar] / sidebar widgets in this package; reuse those
/// directly to build a different chrome.
class AppDashboardShell extends StatefulWidget {
  const AppDashboardShell({
    super.key,
    required this.child,
    required this.items,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
    this.mobileNavItems = const [],
    this.appTitle = 'Dashboard',
    this.logo,
    this.titleStyle,
    this.logoutLabel = 'Logout',
    this.breakpoints = const DashboardBreakpoints(),
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.onProfileTap,
  });

  /// Routed content rendered beside / below the navigation.
  final Widget child;

  /// Side-menu entries, in display order (filter for permissions before
  /// passing them in).
  final List<NavItem> items;

  /// Mobile bottom-nav entries. Empty => no bottom nav.
  final List<NavAction> mobileNavItems;

  /// Current location (e.g. `GoRouterState.of(context).uri.toString()`).
  final String currentRoute;

  /// Called with the destination route when the user taps a nav entry.
  final void Function(String route) onNavigate;

  /// Called when the user taps the logout entry.
  final VoidCallback onLogout;

  /// Brand text shown in the expanded header.
  final String appTitle;

  /// Optional brand mark shown in the header before [appTitle].
  final Widget? logo;

  /// Overrides the resolved [appTitle] text style.
  final TextStyle? titleStyle;

  /// Label for the footer logout entry.
  final String logoutLabel;

  /// Width thresholds that decide the layout.
  final DashboardBreakpoints breakpoints;

  /// Signed-in user's display name. When null/empty the footer shows only the
  /// logout entry (no profile row).
  final String? userName;

  /// Signed-in user's email / secondary line, shown under [userName].
  final String? userEmail;

  /// Optional custom avatar widget. Falls back to initials of [userName].
  final Widget? userAvatar;

  /// Tapped when the profile row is pressed (e.g. open account / settings).
  final VoidCallback? onProfileTap;

  @override
  State<AppDashboardShell> createState() => _AppDashboardShellState();
}

class _AppDashboardShellState extends State<AppDashboardShell> {
  /// User's manual collapse choice. Null => follow the responsive default
  /// ([_defaultCollapsed]): collapsed on tablet, expanded on desktop.
  bool? _collapsedOverride;

  /// Tracks the previous breakpoint so we can react when the window is resized
  /// down into tablet width.
  bool _wasTablet = false;

  /// Per-group manual open/close override, keyed by group title. Null entry =>
  /// follow the default (a group auto-opens when it contains the active route).
  final Map<String, bool> _groupOverride = {};

  /// The single nav route that should render selected for [currentRoute] — the
  /// longest (most specific) item route that matches. Recomputed each build.
  String? _activeRoute;

  /// Responsive default: tablet starts collapsed, desktop starts expanded.
  bool _defaultCollapsed(BuildContext context) =>
      widget.breakpoints.isTablet(context);

  /// Effective collapse state: manual override if set, else responsive default.
  bool _isCollapsed(BuildContext context) =>
      _collapsedOverride ?? _defaultCollapsed(context);

  void _toggleSideBar() {
    setState(() => _collapsedOverride = !_isCollapsed(context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fires on every MediaQuery change. When the window shrinks into tablet
    // width, drop any manual expand so the menu auto-collapses to the tablet
    // default.
    final isTablet = widget.breakpoints.isTablet(context);
    if (isTablet && !_wasTablet) {
      _collapsedOverride = null;
    }
    _wasTablet = isTablet;
  }

  /// Only the pre-resolved most-specific route is active, so a parent like
  /// `/dashboard` is not highlighted while on `/dashboard/reservation`.
  bool _isActive(String route) => route == _activeRoute;

  /// Picks the longest item route that equals [currentRoute] or is a path
  /// prefix of it (ignoring any query string). Longest wins so the deepest
  /// match — e.g. `/dashboard/reservation` over `/dashboard` — is selected.
  String? _resolveActiveRoute(List<NavItem> items) {
    final current = widget.currentRoute.split('?').first;
    String? best;
    void consider(String route) {
      final matches = current == route || current.startsWith('$route/');
      if (matches && (best == null || route.length > best!.length)) {
        best = route;
      }
    }

    for (final item in items) {
      switch (item) {
        case NavLeaf(:final action):
          consider(action.route);
        case NavBranch(:final group):
          for (final child in group.children) {
            consider(child.route);
          }
      }
    }
    return best;
  }

  /// A group is open if the user toggled it, otherwise if it holds the active
  /// route (so the current section is revealed on load).
  bool _isGroupOpen(NavGroup group) {
    final override = _groupOverride[group.title];
    if (override != null) return override;
    return group.children.any((c) => _isActive(c.route));
  }

  void _toggleGroup(NavGroup group) {
    setState(() => _groupOverride[group.title] = !_isGroupOpen(group));
  }

  @override
  Widget build(BuildContext context) {
    _activeRoute = _resolveActiveRoute(widget.items);

    final mobileRoutes = widget.mobileNavItems.map((a) => a.route).toList();
    final currentMobileIndex = mobileRoutes.indexOf(widget.currentRoute);
    final isOnMobileNavRoute = currentMobileIndex >= 0;
    final showBottomNav = mobileRoutes.contains(widget.currentRoute);

    final isMobile = widget.breakpoints.isMobile(context);

    return Scaffold(
      body: isMobile
          ? widget.child
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppSidebar(
                  items: widget.items,
                  collapsed: _isCollapsed(context),
                  appTitle: widget.appTitle,
                  logo: widget.logo,
                  titleStyle: widget.titleStyle,
                  logoutLabel: widget.logoutLabel,
                  onToggleCollapse: _toggleSideBar,
                  onNavigate: widget.onNavigate,
                  isActive: _isActive,
                  isGroupOpen: _isGroupOpen,
                  onToggleGroup: _toggleGroup,
                  onLogout: widget.onLogout,
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                  userAvatar: widget.userAvatar,
                  onProfileTap: widget.onProfileTap,
                ),
                Expanded(child: widget.child),
              ],
            ),
      bottomNavigationBar:
          (isMobile && showBottomNav && widget.mobileNavItems.length >= 2)
          ? BottomNavigationBar(
              currentIndex: isOnMobileNavRoute ? currentMobileIndex : 0,
              onTap: (index) =>
                  widget.onNavigate(widget.mobileNavItems[index].route),
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: isOnMobileNavRoute
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              selectedLabelStyle: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
              type: BottomNavigationBarType.fixed,
              elevation: 4,
              items: widget.mobileNavItems
                  .map(
                    (a) => BottomNavigationBarItem(
                      icon: Icon(a.icon),
                      label: a.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}
