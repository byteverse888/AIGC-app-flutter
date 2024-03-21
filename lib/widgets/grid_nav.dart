import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';
import '../../src/models/travel_home_model.dart';

class GridNav extends StatelessWidget {
  final GridNavModel? gridNav;

  const GridNav({Key? key, this.gridNav}) : super(key: key);

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNav?.hotel != null) {
      items.add(_gridNavItem(context, gridNav!.hotel, true));
    }
    if (gridNav?.flight != null) {
      items.add(_gridNavItem(context, gridNav!.flight, false));
    }
    if (gridNav?.travel != null) {
      items.add(_gridNavItem(context, gridNav!.travel, false));
    }

    return items;
  }

  Widget _gridNavItem(
      BuildContext context, GridNavItem gridNavItem, bool first) {
    List items = [];
    List<Widget> expandItems = [];
    Color startColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));

    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    items.forEach((item) {
      expandItems.add(Expanded(
        child: item,
        flex: 1,
      ));
    });

    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //渐变
        gradient: LinearGradient(
          colors: [startColor, endColor],
        ),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
      context,
      Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          CachedImage(
            imageUrl: model.icon,
            fit: BoxFit.contain,
            height: 88,
            width: 121,
            alignment: Alignment.bottomCenter,
          ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child: Text(
              model.title ?? '',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      model,
    );
  }

  Widget _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: [
        Expanded(
          child: _item(
            context,
            topItem,
            true,
          ),
        ),
        Expanded(
          child: _item(
            context,
            bottomItem,
            false,
          ),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);

    return FractionallySizedBox(
      //撑满宽度
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: first ? borderSide : BorderSide.none,
          ),
        ),
        child: _wrapGesture(
          context,
          Center(
            child: Text(
              item.title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          item,
        ),
      ),
    );
  }

  Widget _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
          context,
          Webview(
            initialUrl: model.url,
            statusBarColor: model.statusBarColor,
            hideAppBar: model.hideAppBar,
            title: model.title,
          ),
        );
      },
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }
}
