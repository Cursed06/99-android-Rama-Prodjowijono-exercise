import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/search_results/search_results_page.dart';

/// The root widget of the application.
///
/// Configures MaterialApp, light theme tokens, and sets up
/// the initial route (defaults to [SearchResultsPage]).
class NinetyNineApp extends StatelessWidget {
  /// Optional home widget, allowing override in widget tests.
  final Widget? home;

  /// Creates the root [NinetyNineApp] instance.
  const NinetyNineApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '99.co Mobile Exercise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home ?? const SearchResultsPage(),
    );
  }
}
