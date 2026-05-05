import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/application.dart';
import 'src/core/i18n/strings.g.dart';
import 'src/core/packages/supabase/supabase_provider.dart';
import 'src/core/utils/window_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());
  await WindowUtils.register();
  await initializeRuntimeDeployConfig();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  LocaleSettings.useDeviceLocale();

  runApp(
    ProviderScope(
      child: TranslationProvider(child: Application()),
    ),
  );
}
