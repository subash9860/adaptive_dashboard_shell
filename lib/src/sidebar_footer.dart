import 'package:flutter/material.dart';
import 'sidebar_avatar.dart';
import 'sidebar_tile.dart';

/// Pinned footer at the bottom of the sidebar: an optional account row (avatar
/// + name + email) above the logout entry. With no [userName] only logout
/// shows.
class SidebarFooter extends StatelessWidget {
  const SidebarFooter({
    super.key,
    required this.collapsed,
    required this.onLogout,
    this.logoutLabel = 'Logout',
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.onProfileTap,
  });

  final bool collapsed;
  final VoidCallback onLogout;
  final String logoutLabel;
  final String? userName;
  final String? userEmail;
  final Widget? userAvatar;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUser = (userName ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.12)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasUser) _profileTile(context),
          SidebarTile(
            icon: Icons.logout_rounded,
            label: logoutLabel,
            selected: false,
            collapsed: collapsed,
            foreground: colorScheme.error,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  /// Account row: avatar + name + email (collapsed => avatar only). Taps fire
  /// [onProfileTap] when provided.
  Widget _profileTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final name = userName!.trim();
    final email = (userEmail ?? '').trim();

    final avatar = SidebarAvatar(
      name: name,
      custom: userAvatar,
      size: collapsed ? 32 : 34,
    );

    final content = collapsed
        ? Center(child: avatar)
        : Row(
            children: [
              avatar,
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 13.5,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          height: 1.15,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),
              if (onProfileTap != null)
                Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
            ],
          );

    Widget tile = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: colorScheme.onSurface.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 0 : 8,
            vertical: 6,
          ),
          child: content,
        ),
      ),
    );

    if (collapsed) {
      tile = Tooltip(
        message: email.isEmpty ? name : '$name\n$email',
        child: tile,
      );
    }

    return Padding(padding: const EdgeInsets.only(bottom: 4), child: tile);
  }
}
