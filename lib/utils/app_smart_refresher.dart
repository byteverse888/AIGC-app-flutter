


import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppSmartRefresher extends StatelessWidget {
  final RefreshController refreshController;
  final Function? onRefresh;
  final  Function? onLoading;
  final Widget? child;
  const AppSmartRefresher({super.key, required this.refreshController, this.onRefresh, this.onLoading, this.child});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus? mode){
          Widget body ;
          if(mode==LoadStatus.idle){
            body =  Text("上拉加载");
          }
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          else if(mode == LoadStatus.failed){
            body = Text("加载失败！点击重试！");
          }
          else if(mode == LoadStatus.canLoading){
            body = Text("松手,加载更多!");
          }
          else{
            body = Text("没有更多数据了!");
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child:child,
    );
  }

  void _onRefresh() async{
   await onRefresh?.call();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await onLoading?.call();
    refreshController.loadComplete();
  }
}
