import 'package:get/get.dart';

import 'create_aipost_logic.dart';

class CreateAIPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAIPostLogic());
  }
}
