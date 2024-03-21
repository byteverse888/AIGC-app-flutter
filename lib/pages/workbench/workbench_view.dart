import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'workbench_logic.dart';
import '../../../widgets/widgets.dart';

class WorkbenchPage extends StatefulWidget {
  //WorkbenchPage({Key key}) : super(key: key);
  @override
  _WorkbenchPage createState() => _WorkbenchPage();
}

class _WorkbenchPage extends State<WorkbenchPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.find<WorkbenchLogic>();

  late ScrollController _scrollController;
  late TabController _tabController;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '圈子'),
    Tab(text: '附近'),
    Tab(text: '星球'),
  ];

  static const List<Text> tab_texts = <Text>[
    Text("发动态"),
    Text("筛选"),
    Text("任务堂")
  ];

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: myTabs[0].text),
            Tab(text: myTabs[1].text),
            Tab(text: myTabs[2].text),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: logic.onCreatePressed,
              child: tab_texts[_tabController.index]),
        ],
        excludeHeaderSemantics: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(
                  backgroundColor: const Color(0xFF1B72EC)),
              footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus? mode) {
                  return Container(
                    height: 55.0,
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                },
              ),
              controller: logic.postRefreshController,
              onRefresh: logic.postOnRefresh,
              onLoading: logic.postOnLoading,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < logic.getPosts.length) {
                          var post = logic.getPosts.elementAt(index);
                          print("come here for refresh");
                          print(logic.getPosts.length);
                          return PostContainer(post: post);
                        }
                      },
                      childCount: logic.getPosts.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.directions_bike),
          Icon(Icons.directions_bike),
        ],
      ),
    );
  }
}
