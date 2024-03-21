import 'package:get/get.dart';

import '../aiplanet/aiplanet_logic.dart';
import '../aisquare/aisquare_logic.dart';
//import '../workbench/workbench_logic.dart';
import '../contacts/contacts_logic.dart';
import '../aicreate/aicreate_logic.dart';
import '../conversation/conversation_logic.dart';
import '../mine/mine_logic.dart';

import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());

    Get.lazyPut(() => AIPlanetLogic());
    Get.lazyPut(() => AISquareLogic());
    Get.lazyPut(() => AICreateLogic());
    // Get.lazyPut(() => WorkbenchLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => MineLogic());
  }
}
