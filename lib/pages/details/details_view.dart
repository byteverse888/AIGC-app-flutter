import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:openim/utils/app_date_format.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:openim/utils/get_data_util.dart';
import 'package:openim_common/openim_common.dart';

import '../../utils/app_smart_refresher.dart';
import '../../utils/sp_util.dart';
import 'details_logic.dart';

class DetailsPage extends StatelessWidget {
  final logic = Get.find<DetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.focusNode.unfocus();
        logic.showSendCommentFlag.value = false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xff141416),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff141416),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Color(0xff383740), width: 2)),
              child: Icon(
                Icons.arrow_back,
                color: Color(0xff797C89),
                size: 30,
              ),
            ),
          ),
          title: Row(
            children: [
              Obx(() {
                if (logic.postDetails.value == null) {
                  return Container();
                }
                var dataMap = jsonDecode(logic.postDetails.value.toString());
                return ClipOval(
                  child: Image.network(
                    '${dataMap['userpointer']?['faceURL']}',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, _, __) {
                      return Container();
                    },
                  ),
                );
              }),
              SizedBox(
                width: 6,
              ),
              Obx(() {
                if (logic.postDetails.value == null) {
                  return Container();
                }
                var dataMap = jsonDecode(logic.postDetails.value.toString());
                return Expanded(
                  child: Text(
                    '${GetDataUtil.getPostUserName(dataMap['userpointer'])}',
                    style: TextStyle(color: Color(0xffB3B6C3)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    logic.followingUserAction();
                  },
                  child: Container(
                    height: 30,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: logic.isFollowingUser.value
                            ? Color(0xff7658D8)
                            : Color(0xff777D89), width: 2)),
                    child: Text(
                      logic.isFollowingUser.value ? '已关注' : '关注',
                      style: TextStyle(
                        color: logic.isFollowingUser.value
                            ? Color(0xff7658D8)
                            : Color(0xff777D89),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                width: 20,
              ),
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Color(0xff383740), width: 2)),
                  child: Icon(
                    Icons.ios_share,
                    color: Color(0xff797C89),
                    size: 24,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Obx(() {
          if (logic.postDetails.value == null) {
            return Container();
          }
          var dataMap = jsonDecode(logic.postDetails.value.toString());
          return Column(
            children: [
              Expanded(
                child: NestedScrollView(headerSliverBuilder: (context, bool) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    '${(dataMap['imagesUrl']['estimatedArray'] as List)
                                        .first}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/VIP.png',
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '汉服',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '${dataMap['metadata']?['modeltopic']??""}',
                                  style: TextStyle(
                                      color: Color(0xff777D89), fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              box1(dataMap),
                              SizedBox(
                                height: 20,
                              ),
                              box2(dataMap),
                              SizedBox(
                                height: 20,
                              ),
                              box3(dataMap),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                height: 48,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: Color(0xffEAEAEA), width: 2)),
                                child: Obx(() {
                                  return Row(
                                    children: logic.tabs.map((e) {
                                      var index = logic.tabs.indexOf(e);
                                      return Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              logic.tabIndex.value = index;
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: index ==
                                                  logic.tabIndex.value
                                                  ? BoxDecoration(
                                                  color: Color(0xff23262F),
                                                  borderRadius:
                                                  BorderRadius.circular(30))
                                                  : null,
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    color: index ==
                                                        logic.tabIndex.value
                                                        ? Colors.white
                                                        : Color(0xff7D808F),
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ];
                }, body: Obx(() {
                  return IndexedStack(
                    index: logic.tabIndex.value,
                    children: [workInformation(), review(), equity()],
                  );
                })),
              ),
              Obx(() {
                if (logic.showSendCommentFlag.value) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    constraints:
                    BoxConstraints(minHeight: 56, maxHeight: 56 * 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: TextField(
                                controller: logic.editingController,
                                minLines: 1,
                                maxLines: 1000,
                                focusNode: logic.focusNode,
                                autofocus: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xff23262F),
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            logic.sendComment();
                          },
                          child: Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              '确定',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff6F5FC4),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container(
                  height: 0,
                );
              })
            ],
          );
        }),
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
              color: Color(0xff141416),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, 40),
                    blurRadius: 20,
                    spreadRadius: 20
                )
              ]
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Obx(() {
            if (logic.postDetails.value == null) {
              return Container();
            }
            var dataMap = jsonDecode(logic.postDetails.value.toString());
            return Row(
              children: [
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      var isLike =
                      AppSpUtil().getLikeByPost(dataMap['objectId']);
                      var likeCount =
                          dataMap?['likes']?['savedNumber'] ?? 0;
                      return  bottomNavigationBarIconBtn(
                          Icons.thumb_up_outlined, '${dataMap?['likes']?['savedNumber'] ?? 0}',isLike, () {
                        logic.likePostByFollowing(
                            dataMap['objectId'], !isLike, likeCount);
                      });
                    }),
                    bottomNavigationBarIconBtn(Icons.favorite,logic.isBookmarkPost.value? '已收藏':'收藏',logic.isBookmarkPost.value, () {
                      logic.bookmarkPostAction();
                    }),
                    bottomNavigationBarIconBtn(Icons.message, '${logic.commentList.length}',false, () {
                      logic.showSendComment();
                    }),
                  ],
                )),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    logic.copyPost();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff7851EC),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    alignment: Alignment.center,
                    child: Text('一键同款', style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget bottomNavigationBarIconBtn(IconData iconData, String value,bool isActive,
      Function onTap) {
    return GestureDetector(
      onTap: (){
        onTap.call();
      },
      behavior:HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: isActive?Color(0xff7851EC):Colors.white,),
          Text(value, style: TextStyle(
              color: Colors.white,
              fontSize: 14
          ),)
        ],
      ),
    );
  }

  /// 论评
  Widget review() {
    return AppSmartRefresher(
      refreshController: logic.refreshController,
      onLoading: logic.getMoreAIComment,
      onRefresh: logic.getAIComment,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: logic.commentList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              children: [
                Text(
                  '评论(${logic.commentList.length})',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    logic.showSendComment();
                  },
                  child: Container(
                    width: 80,
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '写评论',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff6F5FC4),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                )
              ],
            );
          }
          index = index - 1;
          var model = logic.commentList[index];
          var dataMap = jsonDecode(model.toString());
          return InkWell(
            onTap: () {},
            onLongPress: () {
              showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('提示'),
                      content: Text('确认删除'),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('确认'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            AppLogger.e(dataMap);
                            logic.deleteComment(dataMap['objectId']);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('取消'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    '${dataMap['userpointer']?['faceURL']}',
                    width: 40,
                    height: 40,
                    errorBuilder: (q, w, e) {
                      return Icon(
                        Icons.person,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '${GetDataUtil.getPostUserName(dataMap['userpointer'])}·${AppDateFormat.getyyyymmddHHnnss(
                                DateTime.parse(dataMap['createdAt']))}',
                            style: TextStyle(color: Color(0xff7D7C89)),
                          ),
                          Spacer(),
                          // Icon(
                          //   Icons.favorite_border,
                          //   color: Color(0xff80828D),
                          //   size: 16,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${dataMap['content']}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(16),
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   decoration: BoxDecoration(
                      //       color: Color(0xff24262F),
                      //       borderRadius: BorderRadius.circular(8)),
                      //   child: ListView.separated(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: 5,
                      //     itemBuilder: (context, index) {
                      //       return Row(
                      //         crossAxisAlignment:
                      //         CrossAxisAlignment.start,
                      //         children: [
                      //           ClipOval(
                      //             child: Image.network(
                      //               'https://ts1.cn.mm.bing.net/th?id=OIP-C.ZwHbUNuM0nfxmPkkgMKKZAAAAA&w=176&h=185&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',
                      //               width: 30,
                      //               height: 30,
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 20,
                      //           ),
                      //           Expanded(
                      //             child: Column(
                      //               crossAxisAlignment:
                      //               CrossAxisAlignment.start,
                      //               children: [
                      //                 SizedBox(
                      //                   height: 2,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     Text(
                      //                       'Q6tUyvMV杨浩·08-11 23:19',
                      //                       style: TextStyle(
                      //                           color: Color(0xff7D7C89)),
                      //                     ),
                      //                     Spacer(),
                      //                     Icon(
                      //                       Icons.favorite_border,
                      //                       color: Color(0xff80828D),
                      //                       size: 16,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 Text.rich(TextSpan(children: [
                      //                   TextSpan(
                      //                       text: '回复 ',
                      //                       style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 12)),
                      //                   TextSpan(
                      //                       text: 'Q6tUyvMV杨浩: ',
                      //                       style: TextStyle(
                      //                           color: Color(0xff6F5FC4),
                      //                           fontSize: 12)),
                      //                   TextSpan(
                      //                       text: '确实优秀' * 10,
                      //                       style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 12)),
                      //                 ]))
                      //               ],
                      //             ),
                      //           )
                      //         ],
                      //       );
                      //     },
                      //     separatorBuilder:
                      //         (BuildContext context, int index) {
                      //       return SizedBox(
                      //         height: 20,
                      //       );
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 20,
          );
        },
      ),
    );
  }

  /// 权益须知
  Widget equity() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '购买前须知',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '您需特别注意，由于人工智能创作作品的法律法规尚在完善和仍在发展变化中，AI作品是否属于著作权法保护范围尚存争议，其权利认定、权利归属及法律性质可能会因为法律法规的发展发生变化，您在购买前已了解清楚，并自愿承受因此法律风险 (比如无法进行版权登记、AI作品不具有著作权等)及后续法律法规的不利变化可能产生的所有风险。',
              style: TextStyle(color: Color(0xff788188), fontSize: 16),
            ),
            Text(
              """一、AI作品版权权益须知1.您在购买AI作品版权后，转让方将同时向您转让作品的具体信息包括但不限于作品名称、尺寸、创作参数、关键词、画面描述、作品介绍等。如作品涉及使用底图或肖像权的，则转让方在此许可受让方使用。2.转让方向您转让的AI作品著作财产权包括但不限于复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权，及著作权人享有的其他著作财产相关权利 (人身权除外)。具体以国家法律法规认定为准。3.您理解并同意，一旦买断该作品版权，仅限于您个人使用，您不得再次将该作品上架交易或转让给他人，不得再次售卖该作品的授权许可使用权、改编权等著作权或其他衍生权利，即不得对外授权许可第三方以任何方式使用作品。4.作品转让后，转让方无权限制您就作品版权的授权活动，亦不能再就作品收益向您提供进一步要求。但您不得将该图片用于任何违反国家法律法规、政策、社会公序良俗或者色情淫秽、不道德的用途。5.转让方同意，您有权为指定作品及其作者进行线上线下媒体宣传推一传炸广江动时浩乃的作老信自从早2今作芝好 仔个人简介)和作品信息的，您有权无限制免费使用6.以上权利转让是排他的、独占的。转让方不得将指定作品的版权再次转让、授权给任何第三方，也不得自行开发。转让方违反上述约定的，应向您承担赔偿责任。
\n\n二、使用权权益须知:1.标准授权:无界版图授权您在有限的商业用途中使用作品，具体授权范围以授权许可协议为准。2.扩展授权:无界版图授权您在较为广泛的商业用途中使用作品，具体授权范围以授权许可协议为准。3.商品类授权:无界版图授权您在较为广泛的商业用途中使用作品具体授权范围以授权许可协议为准。4.购买许可使用权后，不视为版权已转让给被授权人，除协议中明确陈述的授权之外，无界版图未授予被授权人对作品的其他任何权利。5.您不得超出授权协议条款所约定和允许的使用范围。6.在本平台任何文件中，如无特别说明的，作品授权使用权/使用许可均不包括作品改编权/改编许可。
\n\n三、改编权权益须知:1.您按页面提示购买作品改编权后，可将作品改编为具有独创性的新作品，但一次购买仅对应唯一被授权主体，仅允许一位自然人或一个法人或一个非法人组织下载一次、改编一次作品。2.您在获得作品改编权后，不得侵犯原作者的署名权、修改权、保护作品完整权等作品著作人身权利，亦不得侵犯未经授权的作品其他财产权利。3.改编作品创作完成后，您依法享有改编作品的著作权，并享有包括但不限于许可他人复制、发行、出租、通过信息网络向公众传播并获得报酬等权利，您应在改编作品中注明作品原创作者的姓名/名称。""",
              style: TextStyle(color: Color(0xff7E7E86), fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Color(0xff363942),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '购买须知',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '1.依据法律要求，我们坚决反对作品的炒作、违规交易、侵权使用等行为。\n2.交易作品为虚拟商品，仅限实名认证的中国大陆用户且满18岁人群购买。\n3.AI作品一经出售不支持退换4.为更好服务无界版图平台的各位用户，请各位用户务必审慎阅读并同意相关协议规则后进行相应操作，以免造成不必要损失。',
              style: TextStyle(color: Color(0xff788188), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  ///作品信息
  Widget workInformation() {
    var dataMap = jsonDecode(logic.postDetails.value.toString());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    '${dataMap['userpointer']?['faceURL']}',
                    width: 80,
                    height: 80,
                    errorBuilder: (e,r,s){
                      return Icon(Icons.person,color: Colors.white,);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dataMap['userpointer']?['nickname']}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      '没有介绍哦',
                      style: TextStyle(color: Color(0xffB9BAC4), fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color(0xff363942),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '作品描述',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '装饰画',
              style: TextStyle(color: Color(0xffB9BAC4), fontSize: 18),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xff23262F)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                '当前持有者',
                                style: TextStyle(
                                    color: Color(0xff797B84), fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      '${dataMap['userpointer']?['faceURL']}',
                                      width: 30,
                                      height: 30,
                                      errorBuilder: (e,r,s){
                                        return Icon(Icons.person,color:Colors.white);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    '${dataMap['userpointer']?['nickname']}',
                                    style: TextStyle(
                                        color: Color(0xffB9BAC4), fontSize: 14),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                '链上Hash',
                                style: TextStyle(
                                    color: Color(0xff797B84), fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '0x226481aF9...969618#305',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xffB9BAC4), fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                '当前持有者',
                                style: TextStyle(
                                    color: Color(0xff797B84), fontSize: 16),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xffFADEBB),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.all_inclusive,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('查看存证'),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 12,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/images/pass.png',
                    width: 80,
                    height: 80,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container box3(Map dataMap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Color(0xff23262F)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.whatshot, color: Color(0xffB9BAC4)),
              SizedBox(
                width: 10,
              ),
              Text(
                '创作信息',
                style: TextStyle(color: Color(0xffB9BAC4), fontSize: 16),
              ),
            ],
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color(0xff363942),
          ),
          infoListTile('画面大小', '${dataMap['metadata']?['size']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('分辨率', '${dataMap['metadata']?['ratio']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('样式', '${dataMap['metadata']?['style']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('模型主题', '${dataMap['metadata']?['modeltopic']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('负面描述', '${dataMap['negativedescription']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('PU型号&编号', '${dataMap['GPUID']??"未知"}'),
          SizedBox(
            height: 10,
          ),
          infoListTile('主题', '${dataMap['topic']}'),
          
        ],
      ),
    );
  }

  Container box2(Map dataMap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Color(0xff23262F)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '画面描述',
                style: TextStyle(color: Color(0xffB9BAC4), fontSize: 16),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: dataMap['caption']??""));
                  IMViews.showToast('复制成功');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.copy,
                      color: Color(0xff7658D8),
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '全参复制',
                      style: TextStyle(color: Color(0xff7658D8), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color(0xff363942),
          ),
          Text(
            '${dataMap['caption']}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }

  Container box1(Map dataMap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Color(0xff23262F)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '许可使用权',
            style: TextStyle(color: Color(0xffB9BAC4), fontSize: 16),
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color(0xff363942),
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '下载原图',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '3积分',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '标准类授权',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '￥20',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '扩展类授权',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '￥60',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '商品类授权',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '￥100',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '其他授权类型',
            style: TextStyle(color: Color(0xffB9BAC4), fontSize: 16),
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Color(0xff363942),
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '买断',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '￥200',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '标准类授权',
                          style: TextStyle(
                            color: Color(0xff797B84),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '￥20',
                          style: TextStyle(color: Color(0xffD15E87)),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget infoListTile(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Color(0xff797B84), fontSize: 16),
        ),
        SizedBox(
          width: 100,
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class AppSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  AppSliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 48;

  @override
  // TODO: implement minExtent
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
