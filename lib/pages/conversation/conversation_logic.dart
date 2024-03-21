import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../core/controller/app_controller.dart';
import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../contacts/add_by_search/add_by_search_logic.dart';
import '../home/home_logic.dart';

class ConversationLogic extends GetxController {
  final popCtrl = CustomPopupMenuController();
  final list = <ConversationInfo>[].obs;
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final appLogic = Get.find<AppController>();
  final refreshController = RefreshController();
  final tempDraftText = <String, String>{};
  final pageSize = 40;

  final imStatus = IMSdkStatus.connectionSucceeded.obs;

  late AutoScrollController scrollController;
  int scrollIndex = -1;

  @override
  void onInit() {
    scrollController = AutoScrollController(axis: Axis.vertical);
    imLogic.conversationAddedSubject.listen(onChanged);
    imLogic.conversationChangedSubject.listen(onChanged);
    homeLogic.onScrollToUnreadMessage = scrollTo;
    imLogic.imSdkStatusSubject.listen((value) {
      imStatus.value = value;
    });
    super.onInit();
  }

  /// 会话列表通过回调更新
  void onChanged(newList) {
    for (var newValue in newList) {
      // promptSoundOrNotification(newValue);
      list.remove(newValue);
    }
    list.insertAll(0, newList);
    _sortConversationList();
  }

  /// 提示音
  void promptSoundOrNotification(ConversationInfo info) {
    if (imLogic.userInfo.value.globalRecvMsgOpt == 0 &&
        info.recvMsgOpt == 0 &&
        info.unreadCount != null &&
        info.unreadCount! > 0 &&
        info.latestMsg?.sendID != OpenIM.iMManager.userID) {
      appLogic.promptSoundOrNotification(info.latestMsg!.seq!);
    }
  }

  @override
  void onReady() {
    onRefresh();
    super.onReady();
  }

  String getConversationID(ConversationInfo info) {
    return info.conversationID;
  }

  /// 标记会话已读
  void markMessageHasRead(ConversationInfo info) {
    _markMessageHasRead(conversationID: info.conversationID);
  }

  /// 置顶会话
  void pinConversation(ConversationInfo info) async {
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !info.isPinned!,
    );
  }

  /// 删除会话
  void deleteConversation(ConversationInfo info) async {
    await OpenIM.iMManager.conversationManager
        .deleteConversationAndDeleteAllMsg(
      conversationID: info.conversationID,
    );
    list.remove(info);
  }

  /// 根据id移除会话
  void removeConversation(String id) {
    list.removeWhere((e) => e.conversationID == id);
  }

  /// 设置草稿
  void setConversationDraft({required String cid, required String draftText}) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: cid,
      draftText: draftText,
    );
  }

  /// 会话前缀标签
  String? getPrefixTag(ConversationInfo info) {
    String? prefix;
    try {
      // 草稿
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          prefix = '[${StrRes.draftText}]';
        }
      } else {
        switch (info.groupAtType) {
          case GroupAtType.atAll:
            prefix = '[@${StrRes.everyone}]';
            break;
          case GroupAtType.atAllAtMe:
            prefix = '[@${StrRes.everyone} @${StrRes.you}]';
            break;
          case GroupAtType.atMe:
            prefix = '[@${StrRes.you}]';
            break;
          case GroupAtType.atNormal:
            break;
          case GroupAtType.groupNotification:
            prefix = '[${StrRes.groupAc}]';
            break;
        }
      }
    } catch (e, s) {
      Logger.print('e: $e  s: $s');
    }

    return prefix;
  }

  /// 解析消息内容
  String getContent(ConversationInfo info) {
    try {
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          return text;
        }
      }

      if (null == info.latestMsg) return "";

      final text = IMUtils.parseNtf(info.latestMsg!, isConversation: true);
      if (text != null) return text;

      return IMUtils.parseMsg(info.latestMsg!, isConversation: true);
    } catch (e, s) {
      Logger.print('------e:$e s:$s');
    }
    return '[${StrRes.unsupportedMessage}]';
  }

  Map<String, String> getAtUserMap(ConversationInfo info) {
    if (null != info.draftText && '' != info.draftText!.trim()) {
      var map = json.decode(info.draftText!);
      var atMap = map['at'];
      if (atMap.isNotEmpty && atMap is Map) {
        var v = <String, String>{};
        atMap.forEach((key, value) {
          v.addAll({'$key': "$value"});
        });
        return v;
      }
    }
    if (info.isGroupChat) {
      final map = <String, String>{};
      var message = info.latestMsg;
      if (message?.contentType == MessageType.at_text) {
        var list = message!.atTextElem!.atUsersInfo;
        list?.forEach((e) {
          map[e.atUserID!] = e.groupNickname ?? e.atUserID!;
        });
      }
      return map;
    }
    return {};
  }

  /// 头像
  String? getAvatar(ConversationInfo info) {
    return info.faceURL;
  }

  bool isGroupChat(ConversationInfo info) {
    return info.isGroupChat;
  }

  /// 显示名
  String getShowName(ConversationInfo info) {
    if (info.showName == null || info.showName.isBlank!) {
      return info.userID!;
    }
    return info.showName!;
  }

  /// 时间
  String getTime(ConversationInfo info) {
    return IMUtils.getChatTimeline(info.latestMsgSendTime!);
  }

  /// 未读数
  int getUnreadCount(ConversationInfo info) {
    return info.unreadCount ?? 0;
  }

  bool existUnreadMsg(ConversationInfo info) {
    return getUnreadCount(info) > 0;
  }

  /// 判断置顶
  bool isPinned(ConversationInfo info) {
    return info.isPinned!;
  }

  bool isNotDisturb(ConversationInfo info) {
    return info.recvMsgOpt != 0;
  }

  bool isUserGroup(int index) => list.elementAt(index).isGroupChat;

  /// 草稿
  /// 聊天页调用，不通过onWillPop事件返回，因为该事件会拦截ios的左滑返回上一页。
  void updateDartText({
    String? conversationID,
    required String text,
  }) {
    if (null != conversationID) tempDraftText[conversationID] = text;
  }

  /// 清空未读消息数
  void _markMessageHasRead({
    String? conversationID,
  }) {
    OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
      conversationID: conversationID!,
    );
  }

  /// 设置草稿
  void _setupDraftText({
    required String conversationID,
    required String oldDraftText,
    required String newDraftText,
  }) {
    if (oldDraftText.isEmpty && newDraftText.isEmpty) {
      return;
    }

    /// 保存草稿
    Logger.print('draftText:$newDraftText');
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: newDraftText,
    );
  }

  String? get imSdkStatus {
    switch (imStatus.value) {
      case IMSdkStatus.syncStart:
      case IMSdkStatus.synchronizing:
        return StrRes.synchronizing;
      case IMSdkStatus.syncFailed:
        return StrRes.syncFailed;
      case IMSdkStatus.connecting:
        return StrRes.connecting;
      case IMSdkStatus.connectionFailed:
        return StrRes.connectionFailed;
      case IMSdkStatus.connectionSucceeded:
      case IMSdkStatus.syncEnded:
        return null;
    }
  }

  bool get isFailedSdkStatus =>
      imStatus.value == IMSdkStatus.connectionFailed ||
      imStatus.value == IMSdkStatus.syncFailed;

  /// 自定义会话列表排序规则
  void _sortConversationList() =>
      OpenIM.iMManager.conversationManager.simpleSort(list);

  void onRefresh() async {
    late List<ConversationInfo> list;
    try {
      list = await _request(0);
      this.list.assignAll(list);
      if (list.isEmpty || list.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void onLoading() async {
    late List<ConversationInfo> list;
    try {
      list = await _request(this.list.length);
      this.list.addAll(list);
    } finally {
      if (list.isEmpty || list.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  _request(int offset) =>
      OpenIM.iMManager.conversationManager.getConversationListSplit(
        offset: offset,
        count: pageSize,
      );

  bool isValidConversation(ConversationInfo info) {
    return info.isValid;
  }

  // use this if total item count is known
  int scrollListenerWithItemCount() {
    int itemCount = list.length;
    double scrollOffset = scrollController.position.pixels;
    double viewportHeight = scrollController.position.viewportDimension;
    double scrollRange = scrollController.position.maxScrollExtent -
        scrollController.position.minScrollExtent;
    int firstVisibleItemIndex =
        (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
    return firstVisibleItemIndex;
  }

  void scrollTo() {
    if (list.isEmpty) return;
    // int first = scrollListenerWithItemCount();
    // int min = visibilityIndex.minOrNull ?? 0;
    // int start = max(first, min);
    int start = scrollListenerWithItemCount();
    if (start < scrollIndex) {
      start = scrollIndex;
    }
    if (scrollIndex == start) {
      start++;
    }
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      start = 0;
    }

    if (start > list.length - 1) return;
    final unreadItem =
        list.sublist(start).firstWhereOrNull((e) => e.unreadCount! > 0);
    if (null == unreadItem) {
      if (start > 0) {
        scrollController.scrollToIndex(
          scrollIndex = 0,
          preferPosition: AutoScrollPosition.begin,
        );
      }
      return;
    }
    final index = list.indexOf(unreadItem);
    scrollController.scrollToIndex(
      scrollIndex = index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  static Future<ConversationInfo> _createConversation({
    required String sourceID,
    required int sessionType,
  }) =>
      LoadingView.singleton.wrap(
          asyncFunction: () =>
              OpenIM.iMManager.conversationManager.getOneConversation(
                sourceID: sourceID,
                sessionType: sessionType,
              ));

  /// 打开系统通知页面
  Future<bool> _jumpOANtf(ConversationInfo info) async {
    if (info.conversationType == ConversationType.notification) {
      // 系统通知
      await AppNavigator.startOANtfList(info: info);
      // 标记已读
      _markMessageHasRead(conversationID: info.conversationID);
      return true;
    }
    return false;
  }

  /// 进入聊天页面
  void toChat({
    bool offUntilHome = true,
    String? userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    int? sessionType,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
  }) async {
    // 获取会话信息，若不存在则创建
    conversationInfo ??= await _createConversation(
      sourceID: userID ?? groupID!,
      sessionType: userID == null ? sessionType! : ConversationType.single,
    );

    // 标记已读
    // _markMessageHasRead(conversationID: conversationInfo.conversationID);

    // 如果是系统通知
    if (await _jumpOANtf(conversationInfo)) return;

    // 保存旧草稿
    updateDartText(
      conversationID: conversationInfo.conversationID,
      text: conversationInfo.draftText ?? '',
    );

    // 打开聊天窗口，关闭返回草稿
    /*var newDraftText = */
    await AppNavigator.startChat(
      offUntilHome: offUntilHome,
      draftText: conversationInfo.draftText,
      conversationInfo: conversationInfo,
      searchMessage: searchMessage,
    );

    // 读取草稿
    var newDraftText = tempDraftText[conversationInfo.conversationID];

    // 标记已读
    _markMessageHasRead(conversationID: conversationInfo.conversationID);

    // 记录草稿
    _setupDraftText(
      conversationID: conversationInfo.conversationID,
      oldDraftText: conversationInfo.draftText ?? '',
      newDraftText: newDraftText!,
    );

    // 回到会话列表
    // homeLogic.switchTab(0);

    bool equal(e) => e.conversationID == conversationInfo?.conversationID;
    // 删除所有@标识/公告标识
    var groupAtType = list.firstWhereOrNull(equal)?.groupAtType;
    if (groupAtType != GroupAtType.atNormal) {
      OpenIM.iMManager.conversationManager.resetConversationGroupAtType(
        conversationID: conversationInfo.conversationID,
      );
    }
  }

  scan() => AppNavigator.startScan();

  addFriend() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(
      defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.group);
}
