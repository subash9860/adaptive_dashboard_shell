import 'package:flutter/material.dart';

/// One nav entry. [permission] = null means "always show" (e.g. logout, or
/// items with no spec'd permission yet — visible to everyone).
///
/// The shell itself never reads [permission]; it is a convenience slot so apps
/// can carry their own permission key alongside the entry and filter the list
/// before handing it to [AppDashboardShell].
class NavAction {
  const NavAction({
    required this.route,
    required this.label,
    required this.icon,
    this.permission,
  });

  final String route;
  final String label;
  final IconData icon;
  final String? permission;
}

/// A collapsible group of [NavAction] children, shown under a single header.
class NavGroup {
  const NavGroup({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<NavAction> children;
}

/// Top-level nav entry: either a single item ([NavLeaf]) or a group
/// ([NavBranch]).
sealed class NavItem {
  const NavItem();
}

class NavLeaf extends NavItem {
  const NavLeaf(this.action);
  final NavAction action;
}

class NavBranch extends NavItem {
  const NavBranch(this.group);
  final NavGroup group;
}
