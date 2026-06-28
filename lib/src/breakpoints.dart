import 'package:flutter/widgets.dart';

/// Width thresholds that decide the [AppDashboardShell] layout.
///
/// Defaults follow common Material breakpoints. Pass a custom instance to the
/// shell to tune where it switches between mobile, collapsed-rail and expanded.
class DashboardBreakpoints {
  const DashboardBreakpoints({this.mobile = 600, this.tablet = 1024})
    : assert(mobile <= tablet, 'mobile must be <= tablet');

  /// Below this width the shell uses the mobile layout: just the routed body
  /// plus an optional bottom navigation bar (no side rail).
  final double mobile;

  /// In `[mobile, tablet)` the side rail starts collapsed (tablet default).
  /// At or above [tablet] it starts expanded (desktop default).
  final double tablet;

  /// True when the current width is below [mobile].
  bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  /// True when the current width is in the tablet band `[mobile, tablet)`.
  bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobile && w < tablet;
  }
}
