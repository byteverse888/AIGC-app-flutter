import 'package:get/get.dart';

import 'aicreate_tasks_logic.dart';

class AICreateTasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AICreateTasksLogic());
  }
}
