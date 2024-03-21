import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';

//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:openim/utils/app_logger.dart';
import '../../../widgets/widgets.dart';
import '../../core/controller/app_controller.dart';
import '../../routes/app_pages.dart';
import '../../src/models/travel_home_model.dart';

import '../../utils/app_smart_refresher.dart';
import 'aiplanet_logic.dart';

//from travel demo
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '搜索感兴趣的图片';

class NavigatorUtil {
  //跳转页面
  static push(BuildContext context, Widget page) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
    return result;
  }
}

// home page
class AIPlanetPage extends StatefulWidget {
  AIPlanetPage({super.key});

  @override
  _AIPlanetPage createState() => _AIPlanetPage();
}

class _AIPlanetPage extends State<AIPlanetPage>
    with SingleTickerProviderStateMixin {
  double appBarAlpha = 0;
  List<CommonModel> bannerList = []; // 轮播图列表
  List<CommonModel> localNavList = []; // local导航
  GridNavModel? gridNav; // 网格卡片
  List<CommonModel> subNavList = []; // 活动导航
  SalesBoxModel? salesBox; // salesBox数据
  bool _loading = true; // 页面加载状态
  String city = '北京市';

  // 缓存页面
  @override
  bool get wantKeepAlive => true;

  final logic = Get.find<AIPlanetLogic>();

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 判断滚动改变透明度
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

// 加载首页数据
  Future _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  // 跳转到城市列表
  void _jumpToCity() async {
    print("goto city page");
    //String result = await NavigatorUtil.push(context, CityPage(city: city));
    // setState(() {
    //   city = result;
    // });
  }

  // 跳转搜索页面
  void _jumpToSearch() {
    //NavigatorUtil.push(context, SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT));
    print("go to search page");
  }

  // 跳转语音识别页面
  void _jumpToSpeak() {
    //NavigatorUtil.push(context, SpeakPage());
    print("go to Speak page");
  }

  // 自定义appBar
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              city: city,
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: _jumpToCity,
              rightButtonClick: () {},
              onChanged: (String value) {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 0.5),
            ],
          ),
        )
      ],
    );
  }

  // banner 轮播图
  Widget get _banner {
    return Container(
        height: 160,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "https://via.placeholder.com/350x150",
              fit: BoxFit.fill,
            );
          },
          itemCount: 3,
          pagination: SwiperPagination(),
          control: SwiperControl(),
        ));
    // return Container(
    //   height: 160,
    //   child: Swiper(
    //     autoplay: true,
    //     loop: true,
    //     pagination: SwiperPagination(),
    //     itemCount: bannerList.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return CachedImage(
    //         imageUrl: bannerList[index].icon,
    //         fit: BoxFit.fill,
    //       );
    //     },
    //     onTap: (index) {
    //       NavigatorUtil.push(
    //         context,
    //         Webview(
    //           initialUrl: bannerList[index].url,
    //           hideAppBar: bannerList[index].hideAppBar,
    //           title: bannerList[index].title,
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  // listView列表
  Widget get _listView {
    return AppSmartRefresher(
      onLoading: logic.getMoreList,
      refreshController: logic.refreshController,
      child: ListView(
        children: <Widget>[
          /*轮播图*/
          _banner,
          /*local导航*/
          Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList),
          ),
          /*网格卡片*/
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNav: gridNav),
          ),
          /*活动导航*/
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList),
          ),
          /*底部卡片*/
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBox),
          ),
          /*AI 商用作品*/
          AIWorks()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: [
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    //滚动并且是列表滚动的时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return false;
                },
                child: _listView,
              ),
            ),
            _appBar
          ],
        ),
      ),
    );
  }

  Widget AIWorks() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  'AI 商品作品',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  '全部',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.grey,
                  size: 12,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                return Row(
                  children: List.generate(
                      logic.aIPostTopic.length,
                          (index) =>
                          InkWell(
                            onTap: () {
                              logic.changeSelectIndex(index);
                            },
                            child: Container(
                              decoration: logic.selectIndex.value == index
                                  ? BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20))
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Text(
                                '${logic.aIPostTopic[index]}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: logic.selectIndex.value == index
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          )),
                );
              }),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return GridView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: 16
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: logic.aiPosts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  var data = logic.aiPosts[index];
                  var dataMap = jsonDecode(data.toString());
                   AppLogger.e(dataMap);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Get.toNamed(AppRoutes.details,parameters: {
                        "id":dataMap['objectId'],
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                '${(dataMap?['imagesUrl']?['savedArray']as List).first}',
                                fit: BoxFit.cover,
                                errorBuilder: (e,r,s){
                                  return Icon(Icons.image_not_supported);
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              height: 36,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  ///整体模糊度
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(
                                          '${dataMap['title']??dataMap['createdUser']??""}', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          overflow: TextOverflow.ellipsis
                                        ),maxLines: 1,),),
                                        Text('${dataMap['shopping']?['price']??""}', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          })
        ],
      ),
    );
  }
}
