import 'dart:async';

import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
import '../../routes/app_navigator.dart';

class MineLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  late StreamSubscription kickedOfflineSub;

  void viewMyQrcode() => AppNavigator.startMyQrcode();

  void viewMyInfo() => AppNavigator.startMyInfo();

  void copyID() {
    IMUtils.copy(text: imLogic.userInfo.value.userID!);
  }

  void accountSetup() => AppNavigator.startAccountSetup();

  void aboutUs() => AppNavigator.startAboutUs();

  // void workMoments() => WNavigator.startWorkMomentsList();

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(title: StrRes.logoutHint));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await imLogic.logout();
          await DataSp.removeLoginCertificate();

          //logout from parse-server
          var parseUser = await ParseUser.currentUser();
          if (parseUser != null) {
            var response = await parseUser.logout();
            if (!response.success) {
              print('User %user.username logout error');
            }
          }
          pushLogic.logout();
        });
        AppNavigator.startLogin();
      } catch (e) {
        IMViews.showToast('e:$e');
      }
    }
  }

  void kickedOffline() async {
    // await imLogic.logout();
    Get.snackbar(StrRes.accountWarn, StrRes.accountException);
    await DataSp.removeLoginCertificate();
    pushLogic.logout();
    AppNavigator.startLogin();
  }

  @override
  void onInit() {
    kickedOfflineSub = imLogic.onKickedOfflineSubject.listen((value) {
      kickedOffline();
    });
    super.onInit();
  }

  @override
  void onClose() {
    kickedOfflineSub.cancel();
    super.onClose();
  }
}
