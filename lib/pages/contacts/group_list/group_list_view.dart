import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_list_logic.dart';

class GroupListPage extends StatelessWidget {
  final logic = Get.find<GroupListLogic>();

  GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.myGroup),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchGroup,
            child: Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: const SearchBox(),
            ),
          ),
          Obx(
            () => CustomTabBar(
              labels: [StrRes.iCreatedGroup, StrRes.iJoinedGroup],
              index: logic.index.value,
              onTabChanged: (i) => logic.switchTab(i),
              showUnderline: true,
            ),
          ),
          Expanded(
            child: Obx(
              () => logic.index.value == 0
                  ? _buildICreatedListView()
                  : _buildIJoinedListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildICreatedListView() => ListView.builder(
        itemCount: logic.iCreatedList.length,
        itemBuilder: (_, index) => _buildItemView(logic.iCreatedList[index]),
      );

  Widget _buildIJoinedListView() => ListView.builder(
        itemCount: logic.iJoinedList.length,
        itemBuilder: (_, index) => _buildItemView(logic.iJoinedList[index]),
      );

  Widget _buildItemView(GroupInfo info) => Ink(
        height: 64.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.toGroupChat(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  text: info.groupName,
                  isGroup: true,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (info.groupName ?? '').toText
                      ..style = Styles.ts_0C1C33_17sp,
                    sprintf(StrRes.nPerson, [info.memberCount]).toText
                      ..style = Styles.ts_8E9AB0_14sp,
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
