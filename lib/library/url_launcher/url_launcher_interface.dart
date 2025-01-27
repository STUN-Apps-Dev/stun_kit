import 'package:flutter/foundation.dart';
import 'package:stun_kit/library/url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncher {
  static Future<bool> launchWhatsApp(String phone) async {
    final webUrl = 'https://api.whatsapp.com/send?phone=$phone';
    final mobileUrl = 'whatsapp://send/?phone=$phone';

    return launchUrlString(kIsWeb ? webUrl : mobileUrl);
  }

  static Future<bool> launchPhone(String phone) async {
    return launchUrlString('tel:$phone');
  }

  static Future<bool> launchEmail(String email) async {
    return launchUrlString('mailto:$email');
  }

  static Future<bool> launchUrl({
    required String url,
    String webOnlyWindowName = '_blank',
    UrlLaunchMode mode = UrlLaunchMode.platformDefault,
  }) async {
    return launchUrlString(
      url,
      webOnlyWindowName: webOnlyWindowName,
      mode: mode.toLaunchMode(),
    );
  }

  static String createValidUrl(String url) {
    return url.replaceAll('/#', '').replaceAll(r'\', '');
  }

  static Future<bool> canLaunchUrl(String url) async {
    return canLaunchUrlString(url);
  }
}
