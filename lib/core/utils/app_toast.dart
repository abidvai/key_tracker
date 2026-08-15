import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
    String? title,
  }) {
    final config = _toastConfig(type);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          duration: const Duration(seconds: 3),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(config.icon, color: config.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          style: TextStyle(
                            color: config.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  static _ToastConfig _toastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF10B981),
        );
      case ToastType.error:
        return _ToastConfig(
          icon: Icons.cancel_rounded,
          color: const Color(0xFFEF4444),
        );
      case ToastType.warning:
        return _ToastConfig(
          icon: Icons.warning_rounded,
          color: const Color(0xFFF59E0B),
        );
      case ToastType.info:
        return _ToastConfig(
          icon: Icons.info_rounded,
          color: const Color(0xFF3B82F6),
        );
    }
  }
}

class _ToastConfig {
  final IconData icon;
  final Color color;
  const _ToastConfig({required this.icon, required this.color});
}
