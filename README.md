# adaptive_dashboard_shell

An adaptive dashboard shell for Flutter: a collapsible, shadcn-style sidebar
rail on desktop and tablet that switches to a bottom navigation bar on mobile,
wrapping your routed content.

- **Adaptive** — side rail on desktop/tablet, bottom nav on mobile, driven by
  configurable width breakpoints.
- **Collapsible rail** — expanded panel ⇆ icon-only rail; collapsed groups open
  as a flyout popup (shadcn-style).
- **Router-agnostic** — you supply `currentRoute` and an `onNavigate` callback,
  so it works with `go_router`, `Navigator`, or anything else.
- **Presentational** — no providers, no permissions, no routing baked in. Filter
  your nav items however you like and pass them in.
- **Zero third-party dependencies** — pure Flutter / Material.

## Install

```yaml
dependencies:
  adaptive_dashboard_shell: ^0.1.0
```

## Usage

```dart
import 'package:adaptive_dashboard_shell/adaptive_dashboard_shell.dart';

final navItems = <NavItem>[
  const NavLeaf(NavAction(
    route: '/dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
  )),
  const NavBranch(NavGroup(
    title: 'Sales',
    icon: Icons.point_of_sale_outlined,
    children: [
      NavAction(route: '/orders', label: 'Orders', icon: Icons.receipt_long),
      NavAction(route: '/invoices', label: 'Invoices', icon: Icons.description),
    ],
  )),
];

AppDashboardShell(
  appTitle: 'Acme',
  logo: Image.asset('assets/logo.png'),
  currentRoute: currentRoute,           // e.g. GoRouterState.of(context).uri.toString()
  items: navItems,
  mobileNavItems: const [               // optional bottom nav (>= 2 entries)
    NavAction(route: '/dashboard', label: 'Home', icon: Icons.home),
    NavAction(route: '/orders', label: 'Orders', icon: Icons.receipt_long),
  ],
  userName: 'Ada Lovelace',
  userEmail: 'ada@example.com',
  onNavigate: (route) => context.go(route),
  onLogout: () => signOut(),
  child: routedChild,
);
```

### Custom breakpoints

```dart
AppDashboardShell(
  breakpoints: const DashboardBreakpoints(mobile: 700, tablet: 1100),
  // ...
);
```

- width `< mobile` → mobile layout (body + optional bottom nav)
- `[mobile, tablet)` → side rail, collapsed by default
- `>= tablet` → side rail, expanded by default

## Composing your own chrome

`AppDashboardShell` is built from smaller, exported widgets you can reuse
directly: `AppSidebar`, `SidebarHeader`, `SidebarGroup`,
`SidebarCollapsedGroup`, `SidebarTile`, `SidebarFooter` and `SidebarAvatar`.

## License

MIT — see [LICENSE](LICENSE).
