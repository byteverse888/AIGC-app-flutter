import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/controller/app_controller.dart';

class AboutUsLogic extends GetxController {
  final version = "".obs;
  final appName = "App".obs;
  final appLogic = Get.find<AppController>();

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String buildNumber = packageInfo.buildNumber;
    version.value = packageInfo.version;
    appName.value = packageInfo.appName;
  }

  void checkUpdate() {
    appLogic.checkUpdate();
  }

  @override
  void onReady() {
    getPackageInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
