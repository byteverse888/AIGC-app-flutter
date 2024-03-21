import 'package:get/get.dart';

import 'create_post_logic.dart';

class CreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePostLogic());
  }
}
