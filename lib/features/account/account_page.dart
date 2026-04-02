import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final ThemeData theme = Theme.of(context);
    final user = appState.currentUser;

    if (!appState.usingBackend) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Account is available only in backend mode.'),
        ),
      );
    }

    if (!appState.isAuthenticated || user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.lock_outline, size: 38),
              const SizedBox(height: 8),
              Text(
                'Please sign in to manage your account.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Account', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Display name', value: user.displayName),
                    _InfoRow(label: 'Username', value: user.username),
                    _InfoRow(label: 'User ID', value: user.userId),
                    _InfoRow(label: 'Roles', value: user.roles.join(', ')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: appState.refreshCurrentUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('REFRESH'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: appState.signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('SIGN OUT'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
