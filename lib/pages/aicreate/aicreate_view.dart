import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/controller/im_controller.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/aipost_container.dart';
import 'aicreate_logic.dart';

class AICreatePage extends StatefulWidget {
  AICreatePage({super.key});

  @override
  _AICreatePage createState() => _AICreatePage();
}

class _AICreatePage extends State<AICreatePage>
    with SingleTickerProviderStateMixin {
  final logic = Get.find<AICreateLogic>();
  final imLogic = Get.find<IMController>();

  late ScrollController _scrollController;
  late TabController _tabController;
  bool _loading = true;
  List<ParseObject> postList = [];

  static const List<Tab> myTabs = <Tab>[
    Tab(text: '文生图'),
    Tab(text: '图生图'),
    Tab(text: '对话机器人'),
  ];

  static const List<Text> tab_texts = <Text>[
    Text("发动态"),
    Text("筛选"),
    Text("任务堂")
  ];

  @override
  void initState() {
    super.initState();
    //_getAIPostList();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141415),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Tab(text: myTabs[0].text),
                Tab(text: myTabs[1].text),
              ],
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color(0xff7853E7),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  textToImage(),
                  imageToImage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient linearGradient = LinearGradient(colors: [
    Color(0xff1B2037),
    Color(0xff313A67),
    Color(0xff1B2037),
  ]);
  LinearGradient btnLinearGradient = LinearGradient(colors: [
    Color(0xff1B2037),
    Color(0xff313A67),
    Color(0xff1B2037),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  Widget textToImage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*画面描述",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xff7853E7), width: 2)),
                  child: Column(
                    children: [
                      TextField(
                        controller: logic.textCreateImageDescriptionController,
                        minLines: 3,
                        maxLines: 1000,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                          '画面描述以短句、短语为佳，建议40个字符以上: 风格选择和高级参数对图像生成有艺术修饰作用，支持中英文输入',
                          hintStyle:
                          TextStyle(color: Color(0xffB6B4C0), fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Spacer(),
                            Obx(() {
                              return Text(
                                '${logic.textCreateImageCLength.value}/1000',
                                style:
                                TextStyle(color: Colors.white, fontSize: 16),
                              );
                            }),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 16,
                              child: VerticalDivider(
                                color: Color(0xffB6B4C0),
                                width: 1,
                                thickness: 1,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('清空',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "主题",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: logic.topicList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 40),
                      itemBuilder: (context, index) {
                        var topic = logic.topicList[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            logic.selectTopicIndex.value = index;
                          },
                          child: Obx(() {
                            return Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff22262F),
                                borderRadius: BorderRadius.circular(40),
                                border: index == logic.selectTopicIndex.value
                                    ? Border.all(
                                    color: Color(0xffB6B4C0), width: 2)
                                    : null,
                                gradient: index == logic.selectTopicIndex.value
                                    ? linearGradient
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$topic',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        );
                      });
                }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*画面大小",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      6,
                          (index) {
                        var data = logic.sizeModelList[index];
                        return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                logic.selectSizeModelIndex.value = index;
                              },
                              child: Obx(() {
                                return Container(
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 4)
                                      .copyWith(
                                      left: index == 0 ? 0 : 4,
                                      right: index == 6 ? 0 : 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xff22262F),
                                    border: index == logic.selectSizeModelIndex.value
                                        ? Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    )
                                        : null,
                                    gradient: index == logic.selectSizeModelIndex.value
                                        ? linearGradient
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${data.width}:${data.height}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      Text(
                                        '${data.title}',
                                        style: TextStyle(
                                            color: Color(0xffB6B4C0),
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ));
                      }),
                ),
                SizedBox(
                  height: 8,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: logic.ratioModelList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 40),
                    itemBuilder: (context, index) {
                      var topic = logic.ratioModelList[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          logic.selectRatioModelIndex.value = index;
                        },
                        child: Obx(() {
                          return Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xff22262F),
                              borderRadius: BorderRadius.circular(40),
                              border: index == logic.selectRatioModelIndex.value
                                  ? Border.all(
                                  color: Color(0xffB6B4C0), width: 2)
                                  : null,
                              gradient: index == logic.selectRatioModelIndex.value
                                  ? linearGradient
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$topic',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*模型主题",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: logic.modelTopicList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 68),
                      itemBuilder: (context, index) {
                        var item = logic.modelTopicList[index];
                        return Obx(() {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              logic.selectModelTopicIndex.value = index;
                            },
                            child: Container(
                              decoration: index ==
                                  logic.selectModelTopicIndex.value
                                  ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  )
                              )
                                  : null,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          '${item['picUrl']}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (e, r, d) {
                                            return Icon(Icons.error_outline);
                                          },
                                        ),
                                      )),
                                  Text(
                                    '${item['title']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      });
                }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*风格选择",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: logic.styleList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 40),
                      itemBuilder: (context, index) {
                        var item = logic.styleList[index];
                        return Obx(() {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              logic.onTapSelectStyleList(index);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff22262F),
                                borderRadius: BorderRadius.circular(40),
                                border:   logic.selectStyleList.contains(index)
                                    ? Border.all(
                                    color: Color(0xffB6B4C0), width: 2)
                                    : null,
                                gradient:  logic.selectStyleList.contains(index)
                                    ? linearGradient
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${item}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        });
                      });
                }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*负面描述",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xff22262F), width: 2)),
                  child: Column(
                    children: [
                      TextField(
                        controller: logic
                            .textNegativeCreateImageDescriptionController,
                        minLines: 3,
                        maxLines: 1000,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入不想出现在画面中的内容，支持中英文',
                          hintStyle:
                          TextStyle(color: Color(0xffB6B4C0), fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Spacer(),
                            Obx(() {
                              return Text(
                                '${logic.textNegativeCreateImageCLength}/1000',
                                style:
                                TextStyle(color: Colors.white, fontSize: 16),
                              );
                            }),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 16,
                              child: VerticalDivider(
                                color: Color(0xffB6B4C0),
                                width: 1,
                                thickness: 1,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('清空',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "*作图数量",
                      style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        logic.subQuantity();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(0xff22262F),
                            borderRadius: BorderRadius.circular(4)),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                          Border.all(color: Color(0xff22262F), width: 2)),
                      child: TextField(
                        controller: logic.textQuantityCreateImageDescriptionController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[1-4]'))//设置只允许输入数字
                          ],
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: (){
                        logic.addQuantity();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(0xff22262F),
                            borderRadius: BorderRadius.circular(4)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 78,
                  decoration: BoxDecoration(
                    color: Color(0xff22262F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffB6B4C0), width: 2),
                    gradient: btnLinearGradient,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '普通分支',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '预计排队：2分钟内',
                        style:
                        TextStyle(color: Color(0xffB6B4C0), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 78,
                  decoration: BoxDecoration(
                    color: Color(0xff22262F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffB6B4C0), width: 2),
                    gradient: btnLinearGradient,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '潮汐模式',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '优惠低至五折，会员免费生成',
                        style:
                        TextStyle(color: Color(0xffB6B4C0), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '使用无界AI创作服务表示您已同意',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  TextSpan(
                      text: '《AI创作服务协议》',
                      style: TextStyle(color: Color(0xff7853E7), fontSize: 14)),
                  TextSpan(
                      text: '，',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  TextSpan(
                      text: '《二次元模型AI创作服务协议》',
                      style: TextStyle(color: Color(0xff7853E7), fontSize: 14))
                ])),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        createBtn(onTap: () {
          logic.textCreateImage();
        })
      ],
    );
  }

  Widget imageToImage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*上传图片",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    logic.showSelectImageDialog();
                  },
                  child: DottedBorder(
                    color: Color(0xff373640),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(16),
                    strokeWidth: 2,
                    child: Obx(() {
                      if (logic.imageFile.value != null) {
                        return Center(
                          child: Image.file(
                            logic.imageFile.value!,
                            width: double.infinity,
                            height: 360,),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        height: 360,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 100,
                              color: Color(0xff7853E7),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '点击上传图片',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              '支持图片格式：JPG，PNG，MAX：10MB',
                              style:
                              TextStyle(fontSize: 14, color: Color(0xff797D89)),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "*模型主题",
                  style: TextStyle(fontSize: 14, color: Color(0xffB6B4C0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xff22262F),
                        border: Border.all(
                          color: Color(0xffB6B5C9),
                          width: 1,
                        ),
                        gradient: linearGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '通用',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: logic.modelTopicList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 68),
                      itemBuilder: (context, index) {
                        var item = logic.modelTopicList[index];
                        return Obx(() {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              logic.selectModelTopicIndexByImage.value = index;
                            },
                            child: Container(
                              decoration: index ==
                                  logic.selectModelTopicIndexByImage.value
                                  ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  )
                              )
                                  : null,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          '${item['picUrl']}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (e, r, d) {
                                            return Icon(Icons.error_outline);
                                          },
                                        ),
                                      )),
                                  Text(
                                    '${item['title']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      });
                }),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 78,
                  decoration: BoxDecoration(
                    color: Color(0xff22262F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffB6B4C0), width: 2),
                    gradient: btnLinearGradient,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '普通分支',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '预计排队：2分钟内',
                        style:
                        TextStyle(color: Color(0xffB6B4C0), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 78,
                  decoration: BoxDecoration(
                    color: Color(0xff22262F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffB6B4C0), width: 2),
                    gradient: btnLinearGradient,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '潮汐模式',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '优惠低至五折，会员免费生成',
                        style:
                        TextStyle(color: Color(0xffB6B4C0), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '使用无界AI创作服务表示您已同意',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  TextSpan(
                      text: '《AI创作服务协议》',
                      style: TextStyle(color: Color(0xff7853E7), fontSize: 14)),
                  TextSpan(
                      text: '，',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  TextSpan(
                      text: '《二次元模型AI创作服务协议》',
                      style: TextStyle(color: Color(0xff7853E7), fontSize: 14))
                ])),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        createBtn(onTap: (){
          logic.imageCreateImage();
        })
      ],
    );
  }

  Widget createBtn({Function? onTap}) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 48,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient:
            LinearGradient(colors: [Color(0xff290DBE), Color(0xff8E27D2)])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '立即生成',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text('(消耗2积分))',
                    style: TextStyle(fontSize: 12, color: Colors.white))
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class AICreatePage extends StatefulWidget {
//   AICreatePage({super.key});
//   @override
//   _AICreatePage createState() => _AICreatePage();
// }
//
// class _AICreatePage extends State<AICreatePage>
//     with SingleTickerProviderStateMixin {
//   final logic = Get.find<AICreateLogic>();
//   final imLogic = Get.find<IMController>();
//
//   late ScrollController _scrollController;
//   late TabController _tabController;
//   bool _loading = true;
//   List<ParseObject> postList = [];
//
//   static const List<Tab> myTabs = <Tab>[
//     Tab(text: '文生图'),
//     Tab(text: '图生图'),
//     Tab(text: '对话机器人'),
//   ];
//
//   static const List<Text> tab_texts = <Text>[
//     Text("发动态"),
//     Text("筛选"),
//     Text("任务堂")
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     //_getAIPostList();
//     _tabController = TabController(vsync: this, length: myTabs.length);
//     _scrollController = ScrollController();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   //获取数据
//   // Future _getAIPostList() async {
//   //   setState(() {
//   //     postList = logic.postList;
//   //     _loading = false;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: myTabs[0].text),
//             Tab(text: myTabs[1].text),
//             Tab(text: myTabs[2].text),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: logic.onCreatePressed,
//               child: tab_texts[_tabController.index]),
//         ],
//         excludeHeaderSemantics: true,
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Obx(
//             () => SmartRefresher(
//               enablePullDown: true,
//               enablePullUp: true,
//               header: WaterDropMaterialHeader(
//                   backgroundColor: const Color(0xFF1B72EC)),
//               footer: CustomFooter(
//                 loadStyle: LoadStyle.ShowWhenLoading,
//                 builder: (BuildContext context, LoadStatus? mode) {
//                   return Container(
//                     height: 55.0,
//                     child: Center(child: CupertinoActivityIndicator()),
//                   );
//                 },
//               ),
//               controller: logic.postRefreshController,
//               onRefresh: logic.postOnRefresh,
//               onLoading: logic.postOnLoading,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         if (index < logic.postList.length) {
//                           var post = logic.postList.elementAt(index);
//                           print("come here for refresh");
//                           print(logic.postList.length);
//                           return AIPostContainer(post: post);
//                         }
//                       },
//                       childCount: logic.postList.length,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Icon(Icons.directions_bike),
//           Icon(Icons.directions_bike),
//         ],
//       ),
//     );
//   }
// }
