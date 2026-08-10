import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

/// Substituto do Get.showOverlay — exibe um dialog de loading enquanto
/// executa uma função assíncrona e o fecha automaticamente ao terminar.
class LoadingOverlay {
  static Future<T?> show<T>(
    BuildContext context,
    Future<T> Function() asyncFn, {
    Widget? loadingWidget,
    Color barrierColor = const Color(0xB3000000),
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      builder: (_) => loadingWidget ??
          const Material(
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.green_300),
            ),
          ),
    );
    try {
      final result = await asyncFn();
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      return result;
    } catch (e) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      rethrow;
    }
  }
}
