import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../packages/app_info/app_info_provider.dart';
import '../packages/supabase/supabase_provider.dart';

/// Reusable widget displaying server domain, app version, and environment.
class AppVersionIndicator extends ConsumerWidget {
  const AppVersionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appInfoAsync = ref.watch(appInfoProvider);
    final env = currentEnvironment;
    final serverUrl = supabaseUrl;

    final domain = Uri.parse(serverUrl).host;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          domain,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            appInfoAsync.when(
              data: (info) => Text(
                'v${info.version}+${info.buildNumber}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              loading: () => Text(
                'v...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            if (env != 'prod') ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: env == 'dev'
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  env.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: env == 'dev' ? Colors.orange : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
