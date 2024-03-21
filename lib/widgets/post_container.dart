import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:openim_common/openim_common.dart';

import '../../routes/app_navigator.dart';
import '../../widgets/widgets.dart';
import '../core/controller/im_controller.dart';
import '../../src/parse_services/database_service.dart';
import '../../src/models/post_model.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  String? classname;

  PostContainer({
    Key? key,
    required this.post,
    this.classname,
  }) : super(key: key);

  List<Widget> _getImageList() {
    var list = <Widget>[];
    if (post.imagesUrl == null) {
      return list;
    }
    var length = post.imagesUrl!.length > 9 ? 9 : post.imagesUrl!.length;
    for (var index = 0; index < length; index++) {
      list.add(Container(
        child: CachedNetworkImage(
            imageUrl: post.imagesUrl![index], fit: BoxFit.fill),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var post_images = _getImageList();
    var post_height = 128.0;
    if (post_images.length > 3 && post_images.length <= 6) {
      post_height = 240;
    } else if (post_images.length > 6) {
      post_height = 360;
    }

    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: isDesktop ? 5.0 : 0.0,
      ),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(post: post),
                  const SizedBox(height: 4.0),
                  Text(post.caption ?? "啥也没有...."),
                  post.imagesUrl != null
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 6.0),
                ],
              ),
            ),
            post.imagesUrl != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        height: post_height,
                        child: Card(
                            color: Colors.white,
                            shadowColor: Colors.white10,
                            //surfaceTintColor: Colors.red,
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 3,
                              children: post_images,
                              physics: const NeverScrollableScrollPhysics(),
                            ))),
                  )
                : const SizedBox.shrink(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _PostStats(post: post),
            // ),
            _PostStats(post: post)
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;
  final imLogic = Get.find<IMController>();

  _PostHeader({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var post_userid = post.userid;
    //get_userinfo_from_post_userid(post.userid);

    return GestureDetector(
        onTap: () => AppNavigator
            .startMyInfo(), //AppNavigator.startFriendRequests(info: UserInfo(userID: post.userid)), //
        child: Row(
          children: [
            post.user_faceURL != null
                ? AvatarView(url: post.user_faceURL!)
                : AvatarView(),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${post.timestamp} • ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                        ),
                      ),
                      Icon(
                        Icons.public,
                        color: Colors.grey[600],
                        size: 12.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (post.userid == imLogic.userInfo.value.userID)
              IconButton(
                icon: const Icon(Icons.delete_sharp),
                onPressed: () => _onDelete(post),
              ),
          ],
        ));
  }
}

class _PostStats extends StatelessWidget {
  final Post post;
  final imLogic = Get.find<IMController>();
  var likes = 0.obs;
  var reports = 0.obs;

  _PostStats({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    likes = RxInt(post.likes ?? 0);
    reports = RxInt(post.reports ?? 0);

    return Column(
      children: [
        //const Divider(),
        Obx(
          () => Row(
            children: [
              _PostButton(
                icon: Icon(
                  MdiIcons.thumbUpOutline,
                  color: Colors.grey[600],
                  size: 20.0,
                ),
                label: likes.value.toString(), // '${likes != 0 ? $likes : ''}',
                onTap: () => {likes.value++, _onLike(post)},
              ),

              _PostButton(
                icon: Icon(
                  MdiIcons.commentOutline,
                  color: Colors.grey[600],
                  size: 20.0,
                ),
                label: '${post.comments != null ? post.comments : ''}',
                onTap: () => _onCreateComment(post),
              ),
              // _PostButton(
              //   icon: Icon(
              //     MdiIcons.shareOutline,
              //     color: Colors.grey[600],
              //     size: 25.0,
              //   ),
              //   label: '分享',
              //   onTap: () => print('Share'),  //收藏
              // ),
              _PostButton(
                icon: Icon(
                  MdiIcons.alarmNote,
                  color: Colors.grey[600],
                  size: 25.0,
                ),
                label: reports.value.toString(), // '举报',
                onTap: () => {
                  reports.value++,
                  _onReport(imLogic.userInfo.value.userID!, post)
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function()? onTap;

  const _PostButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _onCreateComment(Post post) {
  //print("评论");
  AppNavigator.createComment(post: post);
}

void _onLike(Post post) {
  DatabaseService.likePost(post.id!);
}

void _onReport(String userId, Post post) {
  DatabaseService.reportPost(userId, post.id!);
}

void _onDelete(Post post) async {
  //IMUtil;
  var confirm = await Get.dialog(CustomDialog(
    title: "确定要删除？",
  ));
  if (confirm == true) {
    try {
      await DatabaseService.deletePost(post.id!);
    } catch (e) {
      // AppNavigator.startLogin();
      IMViews.showToast('e:$e');
    }
  }
}
