// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:openim/widgets/widgets.dart';
//
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'aisquare_logic.dart';
// import '../../widgets/aipost_container.dart';
//
// class AISquarePage extends StatefulWidget {
//   //AISquarePage({Key key}) : super(key: key);
//   @override
//   _AISquarePage createState() => _AISquarePage();
// }
//
// class _AISquarePage extends State<AISquarePage>
//     with SingleTickerProviderStateMixin {
//   final logic = Get.find<AISquareLogic>();
//
//   late ScrollController _scrollController;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         title: Text('AI广场'),
//       ),
//       body: _buildAISquareItems(),
//     );
//   }
//
//   /// AI广场列表
//   Widget _buildAISquareItems() {
//     return SmartRefresher(
//       enablePullDown: true,
//       enablePullUp: true,
//       header: WaterDropMaterialHeader(
//           color: const Color(0xFF1B72EC),
//           backgroundColor: const Color(0xFFD7D7D7)),
//       footer: CustomFooter(
//         loadStyle: LoadStyle.ShowWhenLoading,
//         builder: (BuildContext context, LoadStatus? mode) {
//           return Container(
//             height: 55.0,
//             child: Center(child: CupertinoActivityIndicator()),
//           );
//         },
//       ),
//       controller: logic.postRefreshController,
//       onRefresh: logic.postOnRefresh,
//       onLoading: logic.postOnLoading,
//       child: CustomScrollView(
//         slivers: [
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 if (index < logic.getPosts.length) {
//                   var post = logic.getPosts.elementAt(index);
//                   print(logic.getPosts.length);
//                   return Text("BTG");
//                   //PostContainer(post: post);
//                 }
//               },
//               childCount: logic.getPosts == null ? 0 : logic.getPosts.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
