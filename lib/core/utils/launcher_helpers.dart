import 'package:url_launcher/url_launcher.dart';

abstract final class LauncherHelpers {
  static Future<void> openWhatsApp(String phone, {String? message}) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse(
      'https://wa.me/$cleanPhone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
