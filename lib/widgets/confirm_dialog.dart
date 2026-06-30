import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Shows a styled confirmation dialog. Returns true when confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title, style: AppTextStyles.headingMedium),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor:
                  destructive ? AppColors.danger : AppColors.navy900,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
