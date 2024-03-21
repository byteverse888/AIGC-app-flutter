import 'package:get/get.dart';

import 'aiplanet_logic.dart';

class AIPlanetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AIPlanetLogic());
  }
}
