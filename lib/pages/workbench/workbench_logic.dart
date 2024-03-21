import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import '../../routes/app_navigator.dart';
import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';

import '../../../src/models/post_model.dart';
import '../../../src/models/user_model.dart';

class WorkbenchLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  final postRefreshController = RefreshController(initialRefresh: false);
  var getPosts = <Post>[].obs;
  var getUsersNearby = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getPostList();
    getUserList();
    super.onReady();
  }

  void onCreatePressed() {
    //print("发动态");
    AppNavigator.createPost(userInfo: imLogic.userInfo);
  }

  Future<List<Post>> update_userinfo_from_post_userid(
      List<Post> _getPosts) async {
    //final UserInfo post_user;
    var users_id_list = <String>[];
    for (var _post in _getPosts) {
      if (_post.userid != null) {
        if (users_id_list.indexOf(_post.userid!) == -1) {
          users_id_list.add(_post.userid!);
        }
      }
    }
    var user_list = await OpenIM.iMManager.userManager
        .getUsersInfo(userIDList: users_id_list);
    for (var _user in user_list) {
      for (var _post in _getPosts) {
        if (_post.userid == _user.userID) {
          _post.user_faceURL = _user.faceURL;
          print("update post user faceURL: $_post.user_faceURL");
        }
      }
    }

    return _getPosts;
  }

  void getUserList() async {
    // var list = await OpenIM.iMManager.userManager.getUsersInfo(
    //   uidList: [info.value.userID!],
    // );
    // if (list.isNotEmpty) {
    //   var user = list.first;
    //   info.update((val) {
    //     val?.nickname = user.nickname;
    //     val?.faceURL = user.faceURL;
    //     val?.remark = user.remark;
    //     val?.gender = user.gender;
    //     val?.phoneNumber = user.phoneNumber;
    //     val?.birth = user.birth;
    //     val?.email = user.email;
    //     val?.isBlacklist = user.isBlacklist;
    //     val?.isFriendship = user.isFriendship;
    //   });
    // }

    var _getUsersNearby = await DatabaseService.getUsersNearby();
    getUsersNearby = RxList(_getUsersNearby);
  }

  void getPostList() async {
    //var _getPosts_tmp = await DatabaseService.getPostsFun("activity", 1, 10);
    var _getPosts = await DatabaseService.queryPosts(10, 0, "topic", "风景");

    //getPosts = RxList(_getPosts_tmp);
    print("xxxxxxx come here get post list");
    print(_getPosts.toString());
  }

  void postOnRefresh() {
    getPostList();
    postRefreshController.refreshCompleted();
  }

  void postOnLoading() {
    getPostList();
    postRefreshController.loadComplete();
  }

  void nearbyOnRefresh() async {
    var _getUsersNearby = await DatabaseService.getUsersNearby();
    getUsersNearby = RxList(_getUsersNearby);
    //nearbyRefreshController.refreshCompleted();
    postRefreshController.refreshCompleted();
  }

  void nearbyOnLoading() async {
    // getUsersNearby = await DatabaseService.getUsersNearby();
    // nearbyRefreshController.loadComplete();

    // DatabaseService.getUsersNearby()
    //     .then((value) => getUsersNearby.addAll(value))
    //     .whenComplete(() => nearbyRefreshController.loadComplete());
  }
}
