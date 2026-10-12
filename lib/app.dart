import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

/// The root widget of the application.
///
/// Configures MaterialApp, light theme tokens, and sets up
/// the initial route / home screen.
class NinetyNineApp extends StatelessWidget {
  /// Creates the root [NinetyNineApp] instance.
  const NinetyNineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '99.co Mobile Exercise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PlaceholderHomeScreen(),
    );
  }
}

/// Initial placeholder screen for Milestone 1 verification.
///
/// Will be replaced with SearchResultsPage in Milestone 3.
class _PlaceholderHomeScreen extends StatelessWidget {
  const _PlaceholderHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).dividerTheme.color,
            height: 1.0,
          ),
        ),
      ),
      body: const Center(
        child: Text('Milestone 1: Scaffold & Theme Ready'),
      ),
    );
  }
}
