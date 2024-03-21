import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:openim_common/openim_common.dart';

import 'create_aipost_logic.dart';
import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';
import '../../../src/models/post_model.dart';

class CreateAIPostPage extends StatefulWidget {
  @override
  _CreateAIPostPageState createState() => _CreateAIPostPageState();
}

class _CreateAIPostPageState extends State<CreateAIPostPage> {
  final logic = Get.find<CreateAIPostLogic>();
  final imLogic = Get.find<IMController>();

  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  var pickedImageList = <XFile>[];
  dynamic _pickImageError;
  int _pickImageNum = 0;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          //title: Text('图片'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('拍摄'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('从相册选择'),
              onPressed: () => _handleMultiImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //title: Text('图片'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('拍摄'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('从相册选择'),
              onPressed: () => _handleMultiImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                '取消',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    var _picked_image = await ImagePicker().pickImage(
        source: source, maxWidth: 200.0, maxHeight: 300.0, imageQuality: 80);
    if (_picked_image != null) {
      pickedImageList.add(_picked_image);
    }

    setState(() {
      _pickImageNum = pickedImageList.length;
    });
  }

  _handleMultiImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      var _imageFileList = await ImagePicker().pickMultiImage(
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );
      setState(() {
        if (_imageFileList != null) {
          pickedImageList.addAll(_imageFileList);
        }
        _pickImageNum = pickedImageList.length;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _cropImage(XFile? _pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70, //100
        // uiSettings: [
        //   AndroidUiSettings(
        //       toolbarTitle: 'Cropper',
        //       toolbarColor: Colors.deepOrange,
        //       toolbarWidgetColor: Colors.white,
        //       initAspectRatio: CropAspectRatioPreset.original,
        //       lockAspectRatio: false),
        //   IOSUiSettings(
        //     title: 'Cropper',
        //   ),
        //   // WebUiSettings(
        //   //   context: context,
        //   //   presentStyle: CropperPresentStyle.dialog,
        //   //   boundary: const CroppieBoundary(
        //   //     width: 520,
        //   //     height: 520,
        //   //   ),
        //   //   viewPort:
        //   //       const CroppieViewPort(width: 480, height: 480, type: 'circle'),
        //   // enableExif: true,
        //   // enableZoom: true,
        //   // showZoomer: true,
        //   //),
        // ],
      );
      // if (croppedFile != null) {
      //   setState(() {
      //     _croppedFile = croppedFile;
      //   });
      // }
      return croppedFile;
    }
  }

  _submit() async {
    if (!_isLoading && ((_pickImageNum > 0) || _caption.isNotEmpty)) {
      setState(() {
        _isLoading = true;
      });

      var authorId = imLogic.userInfo.value.getShowName();
      var userid = imLogic.userInfo.value.userID;
      var mypost = Post(authorId: authorId, userid: userid, caption: _caption);
      // if (_caption.isNotEmpty) {
      //   mypost.caption = _caption;
      // }

      //上传图片到minio or cos，具体传哪里看Config()
      if (Config.objectStorage == 'cos') {
        // var minio_client = Config.minio_client;
        // String img_path;
        // var imagesUrl = <String>[];
        // //final now = DateTime.now();
        // final currentTime = DateTime.now();
        // final imageTime = currentTime.year.toString() +
        //     currentTime.month.toString() +
        //     currentTime.day.toString();

        // for (var eachone in pickedImageList) {
        //   img_path = eachone.path;
        //   var img_path_list = img_path.split('/');
        //   var img_id = img_path_list[img_path_list.length - 1];
        //   //user/date/uuid
        //   var object =
        //       (userid ?? authorId) + '/' + imageTime + '/' + img_id.toString();
        //   final etag = await minio_client.fPutObject(
        //       Config.minio_bucket, object, img_path);

        //   var img_url = 'http://' +
        //       Config.host +
        //       ':9000/' +
        //       Config.minio_bucket +
        //       '/' +
        //       object;
        //   imagesUrl.add(img_url);
        //   print("上传一个图片完毕:$object");
        //   //HttpUtil.uploadImageForMinio(path: cropFile.path); //app origion
        // }

        mypost.imagesUrl = [
          "https://bkimg.cdn.bcebos.com/pic/14ce36d3d539b6003af371ec1e06222ac65c1038196b",
          "https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"
        ];
      }
      var post = await DatabaseService.createPost(userid!, '', _caption);
      //if upload image success
      await DatabaseService.updatePost(
          post["objectId"], {"imagesUrl": mypost.imagesUrl!});

      // Reset data
      _captionController.clear();

      setState(() {
        _caption = '';
        pickedImageList.clear();
        // _image = null;
        // picked_image = null;
        _isLoading = false;
      });

      Navigator.pop(context); //add for 发完不跳转，不重新刷新？
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //titleSpacing: 10,
        leading: BackButton(color: Colors.black),
        centerTitle: false,
        title: Text(
          '文生图',
          style: TextStyle(
            color: Colors.blue, //jincm
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            child: Text(
              '发布AI任务',
              style: TextStyle(
                color: Colors.blue, //
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(fontSize: 18.0),
                    minLines: 3,
                    maxLines: 5,
                    autofocus: true,
                    showCursor: true,
                    decoration: InputDecoration(
                      labelText: '输入你的想法，想象画面的关键字，以逗号隔开，然后等待。',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                    height: 500,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: _pickImageNum >= 9 ? 9 : _pickImageNum + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < _pickImageNum && index < 9) {
                          return Card(
                            color: Colors.white,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                  child: Image(
                                image: FileImage(
                                    File(pickedImageList[index].path)),
                              )),
                            ),
                          );
                        } else {
                          return Card(
                            color: Colors.white,
                            child: GestureDetector(
                              onTap: _showSelectImageDialog,
                              child: Container(
                                height: width,
                                width: width,
                                //color: Colors.amber[100],
                                color: Colors.blue,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white70,
                                  size: 150.0,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
