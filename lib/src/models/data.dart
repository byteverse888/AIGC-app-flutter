import 'dart:convert';
import 'package:dio/dio.dart';

//trip model and data

/// 保护方法
T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class TripModel {
  Config_trip config;
  List<CommonModel> bannerList;
  List<CommonModel> localNavList;
  GridNavModel gridNav;
  List<CommonModel> subNavList;
  SalesBoxModel salesBox;

  TripModel({
    required this.config,
    required this.bannerList,
    required this.localNavList,
    required this.gridNav,
    required this.subNavList,
    required this.salesBox,
  });

  factory TripModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<CommonModel>? bannerList =
        jsonRes['bannerList'] is List ? <CommonModel>[] : null;
    if (bannerList != null) {
      for (final dynamic item in jsonRes['bannerList']!) {
        if (item != null) {
          bannerList
              .add(CommonModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CommonModel>? localNavList =
        jsonRes['localNavList'] is List ? <CommonModel>[] : null;
    if (localNavList != null) {
      for (final dynamic item in jsonRes['localNavList']!) {
        if (item != null) {
          localNavList
              .add(CommonModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CommonModel>? subNavList =
        jsonRes['subNavList'] is List ? <CommonModel>[] : null;
    if (subNavList != null) {
      for (final dynamic item in jsonRes['subNavList']!) {
        if (item != null) {
          subNavList
              .add(CommonModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    return TripModel(
      config:
          Config_trip.fromJson(asT<Map<String, dynamic>>(jsonRes['config'])!),
      bannerList: bannerList!,
      localNavList: localNavList!,
      gridNav:
          GridNavModel.fromJson(asT<Map<String, dynamic>>(jsonRes['gridNav'])!),
      subNavList: subNavList!,
      salesBox: SalesBoxModel.fromJson(
          asT<Map<String, dynamic>>(jsonRes['salesBox'])!),
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'config': config,
        'bannerList': bannerList,
        'localNavList': localNavList,
        'gridNav': gridNav,
        'subNavList': subNavList,
        'salesBox': salesBox,
      };

  TripModel clone() => TripModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Config_trip {
  Config_trip({
    required this.searchUrl,
  });

  factory Config_trip.fromJson(Map<String, dynamic> jsonRes) => Config_trip(
        searchUrl: asT<String>(jsonRes['searchUrl'])!,
      );

  String searchUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'searchUrl': searchUrl,
      };

  Config_trip clone() => Config_trip.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class GridNavModel {
  GridNavModel({
    required this.hotel,
    required this.flight,
    required this.travel,
  });

  factory GridNavModel.fromJson(Map<String, dynamic> jsonRes) => GridNavModel(
        hotel:
            GridNavItem.fromJson(asT<Map<String, dynamic>>(jsonRes['hotel'])!),
        flight:
            GridNavItem.fromJson(asT<Map<String, dynamic>>(jsonRes['flight'])!),
        travel:
            GridNavItem.fromJson(asT<Map<String, dynamic>>(jsonRes['travel'])!),
      );

  GridNavItem hotel;
  GridNavItem flight;
  GridNavItem travel;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hotel': hotel,
        'flight': flight,
        'travel': travel,
      };

  GridNavModel clone() => GridNavModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class CommonModel {
  CommonModel({
    required this.icon,
    required this.url,
    this.title,
    this.hideAppBar,
    this.statusBarColor,
  });

  factory CommonModel.fromJson(Map<String, dynamic> jsonRes) => CommonModel(
        title: jsonRes['title'] ?? '',
        icon: jsonRes['icon'] ?? '',
        url: jsonRes['url'] ?? '',
        hideAppBar: jsonRes['hideAppBar'] ?? false,
        statusBarColor: jsonRes['statusBarColor'] ?? '',
      );

  String icon;
  String url;
  String? title;
  bool? hideAppBar;
  String? statusBarColor;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'icon': icon,
        'url': url,
        'hideAppBar': hideAppBar,
        'statusBarColor': statusBarColor,
      };

  CommonModel clone() => CommonModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class GridNavItem {
  GridNavItem({
    required this.startColor,
    required this.endColor,
    required this.mainItem,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4,
  });

  factory GridNavItem.fromJson(Map<String, dynamic> jsonRes) => GridNavItem(
        startColor: asT<String>(jsonRes['startColor'])!,
        endColor: asT<String>(jsonRes['endColor'])!,
        mainItem: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['mainItem'])!),
        item1:
            CommonModel.fromJson(asT<Map<String, dynamic>>(jsonRes['item1'])!),
        item2:
            CommonModel.fromJson(asT<Map<String, dynamic>>(jsonRes['item2'])!),
        item3:
            CommonModel.fromJson(asT<Map<String, dynamic>>(jsonRes['item3'])!),
        item4:
            CommonModel.fromJson(asT<Map<String, dynamic>>(jsonRes['item4'])!),
      );

  String startColor;
  String endColor;
  CommonModel mainItem;
  CommonModel item1;
  CommonModel item2;
  CommonModel item3;
  CommonModel item4;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'startColor': startColor,
        'endColor': endColor,
        'mainItem': mainItem,
        'item1': item1,
        'item2': item2,
        'item3': item3,
        'item4': item4,
      };

  GridNavItem clone() => GridNavItem.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class SalesBoxModel {
  SalesBoxModel({
    required this.icon,
    required this.moreUrl,
    required this.bigCard1,
    required this.bigCard2,
    required this.smallCard1,
    required this.smallCard2,
    required this.smallCard3,
    required this.smallCard4,
  });

  factory SalesBoxModel.fromJson(Map<String, dynamic> jsonRes) => SalesBoxModel(
        icon: asT<String>(jsonRes['icon'])!,
        moreUrl: asT<String>(jsonRes['moreUrl'])!,
        bigCard1: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['bigCard1'])!),
        bigCard2: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['bigCard2'])!),
        smallCard1: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['smallCard1'])!),
        smallCard2: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['smallCard2'])!),
        smallCard3: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['smallCard3'])!),
        smallCard4: CommonModel.fromJson(
            asT<Map<String, dynamic>>(jsonRes['smallCard4'])!),
      );

  String icon;
  String moreUrl;
  CommonModel bigCard1;
  CommonModel bigCard2;
  CommonModel smallCard1;
  CommonModel smallCard2;
  CommonModel smallCard3;
  CommonModel smallCard4;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'icon': icon,
        'moreUrl': moreUrl,
        'bigCard1': bigCard1,
        'bigCard2': bigCard2,
        'smallCard1': smallCard1,
        'smallCard2': smallCard2,
        'smallCard3': smallCard3,
        'smallCard4': smallCard4,
      };

  SalesBoxModel clone() => SalesBoxModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

// final Activity activity1 = Activity(
//     id: "a1111",
//     fromUserId: "jincm1020",
//     postId: "post 20",
//     postImageUrl:
//         "https://cn.bing.com/images/search?view=detailV2&ccid=QFdwl07%2f&id=1C8280D2D75B8653FE4F0AA4FA7416EFB30A9059&thid=OIP.QFdwl07_aviM1ch2KpyyFgHaEo&mediaurl=https%3a%2f%2fwww.keaidian.com%2fuploads%2fallimg%2f190424%2f24110307_4.jpg&exph=1200&expw=1920&q=%e5%9b%be%e7%89%87&simid=608031476871739714&FORM=IRPRST&ck=8D9642E506965EDD50F890B71B499E49&selectedIndex=2",
//     comment: "comment20",
//     timestamp: "2022");

//

var tripData = TripModel.fromJson(tripJsonRes);

var tripJsonRes = {
  "config": {
    "searchUrl":
        "https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword="
  },
  "bannerList": [
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/100h10000000q7ght9352.jpg",
      "url":
          "https://gs.ctrip.com/html5/you/travels/1422/3771516.html?from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F"
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/300h0u000000j05rnD96B_C_500_280.jpg",
      "url":
          "https://m.ctrip.com/webapp/vacations/tour/detail?productid=3168213&departcityid=2&salecityid=2&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F"
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/jdsc_640es_tab1.jpg",
      "url":
          "https://m.ctrip.com/events/jiudianshangchenghuodong.html?disable_webview_cache_key=1"
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/CghzfVWw6OaACaJXABqNWv6ecpw824_C_500_280_Q90.jpg",
      "url":
          "https://m.ctrip.com/webapp/vacations/tour/detail?productid=53720&departcityid=2&salecityid=2&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F"
    }
  ],
  "localNavList": [
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/ln_ticket.png",
      "title": "景点·玩乐",
      "url": "https://m.ctrip.com/html5/ticket/",
      "statusBarColor": "19A0F0",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/ln_weekend.png",
      "title": "周边游",
      "url": "https://m.ctrip.com/html5/you/around",
      "statusBarColor": "19A0F0",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/ln_food.png",
      "title": "美食林",
      "url":
          "https://m.ctrip.com/webapp/you/foods/address.html?new=1&ishideheader=true",
      "statusBarColor": "19A0F0",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/ln_oneday.png",
      "title": "一日游",
      "url": "https://dp.ctrip.com/webapp/activity/daytour",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/ln_guide.png",
      "title": "当地攻略",
      "url": "https://m.ctrip.com/webapp/you/",
      "statusBarColor": "19A0F0",
      "hideAppBar": true
    }
  ],
  "gridNav": {
    "hotel": {
      "startColor": "fa5956",
      "endColor": "fa9b4d",
      "mainItem": {
        "title": "酒店",
        "icon":
            "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/grid-nav-items-hotel.png",
        "url": "https://m.ctrip.com/webapp/hotel/",
        "statusBarColor": "4289ff"
      },
      "item1": {
        "title": "海外酒店",
        "url": "https://m.ctrip.com/webapp/hotel/oversea/?otype=1",
        "statusBarColor": "4289ff"
      },
      "item2": {
        "title": "特价酒店",
        "url": "https://m.ctrip.com/webapp/hotel/hotsale"
      },
      "item3": {
        "title": "团购",
        "url":
            "https://m.ctrip.com/webapp/tuan/?secondwakeup=true&dpclickjump=true",
        "hideAppBar": true
      },
      "item4": {
        "title": "民宿 客栈",
        "url": "https://m.ctrip.com/webapp/inn/index",
        "hideAppBar": true
      }
    },
    "flight": {
      "startColor": "4b8fed",
      "endColor": "53bced",
      "mainItem": {
        "title": "机票",
        "icon":
            "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/grid-nav-items-flight.png",
        "url": "https://m.ctrip.com/html5/flight/swift/index"
      },
      "item1": {
        "title": "火车票",
        "url":
            "https://m.ctrip.com/webapp/train/?secondwakeup=true&dpclickjump=true&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F#/index?VNK=4e431539",
        "hideAppBar": true
      },
      "item2": {
        "title": "特价机票",
        "url": "https://m.ctrip.com/html5/flight/swift/index"
      },
      "item3": {
        "title": "汽车票·船票",
        "url": "https://m.ctrip.com/html5/Trains/bus/",
        "hideAppBar": true
      },
      "item4": {
        "title": "专车·租车",
        "url":
            "https://m.ctrip.com/webapp/car/index?s=ctrip&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F",
        "hideAppBar": true
      }
    },
    "travel": {
      "startColor": "34c2aa",
      "endColor": "6cd557",
      "mainItem": {
        "title": "旅游",
        "icon":
            "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/grid-nav-items-travel.png",
        "url": "https://m.ctrip.com/webapp/vacations/tour/vacations",
        "hideAppBar": true,
        "statusBarColor": "19A0F0"
      },
      "item1": {
        "title": "门票",
        "url": "https://m.ctrip.com/webapp/ticket/ticket",
        "statusBarColor": "19A0F0",
        "hideAppBar": true
      },
      "item2": {
        "title": "目的地攻略",
        "url": "https://m.ctrip.com/html5/you/",
        "statusBarColor": "19A0F0",
        "hideAppBar": true
      },
      "item3": {
        "title": "邮轮旅行",
        "url": "https://m.ctrip.com/webapp/cruise/index",
        "hideAppBar": true
      },
      "item4": {
        "title": "定制旅行",
        "url": "https://m.ctrip.com/webapp/dingzhi",
        "hideAppBar": true
      }
    }
  },
  "subNavList": [
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_wifi.png",
      "title": "WiFi电话卡",
      "url": "https://m.ctrip.com/webapp/activity/wifi",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_visa.png",
      "title": "保险·签证",
      "url": "https://m.ctrip.com/webapp/tourvisa/entry",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_exchange.png",
      "title": "外币兑换",
      "url": "https://dp.ctrip.com/webapp/forex/index?bid=2&1=1",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_shopping.png",
      "title": "购物",
      "url":
          "https://m.ctrip.com/webapp/gshop/?ctm_ref=M_ps_2home_sl&bid=2&cid=3&pid=1",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_guide.png",
      "title": "当地向导",
      "url":
          "https://m.ctrip.com/webapp/vacations/pguider/homepage?secondwakeup=true&dpclickjump=true&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_freetravel.png",
      "title": "自由行",
      "url":
          "https://dp.ctrip.com/webapp/vacations/idiytour/diyindex?navBarStyle=white",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_play.png",
      "title": "境外玩乐",
      "url": "https://dp.ctrip.com/webapp/activity/overseasindex",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_lipin.png",
      "title": "礼品卡",
      "url": "https://dp.ctrip.com/webapp/lipin/money",
      "hideAppBar": true
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_credit.png",
      "title": "信用卡",
      "url": "https://dp.ctrip.com/webapp/cc/index?bid=8&cid=1&pid=4"
    },
    {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sub_nav_more.png",
      "title": "更多",
      "url": "https://dp.ctrip.com/webapp/more/",
      "hideAppBar": true
    }
  ],
  "salesBox": {
    "icon":
        "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/sales_box_huodong.png",
    "moreUrl": "https://contents.ctrip.com/activitysetupapp/mkt/index/moreact",
    "bigCard1": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700t0y000000m71h523FE_375_260_342.png",
      "url":
          "https://contents.ctrip.com/buildingblocksweb/special/membershipcard/index.html?sceneid=1&productid=14912&ishidenavbar=yes&pushcode=act_svip_hm31",
      "title": "活动"
    },
    "bigCard2": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700a10000000portu2BAD_375_260_342.jpg",
      "url":
          "https://m.ctrip.com/webapp/you/livestream/plan/crhHotelList.html?liveAwaken=true&isHideHeader=true&isHideNavBar=YES&mktcrhcode=hotevent",
      "title": "活动"
    },
    "smallCard1": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700b0z000000neoth8688_375_160_345.jpg",
      "url":
          "https://contents.ctrip.com/activitysetupapp/mkt/index/nbaafs?pushcode=IP_nbaafs004",
      "title": "活动"
    },
    "smallCard2": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700w0z000000mogkyEF78_375_160_345.jpg",
      "url": "https://smarket.ctrip.com/webapp/promocode/add?source=5",
      "title": "活动"
    },
    "smallCard3": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700a0t000000im512AB2C_375_160_345.jpg",
      "url": "https://smarket.ctrip.com/webapp/promocode/add?source=5",
      "title": "活动"
    },
    "smallCard4": {
      "icon":
          "https://apk-1256738511.file.myqcloud.com/FlutterTrip/images/700d0s000000htvwo16C4_375_160_345.jpg",
      "url": "https://smarket.ctrip.com/webapp/promocode/add?source=5",
      "title": "活动"
    }
  }
};

//travel model and data
const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031010211161114530&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

var params = {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": null,
  "lat": 34.2317081,
  "lon": 108.928918,
  "locatedDistrictId": 7,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {
    "cid": "09031010211161114530",
    "ctok": "",
    "cver": "1.0",
    "lang": "01",
    "sid": "8888",
    "syscode": "09",
    "auth": null,
    "extension": [
      {"name": "protocal", "value": "https"}
    ]
  },
  "contentType": "json"
};

/// 旅拍类别接口
class TravelDao {
  static Future<TravelModel> fetch(
    String url,
    Map params,
    String groupChannelCode,
    int type,
    int pageIndex,
    int pageSize,
  ) async {
    Map paramsMap = params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    params['groupChannelCode'] = groupChannelCode;
    params['type'] = type;

    Response response = await Dio().post(url, data: params);

    if (response.statusCode == 200) {
      return TravelModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}

/// 旅拍页模型
class TravelModel {
  int totalCount;
  List<TravelItem> resultList;

  TravelModel({
    required this.totalCount,
    required this.resultList,
  });

  factory TravelModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<TravelItem>? resultList =
        jsonRes['resultList'] is List ? <TravelItem>[] : null;
    if (resultList != null) {
      for (final dynamic item in jsonRes['resultList']!) {
        if (item != null) {
          resultList.add(TravelItem.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return TravelModel(
      totalCount: asT<int>(jsonRes['totalCount'])!,
      resultList: resultList!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'totalCount': totalCount,
        'resultList': resultList,
      };

  TravelModel clone() => TravelModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class TravelItem {
  int type;
  Article article;

  TravelItem({
    required this.type,
    required this.article,
  });

  factory TravelItem.fromJson(Map<String, dynamic> jsonRes) => TravelItem(
        type: asT<int>(jsonRes['type'])!,
        article:
            Article.fromJson(asT<Map<String, dynamic>>(jsonRes['article'])!),
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'article': article,
      };

  TravelItem clone() => TravelItem.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Article {
  int articleId;
  int productType;
  int sourceType;
  String articleTitle;
  Author author;
  List<Images> images;
  bool hasVideo;
  int readCount;
  int likeCount;
  int commentCount;
  List<Urls> urls;
  List<Tags> tags;
  List<Topics> topics;
  List<Pois> pois;
  String publishTime;
  String publishTimeDisplay;
  String shootTime;
  String shootTimeDisplay;
  int level;
  String distanceText;
  bool isLike;
  int imageCounts;
  bool isCollected;
  int collectCount;
  int articleStatus;
  String poiName;

  Article({
    required this.articleId,
    required this.productType,
    required this.sourceType,
    required this.articleTitle,
    required this.author,
    required this.images,
    required this.hasVideo,
    required this.readCount,
    required this.likeCount,
    required this.commentCount,
    required this.urls,
    required this.tags,
    required this.topics,
    required this.pois,
    required this.publishTime,
    required this.publishTimeDisplay,
    required this.shootTime,
    required this.shootTimeDisplay,
    required this.level,
    required this.distanceText,
    required this.isLike,
    required this.imageCounts,
    required this.isCollected,
    required this.collectCount,
    required this.articleStatus,
    required this.poiName,
  });

  factory Article.fromJson(Map<String, dynamic> jsonRes) {
    final List<Images>? images = jsonRes['images'] is List ? <Images>[] : null;
    if (images != null) {
      for (final dynamic item in jsonRes['images']!) {
        if (item != null) {
          images.add(Images.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Urls>? urls = jsonRes['urls'] is List ? <Urls>[] : null;
    if (urls != null) {
      for (final dynamic item in jsonRes['urls']!) {
        if (item != null) {
          urls.add(Urls.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Tags>? tags = jsonRes['tags'] is List ? <Tags>[] : null;
    if (tags != null) {
      for (final dynamic item in jsonRes['tags']!) {
        if (item != null) {
          tags.add(Tags.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Topics>? topics = jsonRes['topics'] is List ? <Topics>[] : null;
    if (topics != null) {
      for (final dynamic item in jsonRes['topics']!) {
        if (item != null) {
          topics.add(Topics.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Pois>? pois = jsonRes['pois'] is List ? <Pois>[] : null;
    if (pois != null) {
      for (final dynamic item in jsonRes['pois']!) {
        if (item != null) {
          pois.add(Pois.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    return Article(
      articleId: asT<int>(jsonRes['articleId'])!,
      productType: asT<int>(jsonRes['productType'])!,
      sourceType: asT<int>(jsonRes['sourceType'])!,
      articleTitle: asT<String>(jsonRes['articleTitle'])!,
      author: Author.fromJson(asT<Map<String, dynamic>>(jsonRes['author'])!),
      images: images!,
      hasVideo: asT<bool>(jsonRes['hasVideo'])!,
      readCount: asT<int>(jsonRes['readCount'])!,
      likeCount: asT<int>(jsonRes['likeCount'])!,
      commentCount: asT<int>(jsonRes['commentCount'])!,
      urls: urls!,
      tags: tags!,
      topics: topics!,
      pois: pois!,
      publishTime: asT<String>(jsonRes['publishTime'])!,
      publishTimeDisplay: asT<String>(jsonRes['publishTimeDisplay'])!,
      shootTime: asT<String>(jsonRes['shootTime'])!,
      shootTimeDisplay: asT<String>(jsonRes['shootTimeDisplay'])!,
      level: asT<int>(jsonRes['level'])!,
      distanceText: asT<String>(jsonRes['distanceText'])!,
      isLike: asT<bool>(jsonRes['isLike'])!,
      imageCounts: asT<int>(jsonRes['imageCounts'])!,
      isCollected: asT<bool>(jsonRes['isCollected'])!,
      collectCount: asT<int>(jsonRes['collectCount'])!,
      articleStatus: asT<int>(jsonRes['articleStatus'])!,
      poiName: asT<String>(jsonRes['poiName'])!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'articleId': articleId,
        'productType': productType,
        'sourceType': sourceType,
        'articleTitle': articleTitle,
        'author': author,
        'images': images,
        'hasVideo': hasVideo,
        'readCount': readCount,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'urls': urls,
        'tags': tags,
        'topics': topics,
        'pois': pois,
        'publishTime': publishTime,
        'publishTimeDisplay': publishTimeDisplay,
        'shootTime': shootTime,
        'shootTimeDisplay': shootTimeDisplay,
        'level': level,
        'distanceText': distanceText,
        'isLike': isLike,
        'imageCounts': imageCounts,
        'isCollected': isCollected,
        'collectCount': collectCount,
        'articleStatus': articleStatus,
        'poiName': poiName,
      };

  Article clone() => Article.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Author {
  int authorId;
  String nickName;
  String clientAuth;
  String jumpUrl;
  CoverImage coverImage;

  Author({
    required this.authorId,
    required this.nickName,
    required this.clientAuth,
    required this.jumpUrl,
    required this.coverImage,
  });

  factory Author.fromJson(Map<String, dynamic> jsonRes) {
    return Author(
      authorId: asT<int>(jsonRes['authorId'])!,
      nickName: asT<String>(jsonRes['nickName'])!,
      clientAuth: asT<String>(jsonRes['clientAuth'])!,
      jumpUrl: asT<String>(jsonRes['jumpUrl'])!,
      coverImage: CoverImage.fromJson(
          asT<Map<String, dynamic>>(jsonRes['coverImage'])!),
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'authorId': authorId,
        'nickName': nickName,
        'clientAuth': clientAuth,
        'jumpUrl': jumpUrl,
        'coverImage': coverImage,
      };

  Author clone() =>
      Author.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class CoverImage {
  String dynamicUrl;
  String originalUrl;

  CoverImage({
    required this.dynamicUrl,
    required this.originalUrl,
  });

  factory CoverImage.fromJson(Map<String, dynamic> jsonRes) => CoverImage(
        dynamicUrl: asT<String>(jsonRes['dynamicUrl'])!,
        originalUrl: asT<String>(jsonRes['originalUrl'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'dynamicUrl': dynamicUrl,
        'originalUrl': originalUrl,
      };

  CoverImage clone() => CoverImage.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Images {
  int imageId;
  String dynamicUrl;
  String originalUrl;
  double width;
  double height;
  int mediaType;
  double lat;
  double lon;

  Images({
    required this.imageId,
    required this.dynamicUrl,
    required this.originalUrl,
    required this.width,
    required this.height,
    required this.mediaType,
    required this.lat,
    required this.lon,
  });

  factory Images.fromJson(Map<String, dynamic> jsonRes) => Images(
        imageId: asT<int>(jsonRes['imageId'])!,
        dynamicUrl: asT<String>(jsonRes['dynamicUrl'])!,
        originalUrl: asT<String>(jsonRes['originalUrl'])!,
        width: asT<double>(jsonRes['width'])!,
        height: asT<double>(jsonRes['height'])!,
        mediaType: asT<int>(jsonRes['mediaType'])!,
        lat: asT<double>(jsonRes['lat'])!,
        lon: asT<double>(jsonRes['lon'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'imageId': imageId,
        'dynamicUrl': dynamicUrl,
        'originalUrl': originalUrl,
        'width': width,
        'height': height,
        'mediaType': mediaType,
        'lat': lat,
        'lon': lon,
      };

  Images clone() =>
      Images.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Urls {
  String version;
  String appUrl;
  String h5Url;
  String wxUrl;

  Urls({
    required this.version,
    required this.appUrl,
    required this.h5Url,
    required this.wxUrl,
  });

  factory Urls.fromJson(Map<String, dynamic> jsonRes) => Urls(
        version: asT<String>(jsonRes['version'])!,
        appUrl: asT<String>(jsonRes['appUrl'])!,
        h5Url: asT<String>(jsonRes['h5Url'])!,
        wxUrl: asT<String>(jsonRes['wxUrl'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'version': version,
        'appUrl': appUrl,
        'h5Url': h5Url,
        'wxUrl': wxUrl,
      };

  Urls clone() =>
      Urls.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Tags {
  int tagId;
  String tagName;
  int tagLevel;
  int parentTagId;
  int source;
  int sortIndex;

  Tags({
    required this.tagId,
    required this.tagName,
    required this.tagLevel,
    required this.parentTagId,
    required this.source,
    required this.sortIndex,
  });

  factory Tags.fromJson(Map<String, dynamic> jsonRes) => Tags(
        tagId: asT<int>(jsonRes['tagId'])!,
        tagName: asT<String>(jsonRes['tagName'])!,
        tagLevel: asT<int>(jsonRes['tagLevel'])!,
        parentTagId: asT<int>(jsonRes['parentTagId'])!,
        source: asT<int>(jsonRes['source'])!,
        sortIndex: asT<int>(jsonRes['sortIndex'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tagId': tagId,
        'tagName': tagName,
        'tagLevel': tagLevel,
        'parentTagId': parentTagId,
        'source': source,
        'sortIndex': sortIndex,
      };

  Tags clone() =>
      Tags.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Topics {
  int topicId;
  String topicName;
  int level;

  Topics({
    required this.topicId,
    required this.topicName,
    required this.level,
  });

  factory Topics.fromJson(Map<String, dynamic> jsonRes) => Topics(
        topicId: asT<int>(jsonRes['topicId'])!,
        topicName: asT<String>(jsonRes['topicName'])!,
        level: asT<int>(jsonRes['level'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'topicId': topicId,
        'topicName': topicName,
        'level': level,
      };

  Topics clone() =>
      Topics.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Pois {
  int poiType;
  int poiId;
  String poiName;
  int districtId;
  String districtName;
  PoiExt poiExt;
  int source;
  int isMain;
  bool isInChina;

  Pois({
    required this.poiType,
    required this.poiId,
    required this.poiName,
    required this.districtId,
    required this.districtName,
    required this.poiExt,
    required this.source,
    required this.isMain,
    required this.isInChina,
  });

  factory Pois.fromJson(Map<String, dynamic> jsonRes) {
    return Pois(
      poiType: asT<int>(jsonRes['poiType'])!,
      poiId: asT<int>(jsonRes['poiId'])!,
      poiName: asT<String>(jsonRes['poiName'])!,
      districtId: asT<int>(jsonRes['districtId'])!,
      districtName: asT<String>(jsonRes['districtName'])!,
      poiExt: PoiExt.fromJson(asT<Map<String, dynamic>>(jsonRes['poiExt'])!),
      source: asT<int>(jsonRes['source'])!,
      isMain: asT<int>(jsonRes['isMain'])!,
      isInChina: asT<bool>(jsonRes['isInChina'])!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'poiType': poiType,
        'poiId': poiId,
        'poiName': poiName,
        'districtId': districtId,
        'districtName': districtName,
        'poiExt': poiExt,
        'source': source,
        'isMain': isMain,
        'isInChina': isInChina,
      };

  Pois clone() =>
      Pois.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class PoiExt {
  String h5Url;
  String appUrl;

  PoiExt({
    required this.h5Url,
    required this.appUrl,
  });

  factory PoiExt.fromJson(Map<String, dynamic> jsonRes) {
    return PoiExt(
      h5Url: asT<String>(jsonRes['h5Url'])!,
      appUrl: asT<String>(jsonRes['appUrl'])!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'h5Url': h5Url,
        'appUrl': appUrl,
      };

  PoiExt clone() =>
      PoiExt.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

/// 旅拍类别模型
class TravelTabModel {
  String url;
  Map params;
  List<TravelTab> tabs;

  TravelTabModel({
    required this.url,
    required this.params,
    required this.tabs,
  });

  factory TravelTabModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<TravelTab>? tabs =
        jsonRes['tabs'] is List ? <TravelTab>[] : null;
    if (tabs != null) {
      for (final dynamic item in jsonRes['tabs']!) {
        if (item != null) {
          tabs.add(TravelTab.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return TravelTabModel(
      url: asT<String>(jsonRes['url'])!,
      params: asT<Map>(jsonRes['params'])!,
      tabs: tabs!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'params': params,
        'tabs': tabs,
      };

  TravelTabModel clone() => TravelTabModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Params {
  int districtId;
  String groupChannelCode;
  Object? type;
  double lat;
  double lon;
  int locatedDistrictId;
  PagePara pagePara;
  int imageCutType;
  Head head;
  String contentType;

  Params({
    required this.districtId,
    required this.groupChannelCode,
    this.type,
    required this.lat,
    required this.lon,
    required this.locatedDistrictId,
    required this.pagePara,
    required this.imageCutType,
    required this.head,
    required this.contentType,
  });

  factory Params.fromJson(Map<String, dynamic> jsonRes) => Params(
        districtId: asT<int>(jsonRes['districtId'])!,
        groupChannelCode: asT<String>(jsonRes['groupChannelCode'])!,
        type: asT<Object?>(jsonRes['type']),
        lat: asT<double>(jsonRes['lat'])!,
        lon: asT<double>(jsonRes['lon'])!,
        locatedDistrictId: asT<int>(jsonRes['locatedDistrictId'])!,
        pagePara:
            PagePara.fromJson(asT<Map<String, dynamic>>(jsonRes['pagePara'])!),
        imageCutType: asT<int>(jsonRes['imageCutType'])!,
        head: Head.fromJson(asT<Map<String, dynamic>>(jsonRes['head'])!),
        contentType: asT<String>(jsonRes['contentType'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'districtId': districtId,
        'groupChannelCode': groupChannelCode,
        'type': type,
        'lat': lat,
        'lon': lon,
        'locatedDistrictId': locatedDistrictId,
        'pagePara': pagePara,
        'imageCutType': imageCutType,
        'head': head,
        'contentType': contentType,
      };

  Params clone() =>
      Params.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class PagePara {
  int pageIndex;
  int pageSize;
  int sortType;
  int sortDirection;

  PagePara({
    required this.pageIndex,
    required this.pageSize,
    required this.sortType,
    required this.sortDirection,
  });

  factory PagePara.fromJson(Map<String, dynamic> jsonRes) => PagePara(
        pageIndex: asT<int>(jsonRes['pageIndex'])!,
        pageSize: asT<int>(jsonRes['pageSize'])!,
        sortType: asT<int>(jsonRes['sortType'])!,
        sortDirection: asT<int>(jsonRes['sortDirection'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'sortType': sortType,
        'sortDirection': sortDirection,
      };

  PagePara clone() => PagePara.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Head {
  String cid;
  String ctok;
  String cver;
  String lang;
  String sid;
  String syscode;
  Object? auth;
  List<Extension> extension;

  Head({
    required this.cid,
    required this.ctok,
    required this.cver,
    required this.lang,
    required this.sid,
    required this.syscode,
    this.auth,
    required this.extension,
  });

  factory Head.fromJson(Map<String, dynamic> jsonRes) {
    final List<Extension>? extension =
        jsonRes['extension'] is List ? <Extension>[] : null;
    if (extension != null) {
      for (final dynamic item in jsonRes['extension']!) {
        if (item != null) {
          extension.add(Extension.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Head(
      cid: asT<String>(jsonRes['cid'])!,
      ctok: asT<String>(jsonRes['ctok'])!,
      cver: asT<String>(jsonRes['cver'])!,
      lang: asT<String>(jsonRes['lang'])!,
      sid: asT<String>(jsonRes['sid'])!,
      syscode: asT<String>(jsonRes['syscode'])!,
      auth: asT<Object?>(jsonRes['auth']),
      extension: extension!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cid': cid,
        'ctok': ctok,
        'cver': cver,
        'lang': lang,
        'sid': sid,
        'syscode': syscode,
        'auth': auth,
        'extension': extension,
      };

  Head clone() =>
      Head.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Extension {
  String name;
  String value;

  Extension({
    required this.name,
    required this.value,
  });

  factory Extension.fromJson(Map<String, dynamic> jsonRes) => Extension(
        name: asT<String>(jsonRes['name'])!,
        value: asT<String>(jsonRes['value'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'value': value,
      };

  Extension clone() => Extension.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class TravelTab {
  String labelName;
  String groupChannelCode;
  int type;

  TravelTab({
    required this.labelName,
    required this.groupChannelCode,
    required this.type,
  });

  factory TravelTab.fromJson(Map<String, dynamic> jsonRes) => TravelTab(
        labelName: asT<String>(jsonRes['labelName'])!,
        groupChannelCode: asT<String>(jsonRes['groupChannelCode'])!,
        type: asT<int>(jsonRes['type'])!,
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'labelName': labelName,
        'groupChannelCode': groupChannelCode,
        'type': type,
      };

  TravelTab clone() => TravelTab.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

var travelTabData = TravelTabModel.fromJson(travelTabJsonRes);
var travelTabJsonRes = {
  "url":
      "https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031010211161114530&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5",
  "params": {
    "districtId": -1,
    "groupChannelCode": "tourphoto_global1",
    "type": null,
    "lat": 34.2317081,
    "lon": 108.928918,
    "locatedDistrictId": 7,
    "pagePara": {
      "pageIndex": 1,
      "pageSize": 10,
      "sortType": 9,
      "sortDirection": 0
    },
    "imageCutType": 1,
    "head": {
      "cid": "09031010211161114530",
      "ctok": "",
      "cver": "1.0",
      "lang": "01",
      "sid": "8888",
      "syscode": "09",
      "auth": null,
      "extension": [
        {"name": "protocal", "value": "https"}
      ]
    },
    "contentType": "json"
  },
  "tabs": [
    {"labelName": "推荐", "groupChannelCode": "tourphoto_global1", "type": 1},
    {"labelName": "附近", "groupChannelCode": "", "type": 3},
    {"labelName": "\uD83D\uDD25旅行热点", "groupChannelCode": "hot", "type": 0},
    {"labelName": "露营初体验", "groupChannelCode": "camping", "type": 0},
    {"labelName": "酒店民宿", "groupChannelCode": "hotel", "type": 0},
    {"labelName": "美食探店", "groupChannelCode": "msxwzl", "type": 0},
    {"labelName": "亲子", "groupChannelCode": "children", "type": 0},
    {"labelName": "小众", "groupChannelCode": "less-known", "type": 0},
    {"labelName": "自驾", "groupChannelCode": "zijiayoubaodian", "type": 0},
    {"labelName": "网红", "groupChannelCode": "wanghongdakadi", "type": 0},
    {"labelName": "逛展", "groupChannelCode": "show", "type": 0}
  ]
};
