import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../aiplanet/aiplanet_view.dart';
import '../aicreate/aicreate_view.dart';
import '../aisquare/aisquare_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import 'home_logic.dart';

//import '../workbench/workbench_view.dart';
//import '../contacts/contacts_view.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_FFFFFF,
          body: IndexedStack(
            index: logic.index.value,
            children: [
              AIPlanetPage(),
              AICreatePage(),
              AISquarePage(),
              //ContactsPage(),
              //WorkbenchPage(),
              ConversationPage(),
              MinePage(),
            ],
          ),
          bottomNavigationBar: BottomBar(
            index: logic.index.value,
            items: [
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab1Sel,
                unselectedImgRes: ImageRes.homeTab1Nor,
                label: "星球",
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab2Sel,
                unselectedImgRes: ImageRes.homeTab2Nor,
                label: "AI创作",
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
                //count: logic.unhandledCount.value,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab3Sel,
                unselectedImgRes: ImageRes.homeTab3Nor,
                label: "AI广场",
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab4Sel,
                unselectedImgRes: ImageRes.homeTab4Nor,
                label: "消息",
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
                onDoubleClick: logic.scrollToUnreadMessage,
                count: logic.unreadMsgCount.value,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab5Sel,
                unselectedImgRes: ImageRes.homeTab5Nor,
                label: StrRes.mine,
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
              ),
            ],
          ),
        ));
  }
}
