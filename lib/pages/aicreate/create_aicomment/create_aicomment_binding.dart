import 'package:get/get.dart';

import 'create_aicomment_logic.dart';

class CreateAICommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAICommentLogic());
  }
}
