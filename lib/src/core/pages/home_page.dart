import 'package:flutter/material.dart';

import '../i18n/strings.g.dart';

/// Placeholder home screen for the app shell (no feature modules).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.common.appName),
      ),
      body: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Text(
            'Snak shell — add feature modules under lib/src/features/.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
