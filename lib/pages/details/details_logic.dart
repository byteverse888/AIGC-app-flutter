import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/controller/im_controller.dart';
import '../../routes/app_pages.dart';
import '../../src/parse_services/database_service.dart';
import '../../utils/sp_util.dart';

class DetailsLogic extends GetxController {
  List<String> tabs = ['作品信息', '评论', '权益/须知'];
  RxInt tabIndex = 0.obs;

  late String postId;
  FocusNode focusNode = FocusNode();
  late String toUserObjectId;

  Rxn<ParseObject> postDetails = Rxn<ParseObject>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    AppLogger.e(Get.parameters);
    postId = Get.parameters['id']!;
    getPostDetails();
    getBookmarkPost();
  }

  getPostDetails() async {
    var data = await DatabaseService.getPost(postId);
    postDetails.value = data;
    toUserObjectId = postDetails.value!['userpointer']?['objectId'];
    getFollowingInfo();
  }


  RefreshController refreshController =
  RefreshController(initialRefresh: true);
  RxList<ParseObject> commentList= <ParseObject>[].obs;
  getAIComment () async {
    commentList.clear();
    var data = await DatabaseService.getPostComments(postId);
    commentList.addAll(data??[]);
  }

   int limit = 30;
  getMoreAIComment () async {
    var data = await DatabaseService.getPostComments(postId,limit: limit,skip:commentList.length );
    commentList.addAll(data??[]);
    if((data??[]).isEmpty){
      refreshController.resetNoData();
    }
  }

  RxBool showSendCommentFlag = false.obs;

  showSendComment() {
    showSendCommentFlag.value = true;
    focusNode.requestFocus();
  }

  TextEditingController editingController = TextEditingController();

  sendComment() async{
    if (editingController.text.isNotEmpty) {
      var data = await DatabaseService.createComment(
          Get.find<IMController>().userInfo.value.userID!,
          postId,
          editingController.text);
      AppLogger.e(data);
      getAIComment();
      editingController.clear();
      showSendCommentFlag.value = false;
      focusNode.unfocus();
    }
  }


  deleteComment(String objectId)async{
   await DatabaseService.deleteComment(
        objectId,postId);
    getAIComment();
  }


  RxBool isFollowingUser = false.obs;
  getFollowingInfo()async{
    final currentUser = await ParseUser.currentUser();
    isFollowingUser.value = await DatabaseService.isFollowingUser(currentUser.objectId,toUserObjectId);
    AppLogger.e(isFollowingUser.value);
  }

  void followingUserAction()async{
    if(isFollowingUser.value){
      await DatabaseService.unfollowUser(toUserObjectId);
    }else{
      await DatabaseService.followUser(toUserObjectId);
    }
    isFollowingUser.value = !isFollowingUser.value;

  }


  RxBool isBookmarkPost = false.obs;

  getBookmarkPost()async{
    isBookmarkPost.value = await DatabaseService.isBookmarkedPosts(postId);
    AppLogger.e(isBookmarkPost.value);
  }

  void bookmarkPostAction()async{
    if(isBookmarkPost.value){
      await DatabaseService.unbookmarkPost(postId);
    }else{
      await DatabaseService.bookmarkPost(postId);
    }
    isBookmarkPost.value = !isBookmarkPost.value;
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
    postDetails.value!['likes'] = {'savedNumber': likeCount};
    postDetails.refresh();
  }


  /// 一键同款
  copyPost()async{
    var data  =jsonDecode(postDetails.value.toString());
    AppLogger.e(data);
    var post = await DatabaseService.createPostByTextToImage(
      data['caption']??"",
      data['topic']??"",
      data['negativedescription']??"",
      data['metadata']?['size']??"",
      data['metadata']?['ratio']??"",
      data['metadata']?['modeltopic']??"",
      data['metadata']?['style']??"",
      1,
    );

     Get.toNamed(AppRoutes.AICreateTasks, arguments: post);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
  }
}
