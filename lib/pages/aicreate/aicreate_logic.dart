import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim/core/controller/app_controller.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:openim/utils/file_update.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../routes/app_navigator.dart';
import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';

import '../../../src/models/post_model.dart';
import '../../../src/models/user_model.dart';
import '../../routes/app_pages.dart';

class SizeModel{
  final String title;
  final int width;
  final int height;
  SizeModel({required this.title,required this.width,required this.height});
}

class AICreateLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final postRefreshController = RefreshController(initialRefresh: false);

  var postList = <ParseObject>[].obs;
  var getUsersNearby = <User>[].obs;
  var topicList = <dynamic>[].obs;
  var selectTopicIndex = 0.obs;
  var modelTopicList = <dynamic>[].obs;
  var selectModelTopicIndex = 0.obs;
  var selectModelTopicIndexByImage = 0.obs;
  var styleList = <dynamic>[].obs;


  var  selectStyleList = [].obs;

  onTapSelectStyleList(int index){
    if(selectStyleList.contains(index)){
      selectStyleList.remove(index);
    }else{
      selectStyleList.add(index);
    }
  }


  List<SizeModel> sizeModelList = [
    SizeModel(title: '头像图', width: 1, height: 1),
    SizeModel(title: '手机屏幕', width: 1, height: 2),
    SizeModel(title: '社交媒体', width: 3, height: 4),
    SizeModel(title: '文章配图', width: 4, height: 3),
    SizeModel(title: '电脑壁纸', width: 16, height: 9),
    SizeModel(title: '宣传海报', width: 9, height: 16),
  ];
  var selectSizeModelIndex = 0.obs;

  List<String> ratioModelList = [
   "1024*1024",
    "2048*2048",
    "4096*4096",
    "2048*2048精",
  ];
  var selectRatioModelIndex = 0.obs;


  @override
  void onInit() {
    getPostList();
    getUserList();
    super.onInit();

    textCreateImageDescriptionController.addListener(() {
    textCreateImageCLength.value = textCreateImageDescriptionController.text.length;
    });
    textNegativeCreateImageDescriptionController.addListener(() {
      textNegativeCreateImageCLength.value = textNegativeCreateImageDescriptionController.text.length;
    });


    // var config = Get.find<AppController>().clientConfigMap;
    // AppLogger.e(Get.find<AppController>().clientConfigMap);
    // AppLogger.e(config["topic"].runtimeType);
    // topicList.addAll(config["topic"]?.toList()??[]);
    // styleList.addAll(config["style"]?.toList()??[]);
    // modelTopicList.addAll(config["modeltopic"]?.toList()??[]);
    _queryClientConfig();
  }

  void _queryClientConfig() async {
    //final map = await Apis.getClientConfig();
    final config = await DatabaseService.getConfigs();
    AppLogger.e(config);
    AppLogger.e(config["topic"]);
    topicList.addAll(config["topic"]??[]);
    styleList.addAll(config["style"]??[]);
    modelTopicList.addAll(config["modeltopic"]??[]);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onCreatePressed() {
    //print("发动态");
    AppNavigator.createAIPost(userInfo: imLogic.userInfo);
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
    //   });
    // }

    var _getUsersNearby = await DatabaseService.getUsersNearby();
    getUsersNearby = RxList(_getUsersNearby);
  }

  void getPostList() async {
    var posts = await DatabaseService.queryPosts(30, 1, "topic", "风景");

    postList = RxList(posts);

    //getPosts = RxList(posts);
    print("xxxxxxx come here get post list");
    //print(postList.toString());
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


  RxInt textCreateImageCLength = 0.obs;
  /// 文生图画面描述控制器
  TextEditingController textCreateImageDescriptionController = TextEditingController();
  RxInt textNegativeCreateImageCLength = 0.obs;
  /// 文生图画面描述控制器
  TextEditingController textNegativeCreateImageDescriptionController = TextEditingController();

  /// 文生图画面数量控制器
  TextEditingController textQuantityCreateImageDescriptionController = TextEditingController(text: '1');


  addQuantity(){
    num i = 1;
    try{
       i  = num.parse(textQuantityCreateImageDescriptionController.text);
       i++;
    }catch(e){
      textQuantityCreateImageDescriptionController.text = '1';
    }
    if(i>4){
      i=4;
    }
    textQuantityCreateImageDescriptionController.text = '$i';

  }
  subQuantity(){
    num i = 1;
    try{
      i  = num.parse(textQuantityCreateImageDescriptionController.text);
      i--;
    }catch(e){
      textQuantityCreateImageDescriptionController.text = '1';
    }
    if(i<1){
      i=1;
    }
    textQuantityCreateImageDescriptionController.text = '$i';

  }


  RxInt numberTextToImage=1.obs;
  /// 文字生成图片
  void textCreateImage() async{
      var post = await DatabaseService.createPostByTextToImage( textCreateImageDescriptionController.text,
      topicList[selectTopicIndex.value],
        textNegativeCreateImageDescriptionController.text,
        "${sizeModelList[selectSizeModelIndex.value].width}:${sizeModelList[selectSizeModelIndex.value].height}",
          "${ratioModelList[selectRatioModelIndex.value]}",
          "${modelTopicList[selectModelTopicIndex.value]['title']}",
          "${selectStyleList.map((element) => styleList[element])}" ,
          numberTextToImage.value,
      );
      AppLogger.e(post);
      // var data = await DatabaseService.getPost("${post.objectId}");
      // AppLogger.e(data);
      Get.toNamed(AppRoutes.AICreateTasks, arguments: post);
      //if upload image success
      // await DatabaseService.updatePost(post["objectId"],
      //     imagesUrl: mypost.imagesUrl!);

  }



  final imageFile = Rxn<File>();

  showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    Get.bottomSheet(CupertinoActionSheet(
      //title: Text('图片'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('拍摄'),
          onPressed: () => _handleImage(ImageSource.camera),
        ),
        CupertinoActionSheetAction(
          child: Text('从相册选择'),
          onPressed: () => _handleImage(ImageSource.gallery),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () => Get.back(),
      ),
    ));
  }

  _androidDialog() {
    Get.dialog(SimpleDialog(
      //title: Text('图片'),
      children: <Widget>[
        SimpleDialogOption(
          child: Text('拍摄'),
          onPressed: () => _handleImage(ImageSource.camera),
        ),
        SimpleDialogOption(
          child: Text('从相册选择'),
          onPressed: () => _handleImage(ImageSource.gallery),
        ),
        SimpleDialogOption(
          child: Text(
            '取消',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }


  String newImage='';
  _handleImage(ImageSource source) async {
    Get.back();
    var pickedImage = await ImagePicker().pickImage(
        source: source);
    if(pickedImage?.path!=null){
      imageFile.value = File(pickedImage!.path);
      FileUpdate.uploadImage(pickedImage.path,successCallBack: (v){
        newImage = v['accessUrl'];
        AppLogger.e(v);
      });
    }
  }


  /// 文字生成图片
  void imageCreateImage() async{
    var post = await DatabaseService.createPostByImageToImage(
        newImage,
        "${modelTopicList[selectModelTopicIndexByImage.value]['title']}",1);
    Logger.print(post);
    Get.toNamed(AppRoutes.AICreateTasks, arguments: post);
  }

}
