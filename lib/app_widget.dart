import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/providers/theme_provider.dart';
import 'package:futzada/core/theme/app_themes.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/presentation/controllers/auth_controller.dart';

final _appBootProvider = FutureProvider<void>((ref) async {
  await AuthController.instance.boot();
});

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(_appBootProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Futzada',
      routerConfig: sl<GoRouter>(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
