import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../routes/app_navigator.dart';
import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';

import '../../../src/models/post_model.dart';
import '../../../src/models/user_model.dart';
import '../../utils/sp_util.dart';

class AISquareLogic extends GetxController{
  final imLogic = Get.find<IMController>();

  // final postRefreshController = RefreshController(initialRefresh: false);
  // // var getPosts = <Post>[].obs;
  // List<ParseObject> getPosts = [];
  // int page = 1;

  @override
  void onInit() {
    super.onInit();
    _queryClientConfig();
  }

  @override
  void onReady() {
    // _getPostList(0, 10);
    super.onReady();
  }

//   void onCreatePressed() {
//     //print("发动态");
//     AppNavigator.createPost(userInfo: imLogic.userInfo);
//   }
//
//   Future<List<Post>> update_userinfo_from_post_userid(
//       List<Post> _getPosts) async {
//     //final UserInfo post_user;
//     var users_id_list = <String>[];
//     for (var _post in _getPosts) {
//       if (_post.userid != null) {
//         if (users_id_list.indexOf(_post.userid!) == -1) {
//           users_id_list.add(_post.userid!);
//         }
//       }
//     }
//     var user_list = await OpenIM.iMManager.userManager
//         .getUsersInfo(userIDList: users_id_list);
//     for (var _user in user_list) {
//       for (var _post in _getPosts) {
//         if (_post.userid == _user.userID) {
//           _post.user_faceURL = _user.faceURL;
//           print("update post user faceURL: $_post.user_faceURL");
//         }
//       }
//     }
//
//     return _getPosts;
//   }
//
//   Future<List<ParseObject>> _getPostList(int page, int limit) async {
//     var posts = await DatabaseService.getPosts(page, limit);
//
//     //update post author faceURL
//     //var _getPosts = await update_userinfo_from_post_userid(_getPosts_tmp);
//     if (page == 0) {
//       getPosts = posts;
//     }
//     return posts;
//   }
//
// // 下拉刷新
//   void postOnRefresh() async {
//     final refreshedPosts = await _getPostList(0, limit);
//     getPosts = refreshedPosts;
//     postRefreshController.refreshCompleted();
//   }
//
// // 上拉加载更多
//   void postOnLoading() async {
//     final loadedPosts = await _getPostList(page * limit, limit);
//     getPosts.addAll(loadedPosts);
//     page++;
//     postRefreshController.loadComplete();
//   }

  RxList<String> aIPostTopic = <String>[].obs;


  RefreshController refreshFollowingController =
      RefreshController(initialRefresh: true);

  RxInt selectIndex = 0.obs;

  final clientConfigMap = <String, dynamic>{}.obs;
  void _queryClientConfig() async {
    //final map = await Apis.getClientConfig();
    final map = await DatabaseService.getConfigs();
    clientConfigMap.assignAll(map);
    (clientConfigMap['topic'] as List).forEach((element) {
      aIPostTopic.add(element);
    });
  }



  PageController pageController = PageController();

  final ItemScrollController itemScrollController = ItemScrollController();
  // final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  // final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();


  void changeSelectIndex(int index) {
    selectIndex.value = index;
    pageController.jumpToPage(index);
  }

  RxList aiPostsByFollowing = [].obs;
  int limit = 10;
  void getFollowingList() async {
    aiPostsByFollowing.clear();
    final data =
        await DatabaseService.getmyFollowingPosts(limit, aiPostsByFollowing.length);
    aiPostsByFollowing.addAll(data ?? []);
  }

  getMoreFollowingList() async {
    final data =
        await DatabaseService.getmyFollowingPosts(limit, aiPostsByFollowing.length);
    aiPostsByFollowing.addAll(data ?? []);
    if ((data ?? []).isEmpty) {
      refreshFollowingController.resetNoData();
    }
  }


  likePostByFollowing(String postId, bool isLike,int likeCount) async {
    if(isLike){
      await DatabaseService.likePost(postId);
    }else{
      await DatabaseService.unlikePost(postId);
    }
    AppLogger.e( isLike);
    await AppSpUtil().setLikeByPost(postId,isLike);
    AppLogger.e( AppSpUtil().getLikeByPost(postId));


    if(isLike){
      likeCount++;
    }else{
      likeCount--;
    }
    if(likeCount<0){
      likeCount=0;
    }
    aiPostsByFollowing.forEach((element) {
      if (element['objectId'] == postId) {
        if (element['likes'] == null) {
          element['likes'] = {'savedNumber': likeCount};
        } else {
          element['likes'] = {'savedNumber': likeCount};
        }
      }
    });
    aiPostsByFollowing.refresh();
  }

  // Future<List<ParseObject>> _getPostList(int page, int limit) async {
  //   var posts = await DatabaseService.queryPosts(10, 0, "createdUser", "user1");
  //
  //   if (page == 0) {
  //     getPosts = posts;
  //   }
  //   return posts;
  // }
}
