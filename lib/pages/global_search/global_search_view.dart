import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'global_search_logic.dart';

class GlobalSearchPage extends StatelessWidget {
  final logic = Get.find<GlobalSearchLogic>();

  GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: Styles.c_F8F9FA,
        // body: Obx(() => logic.isSearchNotResult ? _emptyListView : SizedBox()),
        body: _emptyListView,
      ),
    );
  }

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 157.verticalSpace,
            // ImageRes.blacklistEmpty.toImage
            //   ..width = 120.w
            //   ..height = 120.h,
            // 22.verticalSpace,
            44.verticalSpace,
            StrRes.searchNotFound.toText..style = Styles.ts_8E9AB0_17sp,
          ],
        ),
      );
}
