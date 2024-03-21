import 'package:get/get.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import '../../core/controller/app_controller.dart';
import '../../routes/app_navigator.dart';
import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';
import '../../../src/models/post_model.dart';
// import '../../../src/models/user_model.dart';

class AIPlanetLogic extends GetxController {
  final imLogic = Get.find<IMController>();


  RxList<String> aIPostTopic = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    _queryClientConfig();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onCreatePressed() {
    //print("发动态");
    AppNavigator.createPost(userInfo: imLogic.userInfo);
  }

  void processPost() async {
    print("post");
    //await DatabaseService.getAllPosts();
    await DatabaseService.queryPosts(10, 0, "createdUser", "user1");
    print("post end");
  }

  void processComment() async {
    print("processComment");
    await DatabaseService.createComment(
        imLogic.userInfo.value.userID!, "12345", "comment 11111111");
    // await DatabaseService.getPostComments("12345");
    // await DatabaseService.getCommentDetails("12345");
  }

  void processLikes() async {
    print("processLikes");
    // await DatabaseService.likePost("h94vHGSb6D");
    // await DatabaseService.unlikePost("HWjKfj8R4Y");
    // await DatabaseService.reportPost("HWjKfj8R4Y");
    // await DatabaseService.unreportPost("h94vHGSb6D");
    //await DatabaseService.bookmarkPost("QHUMuLkC8Y");
    //await DatabaseService.unbookmarkPost("12345", "Ujvu5yMJyK");
  }

  void processQuery() async {
    print("processQuery");
    await DatabaseService.getBookmarkedPosts("QHUMuLkC8Y");

    await DatabaseService.getConfigs();
    print("processQuery end");
  }

  void processFollower() async {
    print("processFollower");
    await DatabaseService.followUser("18XkpvluC1");
    // await DatabaseService.getFollowings();
    // await DatabaseService.getFollowers();
    // await DatabaseService.unfollowUser("18XkpvluC1");
    // await DatabaseService.getFollowings();
    // await DatabaseService.getFollowers();
    print("processFollower end");
  }

  void processDelete() async {
    print("processDelete");
    await DatabaseService.deletePost("12345");
    await DatabaseService.deleteComment("12345", "postid");
  }
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  RxInt selectIndex = 0.obs;


  final clientConfigMap = <String, dynamic>{}.obs;
  void _queryClientConfig() async {
    //final map = await Apis.getClientConfig();
    final map = await DatabaseService.getConfigs();
    clientConfigMap.assignAll(map);
    (clientConfigMap['topic'] as List).forEach((element) {
      aIPostTopic.add(element);
    });
    getList();
  }


   int limit = 6;
  RxList aiPosts = [].obs;
  void getList()async{
    aiPosts.clear();
    final data = await DatabaseService.getAllPostsByType(limit, aiPosts.length, aIPostTopic[selectIndex.value]);
    aiPosts.addAll(data);

  }
   getMoreList()async{
    final data = await DatabaseService.getAllPostsByType(limit, aiPosts.length, aIPostTopic[selectIndex.value]);
    aiPosts.addAll(data);
  }

  void changeSelectIndex(int index) {
    selectIndex.value = index;
    getList();
  }



}
