import 'package:get/get.dart';

import 'create_comment_logic.dart';

class CreateCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateCommentLogic());
  }
}
