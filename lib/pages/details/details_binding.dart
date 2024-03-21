import 'package:get/get.dart';

import 'details_logic.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailsLogic());
  }
}
