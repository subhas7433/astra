import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';

class UpgradeDialog {
  static bool _isShowing = false;

  /// Show a non-dismissable upgrade dialog.
  /// Only shows one dialog at a time (prevents stacking from multiple API calls).
  static void show() {
    if (_isShowing) return;
    _isShowing = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Update Required'),
          content: const Text(
            'A new version of the app is available. '
            'Please update to continue using the app.',
          ),
          actions: [
            ElevatedButton(
              onPressed: _openStore,
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> _openStore() async {
    final url = Platform.isAndroid
        ? AppConstants.playStoreMarketUrl
        : AppConstants.appStoreUrl;

    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web URL if market:// doesn't work
        final webUrl = Uri.parse(Platform.isAndroid
            ? AppConstants.playStoreUrl
            : AppConstants.appStoreUrl);
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Failed to open store: $e');
    }
  }
}
