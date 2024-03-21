import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openim/core/controller/app_controller.dart';
import 'package:openim/pages/aisquare/page_item.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:openim/utils/app_smart_refresher.dart';
import 'package:openim/utils/sp_util.dart';
import 'package:openim/widgets/user_container.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../routes/app_pages.dart';
import '../../utils/app_date_format.dart';
import '../../utils/get_data_util.dart';
import 'aisquare_logic.dart';

// class _Photo {
//   _Photo({
//     required this.assetName,
//     required this.title,
//     required this.subtitle,
//   });
//
//   final String assetName;
//   final String title;
//   final String subtitle;
// }

class AISquarePage extends StatefulWidget {
  const AISquarePage({super.key});

  @override
  State<AISquarePage> createState() => _AISquarePageState();
}

class _AISquarePageState extends State<AISquarePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final logic = Get.find<AISquareLogic>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      unselectedLabelColor: Color(0xff747989),
                      tabs: [
                        Text('关注'),
                        Text('全部'),
                      ],
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Color(0xff7853E7),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.search))
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    follow(),
                    all(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget follow() {
    return Obx(() {
      return AppSmartRefresher(
        refreshController: logic.refreshFollowingController,
        onLoading: logic.getMoreFollowingList,
        onRefresh: logic.getFollowingList,
        child: ListView.separated(
          itemCount: logic.aiPostsByFollowing.length,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemBuilder: (context, index) {
            var mode = logic.aiPostsByFollowing[index];
            var dataMap = jsonDecode(mode.toString());
            AppLogger.e(dataMap);
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
                    Row(
                      children: [
                        ClipOval(
                            child: Image.network(
                          '${dataMap['userpointer']?['faceURL']}',
                          width: 40,
                          height: 40,
                          errorBuilder: (q, w, e) {
                            return Icon(Icons.person);
                          },
                        )),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${GetDataUtil.getPostUserName(dataMap['userpointer'])}',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ClipOval(
                            child: Container(
                          width: 2,
                          height: 2,
                          color: Color(0xff7F7D88),
                        )),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${AppDateFormat.getyyyymmddHHnnss(DateTime.parse(dataMap['createdAt']))}',
                          style:
                              TextStyle(color: Color(0xff7F7D88), fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${dataMap['caption']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Builder(builder: (context) {
                        String url = '';
                        try {
                          url =
                              '${(dataMap['imagesUrl']?['savedArray'] as List).first}';
                        } catch (e) {
                          return Container();
                        }
                        return Image.network(
                          '$url',
                          fit: BoxFit.cover,
                        );
                      }),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Builder(builder: (context) {
                          var isLike =
                              AppSpUtil().getLikeByPost(dataMap['objectId']);
                          var likeCount =
                              dataMap?['likes']?['savedNumber'] ?? 0;
                          return InkWell(
                            onTap: () {
                              logic.likePostByFollowing(
                                  dataMap['objectId'], !isLike, likeCount);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up_outlined,
                                    size: 16,
                                    color: isLike
                                        ? Colors.deepPurple
                                        : Color(0xff888789)),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    '${dataMap?['likes']?['savedNumber'] ?? 0}',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xff888789)),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        // Builder(builder: (context) {
                        //   var isLike =
                        //       AppSpUtil().getLikeByPost(dataMap['objectId']);
                        //   var likeCount =
                        //       dataMap?['likes']?['savedNumber'] ?? 0;
                        //   return InkWell(
                        //     onTap: () {
                        //       logic.likePostByFollowing(
                        //           dataMap['objectId'], !isLike, likeCount);
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Icon(Icons.star_border,
                        //             size: 16,
                        //             color: isLike
                        //                 ? Colors.deepPurple
                        //                 : Color(0xff888789)),
                        //         SizedBox(
                        //           width: 8,
                        //         ),
                        //         SizedBox(
                        //           width: 50,
                        //           child: Text(
                        //             '${dataMap?['likes']?['savedNumber'] ?? 0}',
                        //             style: TextStyle(
                        //                 fontSize: 12, color: Color(0xff888789)),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   );
                        // }),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Color(0xff80828D),
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                '${dataMap?['reportnum']?['savedNumber'] ?? 0}',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff80828D)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.details, parameters: {
                              "id": dataMap['objectId'],
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: Color(0xff80828D),
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  '${dataMap?['commentnum']?['savedNumber'] ?? 0}',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff80828D)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },
        ),
      );
    });
  }

  List<String> types = ['推荐', '最新', '同款↑', '点赞↑', '收藏↑'];

  Widget all() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 30,
            child: Row(
              children: [
                Expanded(
                    child: ScrollablePositionedList.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemPositionsListener: logic.itemPositionsListener,
                        itemScrollController: logic.itemScrollController,
                        itemCount: logic.aIPostTopic.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              logic.changeSelectIndex(index);
                            },
                            child: Obx(() {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: logic.selectIndex.value == index
                                        ? Color(0xffE5DCFE)
                                        : Color(0xffF5F6F7),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  '${logic.aIPostTopic[index]}',
                                  style: TextStyle(
                                      color: logic.selectIndex.value == index
                                          ? Color(0xff745AD6)
                                          : Colors.black,
                                      fontSize: 14),
                                ),
                              );
                            }),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        )),
                // Expanded(child: Builder(builder: (context) {
                //   if (logic.tabController == null) {
                //     return Container();
                //   }
                //   return TabBar(
                //     controller: logic.tabController,
                //     unselectedLabelStyle:
                //         TextStyle(color: Colors.black, fontSize: 14),
                //     labelStyle:
                //         TextStyle(color: Color(0xff745AD6), fontSize: 14),
                //     labelColor:Colors.black,
                //     tabs: logic.aIPostTopic.map((element) {
                //       var index = logic.aIPostTopic.indexOf(element);
                //       return Tab(
                //         child: Text(
                //           '$element',
                //           style: TextStyle(
                //               color: logic.selectIndex.value == index
                //                   ? Color(0xff745AD6)
                //                   : Colors.black,
                //               fontSize: 14),
                //         ),
                //       );
                //       // var index = logic.aIPostTopic.indexOf(element);
                //       return Container(
                //         padding:
                //             EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                //         decoration: BoxDecoration(
                //             color: logic.selectIndex.value == index
                //                 ? Color(0xffE5DCFE)
                //                 : Color(0xffF5F6F7),
                //             borderRadius: BorderRadius.circular(30)),
                //         child: Text(
                //           '${logic.aIPostTopic[index]}',
                //           style: TextStyle(
                //               color: logic.selectIndex.value == index
                //                   ? Color(0xff745AD6)
                //                   : Colors.black,
                //               fontSize: 14),
                //         ),
                //       );
                //     }).toList(),
                //   );
                // })),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.segment),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: types
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: e == '推荐'
                                      ? Color(0xff7459CB)
                                      : Color(0xff7A7F87)),
                            ),
                          ))
                      .toList(),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.filter_list_alt,
                    color: Color(0xff797C93),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: PageView.builder(
                  controller: logic.pageController,
                  onPageChanged: (i) {
                    if(logic.selectIndex.value!=i){
                      logic.itemScrollController.scrollTo(
                          index: i,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeInOutCubic);
                    }
                    logic.selectIndex.value = i;
                    // logic.itemScrollController.jumpTo( index: i);
                  },
                  itemCount: logic.aIPostTopic.length,
                  itemBuilder: (context, index) {
                    return PageIem(
                      topic: logic.aIPostTopic[index],
                    );
                  }))
        ],
      ),
    );
  }

  // pageItem(){
  //   return Obx(() {
  //     return AppSmartRefresher(
  //       refreshController: logic.refreshController,
  //       onLoading: logic.getMoreList,
  //       onRefresh: logic.getList,
  //       child: GridView.builder(
  //         padding: EdgeInsets.all(8),
  //
  //         itemCount: logic.aiPosts.length,
  //         itemBuilder: (context, index) {
  //           var data = logic.aiPosts[index];
  //           var dataMap = jsonDecode(data.toString());
  //           AppLogger.e(logic.aiPosts.length);
  //           return GestureDetector(
  //             onTap: () {
  //               Get.toNamed(AppRoutes.details, parameters: {
  //                 "id": dataMap['objectId'],
  //               });
  //             },
  //             child: Container(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   if (dataMap['imagesUrl']?['estimatedArray'] != null)
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.circular(10),
  //                       child: Image.network(
  //                         '${(dataMap['imagesUrl']['estimatedArray'] as List).first}',
  //                         fit: BoxFit.fitHeight,
  //                       ),
  //                     ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   Text(
  //                     '${dataMap['title'] ?? dataMap['createdUser']}',
  //                     style: TextStyle(
  //                         fontSize: 14, color: Color(0xff252526)),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     children: [
  //                       ClipOval(
  //                           child: Image.network(
  //                             '${dataMap['userpointer']?['faceURL']}',
  //                             width: 20,
  //                             height: 20,
  //                             errorBuilder: (e, e2, _) {
  //                               return Icon(Icons.person);
  //                             },
  //                           )),
  //                       SizedBox(
  //                         width: 6,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           '${GetDataUtil.getPostUserName(dataMap['userpointer'])}',
  //                           style: TextStyle(
  //                               fontSize: 12, color: Color(0xff888789)),
  //                         ),
  //                       ),
  //                       Builder(builder: (context) {
  //                         var isLike = AppSpUtil()
  //                             .getLikeByPost(dataMap['objectId']);
  //                         var likeCount =
  //                             dataMap?['likes']?['savedNumber'] ?? 0;
  //                         return InkWell(
  //                           onTap: () {
  //                             logic.likePost(dataMap['objectId'], !isLike,
  //                                 likeCount);
  //                           },
  //                           child: Row(
  //                             children: [
  //                               Icon(Icons.thumb_up_outlined,
  //                                   size: 12,
  //                                   color: isLike
  //                                       ? Colors.deepPurple
  //                                       : Color(0xff888789)),
  //                               SizedBox(
  //                                 width: 4,
  //                               ),
  //                               Text(
  //                                 '${dataMap?['likes']?['savedNumber'] ?? 0}',
  //                                 style: TextStyle(
  //                                     fontSize: 12,
  //                                     color: Color(0xff888789)),
  //                               )
  //                             ],
  //                           ),
  //                         );
  //                       })
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           mainAxisSpacing: 14,
  //           crossAxisSpacing: 8,
  //           mainAxisExtent: 246
  //       ),
  //       ),
  //     );
  //   });
  // }
}

// // import 'package:flutter/cupertino.dart';
// // import 'package:get/get.dart';
//
// // import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
// // import 'package:pull_to_refresh/pull_to_refresh.dart';
// // import 'aisquare_logic.dart';
// // import '../../../widgets/aisquare_container.dart';
//
// class _Photo {
//   _Photo({
//     required this.assetName,
//     required this.title,
//     required this.subtitle,
//   });
//
//   final String assetName;
//   final String title;
//   final String subtitle;
// }
//
// class AISquarePage extends StatelessWidget {
//   const AISquarePage({super.key});
//
//   List<_Photo> _photos(BuildContext context) {
//     return [
//       _Photo(
//         assetName: 'assets/places/india_chennai_flower_market.png',
//         title: "北京",
//         subtitle: "花卉市场",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_tanjore_bronze_works.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_tanjore_market_merchant.png',
//         title: "南京2",
//         subtitle: "工厂车间2",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_tanjore_thanjavur_temple.png',
//         title: "南京3",
//         subtitle: "工厂车间3",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_tanjore_thanjavur_temple_carvings.png',
//         title: "南京4",
//         subtitle: "工厂车间4",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_pondicherry_salt_farm.png',
//         title: "南京5",
//         subtitle: "工厂车间5",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_chennai_highway.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_chettinad_silk_maker.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_chettinad_produce.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_tanjore_market_technology.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_pondicherry_beach.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//       _Photo(
//         assetName: 'assets/places/india_pondicherry_fisherman.png',
//         title: "南京",
//         subtitle: "工厂车间",
//       ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("AI天堂"),
//       ),
//       body: GridView.count(
//         restorationId: 'grid_view_demo_grid_offset',
//         crossAxisCount: 2,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//         padding: const EdgeInsets.all(8),
//         childAspectRatio: 1,
//         children: _photos(context).map<Widget>((photo) {
//           return _GridDemoPhotoItem(photo: photo);
//         }).toList(),
//       ),
//     );
//   }
// }
//
// /// Allow the text size to shrink to fit in the space
// class _GridTitleText extends StatelessWidget {
//   const _GridTitleText(this.text);
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: BoxFit.scaleDown,
//       alignment: AlignmentDirectional.centerStart,
//       child: Text(text),
//     );
//   }
// }
//
// class _GridDemoPhotoItem extends StatelessWidget {
//   const _GridDemoPhotoItem({
//     required this.photo,
//   });
//
//   final _Photo photo;
//
//   @override
//   Widget build(BuildContext context) {
//     final Widget image = Semantics(
//       label: '${photo.title} ${photo.subtitle}',
//       child: Material(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         clipBehavior: Clip.antiAlias,
//         child: Image.asset(
//           photo.assetName,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//
//     return GridTile(
//       footer: Material(
//         color: Colors.transparent,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: GridTileBar(
//           backgroundColor: Colors.black45,
//           title: _GridTitleText(photo.title),
//           subtitle: _GridTitleText(photo.subtitle),
//         ),
//       ),
//       child: image,
//     );
//   }
// }
