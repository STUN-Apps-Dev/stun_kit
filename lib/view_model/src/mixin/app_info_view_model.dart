import 'package:stun_kit/data/services/app_service.dart';
import 'package:stun_kit/library/url_launcher/url_launcher.dart';

class AppInfoViewModel {
  final AppService appService;

  AppInfoViewModel({required this.appService});

  Future<bool> launchPrivacyPolicy() async {
    final url = await appService.fetchPrivacyPolicyUrl();
    return _launchUrl(url);
  }

  Future<bool> rateApp() async {
    final url = await appService.fetchAppUrl();
    if (url.isEmpty) return false;
    return _launchUrl(url);
  }

  Future<bool> seeOtherApps() async {
    final url = await appService.fetchDeveloperUrl();
    if (url.isEmpty) return false;
    return _launchUrl(url);
  }

  Future<bool> launcEmail() async {
    final email = await appService.fetchDeveloperEmail();
    return UrlLauncher.launchEmail(email);
  }

  Future<bool> _launchUrl(String url) {
    return UrlLauncher.launchUrl(
      url: url,
      mode: UrlLaunchMode.externalApplication,
    );
  }
}
