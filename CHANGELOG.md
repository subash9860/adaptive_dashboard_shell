## 0.1.0

- Initial release.
- `AppDashboardShell`: adaptive shell with a collapsible side rail on
  desktop/tablet and an optional bottom navigation bar on mobile.
- Custom shadcn-style sidebar: rounded hover/active tiles, collapsible groups
  with an indented guide line, and an icon-only collapsed rail whose groups open
  as a flyout popup.
- Composable building blocks exported for custom chrome: `AppSidebar`,
  `SidebarHeader`, `SidebarGroup`, `SidebarCollapsedGroup`, `SidebarTile`,
  `SidebarFooter`, `SidebarAvatar`.
- `NavItem` / `NavLeaf` / `NavBranch` / `NavGroup` / `NavAction` navigation
  model and configurable `DashboardBreakpoints`.
- Zero third-party dependencies.
