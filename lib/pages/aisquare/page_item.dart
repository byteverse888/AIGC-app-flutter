


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../routes/app_pages.dart';
import '../../src/parse_services/database_service.dart';
import '../../utils/app_logger.dart';
import '../../utils/app_smart_refresher.dart';
import '../../utils/get_data_util.dart';
import '../../utils/sp_util.dart';
import 'aisquare_logic.dart';

class PageIem extends StatefulWidget {
  final String topic;
  const PageIem({super.key, required this.topic});

  @override
  State<PageIem> createState() => _PageIemState();
}

class _PageIemState extends State<PageIem>     with AutomaticKeepAliveClientMixin {


  final logic = Get.find<AISquareLogic>();
  RefreshController refreshController = RefreshController(initialRefresh: true);
  int limit = 10;
  RxList aiPosts = [].obs;
  void getList() async {
    aiPosts.clear();
    final data = await DatabaseService.getAllPostsByType(
        limit, aiPosts.length, widget.topic);
    aiPosts.addAll(data);
  }

  getMoreList() async {
    final data = await DatabaseService.getAllPostsByType(
        limit, aiPosts.length, widget.topic);
    aiPosts.addAll(data);
    if ((data ?? []).isEmpty) {
      refreshController.resetNoData();
    }
  }

  likePost(String postId, bool isLike,int likeCount) async {
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
    aiPosts.forEach((element) {
      if (element['objectId'] == postId) {
        if (element['likes'] == null) {
          element['likes'] = {'savedNumber': likeCount};
        } else {
          element['likes'] = {'savedNumber': likeCount};
        }
      }
    });
    aiPosts.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return AppSmartRefresher(
        refreshController: refreshController,
        onLoading: getMoreList,
        onRefresh: getList,
        child: GridView.builder(
          padding: EdgeInsets.all(8),

          itemCount: aiPosts.length,
          itemBuilder: (context, index) {
            var data = aiPosts[index];
            var dataMap = jsonDecode(data.toString());
            AppLogger.e(aiPosts.length);
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.details, parameters: {
                  "id": dataMap['objectId'],
                });
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dataMap['imagesUrl']?['estimatedArray'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${(dataMap['imagesUrl']['estimatedArray'] as List).first}',
                          fit: BoxFit.fitHeight,
                          height: 190,
                        ),
                      ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${dataMap['title'] ?? dataMap['createdUser']}',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xff252526)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ClipOval(
                            child: Image.network(
                              '${dataMap['userpointer']?['faceURL']}',
                              width: 20,
                              height: 20,
                              errorBuilder: (e, e2, _) {
                                return Icon(Icons.person,size: 20,);
                              },
                            )),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            '${GetDataUtil.getPostUserName(dataMap['userpointer'])}',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff888789)),
                          ),
                        ),
                        Builder(builder: (context) {
                          var isLike = AppSpUtil()
                              .getLikeByPost(dataMap['objectId']);
                          var likeCount =
                              dataMap?['likes']?['savedNumber'] ?? 0;
                          return InkWell(
                            onTap: () {
                              likePost(dataMap['objectId'], !isLike,
                                  likeCount);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up_outlined,
                                    size: 12,
                                    color: isLike
                                        ? Colors.deepPurple
                                        : Color(0xff888789)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${dataMap?['likes']?['savedNumber'] ?? 0}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff888789)),
                                )
                              ],
                            ),
                          );
                        })
                      ],
                    )
                  ],
                ),
              ),
            );
          }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            mainAxisExtent: 246
        ),
        ),
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
