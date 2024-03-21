import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../group_requests_logic.dart';

class ProcessGroupRequestsLogic extends GetxController {
  final groupRequestsLogic = Get.find<GroupRequestsLogic>();
  late GroupApplicationInfo applicationInfo;

  @override
  void onInit() {
    applicationInfo = Get.arguments['applicationInfo'];
    super.onInit();
  }

  bool get isInvite => groupRequestsLogic.isInvite(applicationInfo);

  String get groupName => groupRequestsLogic.getGroupName(applicationInfo);

  String get inviterNickname =>
      groupRequestsLogic.getInviterNickname(applicationInfo);

  GroupMembersInfo? getMemberInfo(inviterUserID) =>
      groupRequestsLogic.getMemberInfo(inviterUserID);

  UserInfo? getUserInfo(inviterUserID) =>
      groupRequestsLogic.getUserInfo(inviterUserID);

  /// 2：通过邀请  3：通过搜索  4：通过二维码
  String get sourceFrom {
    if (applicationInfo.joinSource == 2) {
      return '$inviterNickname${StrRes.byMemberInvite}';
    } else if (applicationInfo.joinSource == 4) {
      return StrRes.byScanQrcode;
    }
    return StrRes.bySearch;
  }

  void approve() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () =>
                OpenIM.iMManager.groupManager.acceptGroupApplication(
                  groupID: applicationInfo.groupID!,
                  userID: applicationInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: 1));
  }

  void reject() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () =>
                OpenIM.iMManager.groupManager.refuseGroupApplication(
                  groupID: applicationInfo.groupID!,
                  userID: applicationInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: -1))
        .catchError((_) => IMViews.showToast(StrRes.rejectFailed));
  }
}
