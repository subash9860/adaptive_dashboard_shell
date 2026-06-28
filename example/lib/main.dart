import 'package:adaptive_dashboard_shell/adaptive_dashboard_shell.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'adaptive_dashboard_shell example',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

const _navItems = <NavItem>[
  NavLeaf(
    NavAction(
      route: '/dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
    ),
  ),
  NavBranch(
    NavGroup(
      title: 'Sales',
      icon: Icons.point_of_sale_outlined,
      children: [
        NavAction(
          route: '/orders',
          label: 'Orders',
          icon: Icons.receipt_long_outlined,
        ),
        NavAction(
          route: '/invoices',
          label: 'Invoices',
          icon: Icons.description_outlined,
        ),
      ],
    ),
  ),
  NavLeaf(
    NavAction(
      route: '/settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
    ),
  ),
];

const _mobileNav = <NavAction>[
  NavAction(route: '/dashboard', label: 'Home', icon: Icons.home_outlined),
  NavAction(
    route: '/orders',
    label: 'Orders',
    icon: Icons.receipt_long_outlined,
  ),
  NavAction(
    route: '/settings',
    label: 'Settings',
    icon: Icons.settings_outlined,
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _route = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return AppDashboardShell(
      appTitle: 'Acme',
      logo: const FlutterLogo(),
      currentRoute: _route,
      items: _navItems,
      mobileNavItems: _mobileNav,
      userName: 'Ada Lovelace',
      userEmail: 'ada@example.com',
      onNavigate: (route) => setState(() => _route = route),
      onLogout: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logout tapped'))),
      child: Center(
        child: Text(
          'Current route:\n$_route',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
