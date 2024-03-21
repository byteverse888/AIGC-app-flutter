import 'package:get/get.dart';

import 'aisquare_logic.dart';

class AISquareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AISquareLogic());
  }
}
