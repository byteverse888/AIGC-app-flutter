import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../../core/controller/push_controller.dart';
import '../../../routes/app_navigator.dart';

class SetPasswordLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final nicknameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final enabled = false.obs;
  late String phoneNumber;
  late String areaCode;
  late int usedFor;
  late String verificationCode;
  String? invitationCode;

  @override
  void onClose() {
    nicknameCtrl.dispose();
    pwdCtrl.dispose();
    pwdAgainCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    usedFor = Get.arguments['usedFor'];
    verificationCode = Get.arguments['verificationCode'];
    invitationCode = Get.arguments['invitationCode'];
    nicknameCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    pwdAgainCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value = nicknameCtrl.text.trim().isNotEmpty &&
        pwdCtrl.text.trim().isNotEmpty &&
        pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
    if (nicknameCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterYourNickname);
      return false;
    }
    if (!IMUtils.isValidPassword(pwdCtrl.text)) {
      IMViews.showToast(StrRes.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      IMViews.showToast(StrRes.twicePwdNoSame);
      return false;
    }
    return true;
  }

  void nextStep() {
    if (_checkingInput()) {
      register();
    }
    // if (usedFor == 1) {
    //   // 注册
    //
    //   AppNavigator.startSetSelfInfo(
    //     areaCode: areaCode,
    //     phoneNumber: phoneNumber,
    //     password: pwdCtrl.text.trim(),
    //     usedFor: usedFor,
    //     verificationCode: verificationCode,
    //     invitationCode: invitationCode,
    //   );
    // } else if (usedFor == 2) {
    //   //重置密码
    // }
  }

  void register() async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      final data = await Apis.register(
        nickname: nicknameCtrl.text.trim(),
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: null,
        password: pwdCtrl.text,
        verificationCode: verificationCode,
        invitationCode: invitationCode,
      );
      if (null == IMUtils.emptyStrToNull(data.imToken) ||
          null == IMUtils.emptyStrToNull(data.chatToken)) {
        AppNavigator.startLogin();
        return;
      }
      final account = {"areaCode": areaCode, "phoneNumber": phoneNumber};
      await DataSp.putLoginCertificate(data);
      await DataSp.putLoginAccount(account);
      await imLogic.login(data.userID, data.imToken);
      Logger.print('---------im login success-------');
      //login parse-server
      // var parseUser =
      //     ParseUser(phoneNumber, "Passwd123", phoneNumber + "@163.com");
      // var parseResponse = await parseUser.save();
      // if (parseResponse.success) {
      //   print("parse server user register " + data.userID);
      // } else {
      //   print("parse server user register error!");
      //   print(parseResponse.error);
      //   //return Future.error(Exception("login failed, 用户名密码不对"));
      // }
      // parseResponse = await parseUser.login();
      // if (parseResponse.success) {
      //   print("parse server user login " + data.userID);
      // } else {
      //   print("parse server user login error!");
      //   print(parseResponse.error);
      //   return Future.error(Exception("login failed, 用户名密码不对"));
      // }

      pushLogic.login(data.userID);
      Logger.print('---------jpush login success----');
    });
    AppNavigator.startMain();
  }
}
