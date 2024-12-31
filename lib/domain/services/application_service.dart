import 'package:package_info_plus/package_info_plus.dart';
import 'package:stun_kit/data/services/application_service.dart';

class ApplicationServiceImpl implements ApplicationService {
  @override
  Future<String> fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    return '$version+$buildNumber';
  }
}
