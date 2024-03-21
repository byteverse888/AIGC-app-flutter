import 'package:intl/intl.dart';
import 'package:openim/utils/app_logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';

import '../../src/models/user_model.dart';
import '../../src/models/post_model.dart';
import '../../src/models/comment_model.dart';
import 'package:openim_common/openim_common.dart';

class DatabaseService {
  static parseInit() async {
    // client will get from API with token and set debug false
    String parseapi = 'https://' + Config.serverIp + '/parse';
    var client = await Parse().initialize(
      "BTGAPPId",
      parseapi,
      clientKey: "BTGClientKEY",
      debug: true, // When enabled, prints logs to console
      autoSendSessionId: false, // Required for authentication and ACL
    );

    // Check server is healthy and live - Debug is on in this instance so check logs for result
    final ParseResponse response = await Parse().healthCheck();

    if (!response.success) {
      print('Parse Server health check failed');
    }

    //获取账户余额
    var btgaddr =
        EthereumAddress.fromHex('0x4ebf7041edcb654b02cC48DaEF742752268aCB37');
    var btg_balance = await getBTGBalance(btgaddr);
    print("xxxxxx btg addr balance");
    print(btg_balance);

    //create wallet account
    // var newaddress = createWalletAccount();
    // print(newaddress.hexEip55);
    // var new_balance = await getBTGBalance(newaddress);
    // print("xxxxxx btg addr new_balance");
    // print(new_balance);

    //转账
    // var send_result = await sendBTGTransaction();
    // print(send_result);

    return client;
  }

  static Future<EtherAmount> getBTGBalance(EthereumAddress btgaddr) async {
    var beth_apiUrl = "https://" + Config.serverIp + '/bteth';
    var httpClient = Client();
    var ethClient = Web3Client(beth_apiUrl, httpClient);
    var btg_balance = await ethClient.getBalance(btgaddr);
    print("xxxxxx btg addr balance 111");
    print(btg_balance.getValueInUnit(EtherUnit.ether));
    return btg_balance;
  }

  static EthereumAddress createWalletAccount() {
    // Or generate a new key randomly
    var random = Random.secure();
    var credentials = EthPrivateKey.createRandom(random);
    Wallet wallet = Wallet.createNew(credentials, "password", random);
    print("xxxxxxxx create wallet account");
    print(credentials.privateKey);
    var key = credentials.privateKeyInt;
    print(key.toRadixString(16));
    //print(credentials.publicKey);
    print(credentials.address);

    final address = credentials.address;

    print("xxxxxxxx create wallet account end");

    // var walletnew = wallet.toJson(); // oops
    // print("xxxxxxxx create wallet account 222");
    // print(walletnew);

    return address;
  }

  static Future<String> sendBTGTransaction() async {
    var beth_apiUrl = "https://" + Config.serverIp + '/bteth';
    var ethClient = Web3Client(beth_apiUrl, Client());

    const String privateKey =
        '3da4485340bc8fd3a83cee51cce34bd14e5910f646ef8c7983616bb895e24de9';

    final credentials = EthPrivateKey.fromHex(privateKey);
    //final credentials = ethClient.credentialsFromPrivateKey(privateKey);
    final address = credentials.address;

    print(address.hexEip55);
    print(await ethClient.getBalance(address)); //edge_jincm1

    var send_result = await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(
            '0x62A4Ef404661e4A61eE2bEA737083c3EEc18DAdb'), //firefox_jincm3
        gasPrice: EtherAmount.inWei(BigInt.from(1500000007)),
        maxGas: 210000,
        value: EtherAmount.fromInt(EtherUnit.ether, 1),
        maxFeePerGas: EtherAmount.inWei(BigInt.from(1500000008)), //1500000008,
        maxPriorityFeePerGas:
            EtherAmount.inWei(BigInt.from(1500000000)), //1500000000,
      ),
      chainId: 888,
    ); //参数不对交易不成功？

    print("xxxxxxxxx send result" + send_result);

    //await ethClient.dispose();

    return send_result;
  }

  ///User(id,userId,mail) -----userId=OpenIM.iMManager.userID
  ///AIPost(id,user_pointer,content,task_state)
  ///AIComment(id,user_pointer,post_pointer,content)
  ///AIOrder(id,)
  ///task state:排队生产中、制作完成、上架中、审核中、销售中
  ///order_state:下订单、待付款、待发货、已完成

// 注意：用户Id：OpenIM系统的userID注册到parse中，parse系统中有自己的objectId编号
// 微信ID或IMchat_userid/OpenIM.iMManager.userID ---->ParseUser userId
//         IMchat_phonenum ----> ParseUser username/mail@163.com
//         ParseUser objectId
  static Future<ParseUser> createParseUser(
      String phonenum, String userID, String passwd) async {
    //register
    var user = ParseUser(phonenum, passwd, "$phonenum@163.com")
      ..set("userID", userID);
    await user.save();

    var uid = user.objectId;
    print("current user is $uid");
    //login
    var response = await user.login();
    if (!response.success) {
      print("user login error ${response.result}");
    }
    uid = user.objectId;
    print("current login user is $uid");
    //set ACL
    var parseACL = ParseACL(owner: user);
    parseACL.setPublicReadAccess(allowed: true);
    parseACL.setPublicWriteAccess(allowed: true);
    user.setACL(parseACL);
    response = await user.save();
    if (!response.success) {
      print(response.error);
    }

    return user;
  }


  // 发布post,文生图
  static Future<ParseObject> createPostByTextToImage(
      String caption,
      String topic,
      String negativedescription,
      String size,
      String ratio,
      String modeltopic,
      String style,
      int number,
      ) async {
    var user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')
      ..set('userpointer', user)
      ..set('topic', topic)
      ..set('caption', caption)
      ..set("designer", user.objectId)
      ..set("ownerUser", user.objectId)
      ..set('negativedescription', negativedescription)
      ..set('metadata', {
        "size":size,
        "ratio":ratio,
        "modeltopic":modeltopic,
        "style":style,
        "number": "$number"
      })
      ..set("status", 0); //"0:排队中，1: 被锁住, 2: 制作完成，初始状态应设置为0"

    var apiResponse = await post.save();
    if (apiResponse.success && apiResponse.count > 0) {
      //print('$keyAppName: ${apiResponse.result}');
      return post;
    } else {
      print("post save error ${apiResponse.error}");
      return apiResponse.results![0];
    }
  }

  // 发布post,图生图
  static Future<ParseObject> createPostByImageToImage(
      String caption,
      String modeltopic,
      int number,
      ) async {
    var user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')
      ..set('userpointer', user)
      ..set('caption', caption)
      ..set("designer", user.objectId)
      ..set("ownerUser", user.objectId)
      ..set('metadata', {
        "modeltopic":modeltopic,
        "number": "$number"
      })
      ..set("status", 0); //"0:排队中，1: 被锁住, 2: 制作完成，初始状态应设置为0"

    var apiResponse = await post.save();
    if (apiResponse.success && apiResponse.count > 0) {
      //print('$keyAppName: ${apiResponse.result}');
      return post;
    } else {
      print("post save error ${apiResponse.error}");
      return apiResponse.results![0];
    }
  }

  // 发布post
  static Future<ParseObject> createPost(
      String userID, String title, String caption) async {
    var user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')
      ..set('userpointer', user)
      ..set('title', title)
      ..set('caption', caption)
      ..set("status", 0); //"0:排队中，1: 被锁住, 2: 制作完成，初始状态应设置为0"

    var apiResponse = await post.save();
    if (apiResponse.success && apiResponse.count > 0) {
      //print('$keyAppName: ${apiResponse.result}');
      return post;
    } else {
      print("post save error ${apiResponse.error}");
      return apiResponse.results![0];
    }
  }

  // 删除post
  static Future<void> deletePost(String postId) async {
    final post = ParseObject('AIPost')..objectId = postId;
    var response = await post.delete();
    print(response);
  }

  // 更新post
  // {
  // "status": "0:排队中，1: 被锁住, 2: 制作完成，初始状态应设置为0"，
  // "title": "title update from dart1",
  // "caption": "description:这是一个文生图的描述文字1",
  // "imagesUrl": 生成的图片列表：["www.baidu.com/image1.png", "www.baidu.com/image2.png"],
  // "topic": "topic类别：科幻、美女、壁纸、室内设计、汉服、二次元、风景、中国风、儿童、艺术、游戏、奇幻、珠宝、美食、动物",
  // "metadata": {
  //   "size": "画面大小说明：头像1:1/手机屏幕1:2/文章配图4:3/社交媒体3:4/电脑壁纸16:9/宣传海报9:16",
  //   "ratio": "分辨率：1024*1024/2048*2048/4096*4096/2048*2048精绘",
  //   "modeltopic": "模型主题：壁纸、人像、真人、艺术肖像、游戏人设、人物写真、室内设计、建筑设计、科幻、未来建筑、电影写实",
  //   "style": "超高清、像素完美、工作室质量、超现实照片、数字渲染、艺术、油画、水彩画、水墨画、浮世绘、壁画、涂鸦、电影、
  //            海报、木浮雕、炭笔画、素描、赛博朋克、迷幻、古典雕塑、超现实、外星人、现代、未来主义、复古、梦幻、抽象、
  //            印象艺术、极简主义、超广角、超近景、微距、远景、中国画、埃及艺术、漫威漫画、蒸汽朋克、单反、粉笔艺术、全景、
  //            水晶、哥特式、皮克斯、星球大战、洛可可、非洲未来主义、权力的游戏、长焦镜头、摄像机效果、全息摄影、电影照明、
  //            概念艺术",
  //   "keyxx": ["a1", "a2"]  ---其他参数
  // },
  // "negativedescription": "负面描述：暴力",
  // "referenceimagesUrl": [
  //   "www.baidu.com/image3.png",  ----参考图片列表
  //   "www.baidu.com/image4.png"
  // ],

  // "designer": "设计者：user1",
  // "ownerUser": "拥有者：user1", ---初始是属于设计者，上架后被别人买走后就会更新成购买者
  // "createdUser": "生产者：user9",
  // "GPUID": "生产使用的GPU型号&编号：3090/xxxxxx",
  // }
  static Future<void> updatePost(
      String postId, Map<String, dynamic> params) async {
    final post = ParseObject('AIPost')..objectId = postId;
    bool save = false;

    for (var key in params.keys) {
      print('Key: $key, Value: ${params[key]}');
      post.set(key, params[key]);
      save = true;
    }

    if (save) {
      var apiResponse = await post.save();
      if (apiResponse.success && apiResponse.count > 0) {
        print('$keyAppName: ${apiResponse.result}');
      }
    }
  }

  // 查看post详情
  static Future<ParseObject> getPost(String postId) async {
    final queryBuilder = QueryBuilder(ParseObject('AIPost'))
      ..whereEqualTo('objectId', postId)
      ..includeObject(["userpointer"]); //pointer中信息也返回
    // ..keysToReturn(["ownerUser", "imagesUrl", "userpointer","likes","commentnum"]); //仅返回这些字段
    final apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      print("getPost is $apiResponse.result");
      return apiResponse.result[0];
    } else {
      print('getPost error $keyAppName: ${apiResponse.result}');
      return apiResponse.result;
    }
  }

  // 分页查询post：
  // 分类分页查询post：queryPosts(10, 0, "topic", "风景");
  // 某人设计的post：queryPosts(10, 0, "designer", "user1")
  // 某人生产的post：queryPosts(10, 0, "createdUser", "user1")
  // queryPosts(10, 0, "status", 0)
  static Future<List<ParseObject>> queryPosts(
      int limit, int skip, String queryKey, dynamic queryValue) async {
    var queryBuilder = QueryBuilder<ParseObject>(ParseObject('AIPost'))
      ..orderByDescending('updatedAt')
      ..setAmountToSkip(skip)
      ..setLimit(limit)
      // ..whereEquals('{"topic":"风景"}'); ---error
      ..whereEqualTo(queryKey, queryValue);
    var apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.count > 0) {
      return apiResponse.result;
    } else {
      print('queryPosts error $keyAppName: ${apiResponse.error?.message}');
      return [];
    }
  }

  // 分类数量统计post
  static Future<int> countPosts(String queryKey, dynamic queryValue) async {
    var queryBuilder = QueryBuilder<ParseObject>(ParseObject('AIPost'))
      ..count()
      ..whereEqualTo(queryKey, queryValue);
    var apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.count > 0) {
      return apiResponse.count;
    } else {
      print('getPosts error $keyAppName: ${apiResponse.error?.message}');
      return 0;
    }
  }

  // 点赞
  static Future<void> likePost(String postId) async {
    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement('likes', 1);
    var apiResponse = await post.save();
    if (!apiResponse.success) {
      print('likePost error $keyAppName: ${apiResponse.result}');
    }
  }

  // 取消点赞
  static Future<void> unlikePost(String postId) async {
    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement('likes', -1);
    //post.set('isLiked', false);
    var apiResponse = await post.save();
    if (!apiResponse.success) {
      print('unlikePost error $keyAppName: ${apiResponse.result}');
    }
  }

  // 举报post
  static Future<void> reportPost(String userID, String postId,
      {String? reason}) async {
    if (reason != null) {
      var user = await ParseUser.currentUser();
      final aiReport = ParseObject('AIReport')
        //..set('userID', userID)
        ..set('userpointer', user)
        ..set('postId', postId)
        ..set('reason', reason);
      var apiResponse = await aiReport.save();
      if (!apiResponse.success) {
        print('reportPost error $keyAppName: ${apiResponse.result}');
      }
    }

    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement('reportnum', 1);
    await post.save();
  }

  // 取消举报
  static Future<void> unreportPost(String userID, String postId) async {
    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement('reportnum', -1);
    var apiResponse = await post.save();
    if (apiResponse.success && apiResponse.count > 0) {
      print('$keyAppName: ${apiResponse.result}');
    }

    ParseObject reportObj;
    var parseUser = await ParseUser.currentUser();
    var queryBuilder = QueryBuilder(ParseObject('AIReport'))
      ..whereEqualTo('userpointer', parseUser)
      ..whereEqualTo('postId', postId);
    apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      reportObj = apiResponse.results!.first;
      await reportObj.delete();
    }
  }

  // 收藏
  static Future<void> bookmarkPost(String postId) async {
    final user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')..objectId = postId;
    user.addRelation('bookmarkedPosts', [post]);
    final apiResponse = await user.save();
    if (!apiResponse.success) {
      print(
          'bookmarkPost addRelation error $keyAppName: ${apiResponse.result}');
    }
  }

  // 取消收藏
  static Future<void> unbookmarkPost(String postId) async {
    final user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')..objectId = postId;
    user.removeRelation('bookmarkedPosts', [post]);
    final apiResponse = await user.save();
    if (!apiResponse.success) {
      print('unbookmarkPost removeRelation error ${apiResponse.result}');
    }
  }

  // 查看我的收藏列表
  static Future<List<ParseObject>?> getBookmarkedPosts(String userID,
      {int limit = 10, int skip = 0}) async {
    final user = await ParseUser.currentUser();
    var relation = user.getRelation('bookmarkedPosts');
    var queryBuilder = relation.getQuery();
    var apiResponse = await queryBuilder.query()
      ..setAmountToSkip(skip)
      ..setLimit(limit);
    if (apiResponse.success && apiResponse.count > 0) {
      return apiResponse.results;
    } else {
      print('getBookmarkedPosts error $keyAppName: ${apiResponse.result}');
      return [];
    }
  }

  // 查看我的收藏列表
  static Future<bool> isBookmarkedPosts(String objectId) async {
    final user = await ParseUser.currentUser();
    var relation = user.getRelation('bookmarkedPosts');
    var queryBuilder = relation.getQuery()..whereEqualTo('objectId', objectId);
    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      return true;

    } else {
      print('getBookmarkedPosts error $keyAppName: ${apiResponse.result}');
      return false;
    }
  }

  // 发表评论
  static Future<ParseObject> createComment(
      String userID, String postId, String commentContent) async {
    var user = await ParseUser.currentUser();
    final post = ParseObject('AIPost')..objectId = postId;
    final comment = ParseObject('AIComment')
      ..set('userpointer', user)
      ..set('postpointer', post)
      ..set('content', commentContent);

    var apiResponse = await comment.save();
    if (!apiResponse.success) {
      print('createComment error $keyAppName: ${apiResponse.result}');
    }

    post.setIncrement('commentnum', 1);
    await post.save();
    return apiResponse.result;
  }

  // 删除评论
  static Future<void> deleteComment(String commentId, String postId) async {
    final comment = ParseObject('AIComment')..objectId = commentId;
    var apiResponse = await comment.delete();
    if (!apiResponse.success) {
      print('deleteComment error $keyAppName: ${apiResponse.result}');
    }

    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement('commentnum', -1);
    await post.save();
  }

  // 查看评论列表
  static Future<List<ParseObject>?> getPostComments(String postId,
      {int limit = 30, int skip = 0}) async {
    ParseObject post = ParseObject("AIPost")..objectId = postId;
    final query = QueryBuilder(ParseObject('AIComment'))
      ..whereEqualTo('postpointer', post)
      ..setAmountToSkip(skip)
      ..setLimit(limit)
      ..includeObject(['userpointer'])
      ..orderByDescending('createdAt');
    final apiResponse = await query.query();
    if (apiResponse.success) {
      return apiResponse.result;
    } else {
      print('getPostComments error $keyAppName: ${apiResponse.error?.message}');
      return [];
    }
  }

  // 查看评论详情
  static Future<ParseObject> getCommentDetails(String commentId) async {
    final queryBuilder = QueryBuilder(ParseObject('AIComment'))
      ..whereEqualTo('objectId', commentId);
    final apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      return apiResponse.result;
    } else {
      print('getCommentDetails error $keyAppName: ${apiResponse.result}');
      return apiResponse.result;
    }
  }

  // 关注某人
  // following：你关注的人，相当于微博中的“关注”；不会关注很多人，可以限制在1000内；
  // followers/fans：关注你的人，相当于微博中的“粉丝”；粉丝数可能很多，数据量大可以存在redis中，保存粉丝数，并且只保存最近1000的粉丝列表
  static Future<dynamic> followUser(String toUserObjectId) async {
    var currentUser = await ParseUser.currentUser();
    var toUser = ParseObject("_User")..objectId = toUserObjectId;
    //query toUser with toId
    // final QueryBuilder<ParseUser> userQueryBuilder =
    //     QueryBuilder<ParseUser>(ParseUser.forQuery())
    //       ..whereEqualTo('objectId', toId);
    // var userResponse = await userQueryBuilder.query();
    // if (!userResponse.success) {
    //   print('can not find toUser $toId $keyAppName: ${userResponse.results![0]}');
    //   var msg = userResponse.result;
    //   return {"code": 1, "msg": msg};
    // } else {
    //   toUser = userResponse.result[0];
    // }

    //Todo：判断当前的关注人数，如果超过1000，报错：超过最大关注人数
    //Todo: 判断是否已经关注了，关注的话不需要add

    //增加关联关系
    //currentUser.setIncrement("numFollowing", 1);
    currentUser.addRelation('Following', [toUser]); //error because ACL
    var apiResponse = await currentUser.save();
    if (!apiResponse.success) {
      print('followUser error $keyAppName: ${apiResponse.results![0]}');
    }

    //update followers/fans {"Fans":{"numFollowing": 99, "numFollower": 98}}
    ParseObject fromUserObj;
    ParseObject toUserObj;
    var fromObjectId = currentUser.objectId;
    var queryFansBuilder = QueryBuilder(ParseObject('Fans'))
      ..whereEqualTo("userObjectId", fromObjectId);
    var fromResponse = await queryFansBuilder.query();
    if (fromResponse.success && fromResponse.count > 0) {
      print("Record exists");
      fromUserObj = fromResponse.results!.first;
    } else {
      // if not exist then add record
      fromUserObj = ParseObject('Fans')..set("userObjectId", fromObjectId);
    }

    queryFansBuilder = QueryBuilder(ParseObject('Fans'))
      ..whereEqualTo("userObjectId", toUserObjectId);
    var toResponse = await queryFansBuilder.query();
    if (toResponse.success && toResponse.count > 0) {
      print("Record exists");
      toUserObj = toResponse.results!.first;
    } else {
      // if not exist then add record
      toUserObj = ParseObject('Fans')..set("userObjectId", toUserObjectId);
    }
    fromUserObj.setIncrement("numFollowing", 1);
    toUserObj.setIncrement("numFollower", 1);
    await toUserObj.save();
    await fromUserObj.save();

    return {"code": 0, "msg": "success"};
  }

  // 取消关注某人
  static Future<dynamic> unfollowUser(String toUserObjectId) async {
    final currentUser = await ParseUser.currentUser();
    var toUser = ParseObject("_User")..objectId = toUserObjectId;

    //取消关联关系
    currentUser.removeRelation('Following', [toUser]);
    var apiResponse = await currentUser.save();
    if (!apiResponse.success) {
      print('unfollowUser error $keyAppName: ${apiResponse.results![0]}');
    }

    //update FansClass numFollowing numFollower
    var fromObjectId = currentUser.objectId;
    ParseObject fromUserObj;
    ParseObject toUserObj;

    var queryFansBuilder = QueryBuilder(ParseObject('Fans'))
      ..whereEqualTo("userObjectId", fromObjectId);
    var fromResponse = await queryFansBuilder.query();
    if (fromResponse.success && fromResponse.count > 0) {
      print("Record exists");
      fromUserObj = fromResponse.results!.first;
    } else {
      // if not exist then return error
      return {"code": 1, "msg": "can not find fromUserId: $fromObjectId"};
    }

    queryFansBuilder = QueryBuilder(ParseObject('Fans'))
      ..whereEqualTo("userObjectId", toUserObjectId);
    var toResponse = await queryFansBuilder.query();
    if (toResponse.success && toResponse.count > 0) {
      print("Record exists");
      toUserObj = toResponse.results!.first;
    } else {
      // if not exist then return error
      return {"code": 1, "msg": "can not find toUserId: $toUserObjectId"};
    }
    fromUserObj.setIncrement("numFollowing", -1);
    toUserObj.setIncrement("numFollower", -1);
    await toUserObj.save();
    await fromUserObj.save();

    return {"code": 0, "msg": "success"};
  }

  //用户的关注数和粉丝数
  static Future<dynamic> numFollowing(String userObjectId) async {
    //query Fans with userObjectId
    ParseObject userObj;
    final queryFansBuilder = QueryBuilder(ParseObject('Fans'))
      ..whereEqualTo("userObjectId", userObjectId);
    var userResponse = await queryFansBuilder.query();
    if (!userResponse.success) {
      print(
          'can not find toUser $userObjectId $keyAppName: ${userResponse.results![0]}');
      var msg = userResponse.result;
      return {"code": 1, "msg": msg};
    } else {
      userObj = userResponse.result[0];
    }
    var number = {
      "numFollowing": userObj["numFollowing"] ?? 0,
      "numFollower": userObj["numFollower"] ?? 0
    };
    return number;
  }

  //判断当前用户是否已经关注
  static Future<bool> isFollowingUser(
      String fromUserObjectId, String toUserObjectId) async {
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereRelatedTo('Following', '_User', fromUserObjectId)
          ..whereEqualTo("objectId", toUserObjectId);

    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      print("following user is $fromUserObjectId $toUserObjectId");
      return true;
    } else {
      print('isFollowingUser error $keyAppName: ${apiResponse.result}');
      return false;
    }
  }

  // 查看我的关注列表
  static Future<List<dynamic>?> getmyFollowingUsers(int limit, int skip) async {
    final currentUser = await ParseUser.currentUser();

    var relation = currentUser.getRelation('Following');
    var queryBuilder = relation.getQuery()
      ..setAmountToSkip(skip)
      ..setLimit(limit);
    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      //Todo: 为了防止内存溢出，只返回关注列表中的前20个（根据参数来）
      return apiResponse.results;
    } else {
      print('followings error $keyAppName: ${apiResponse.result}');
      return [];
    }
  }

  // 查看我的关注用户的post列表
  static Future<List<ParseObject>?> getmyFollowingPosts(int limit, int skip) async {
    final currentUser = await ParseUser.currentUser();

    //先获取我关注的前20个用户列表
    var relation = currentUser.getRelation('Following');
    var queryBuilder = relation.getQuery()
      ..setAmountToSkip(0)
      ..setLimit(20)
      ..keysToReturn(["objectId"]);
    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      //Todo: 为了防止内存溢出，只返回关注列表中的前20个（根据参数来）
      var userlist = apiResponse.results;
      print("userlist is $userlist");
      // [{
      //         "__type": "Pointer",
      //         "className": "_User",
      //         "objectId": "No7jNH1wtY"
      //  },
      //  {
      //         "__type": "Pointer",
      //         "className": "_User",
      //         "objectId": "MAVFGjU7RR"
      //  }]
      var queryValue = [];
      for (var oneuser in userlist) {
        Map<String, String> onepointer = {
          "__type": "Pointer",
          "className": "_User",
          "objectId": oneuser["objectId"]
        };
        queryValue.add(onepointer);
      }
      print("queryValue is $queryValue");
      var queryBuilder2 = QueryBuilder<ParseObject>(ParseObject('AIPost'))
        ..orderByDescending('updatedAt')
        ..setAmountToSkip(skip)
        ..setLimit(limit)
        ..includeObject(['userpointer'])
        //..keysToReturn(["ownerUser", "imagesUrl", "userpointer","likes","commentnum"]) //, "imagesUrl"  //只返回指定的参数
        ..whereContainedIn("userpointer", queryValue);
      var apiResponse2 = await queryBuilder2.query();

      if (apiResponse2.success && apiResponse2.count > 0) {
        return apiResponse2.result;
      } else {
        print('queryPosts error $keyAppName: ${apiResponse2.error?.message}');
        return [];
      }
    } else {
      print('followings error $keyAppName: ${apiResponse.result}');
      return [];
    }
  }

  //某个人的关注列表---为了安全不对外提供
  static Future<List<dynamic>?> getFollowings(String userObjectId,
      {int limit = 30, int skip = 0}) async {
    final QueryBuilder<ParseUser> userQueryBuilder =
        QueryBuilder<ParseUser>(ParseUser.forQuery())
          ..setAmountToSkip(skip)
          ..setLimit(limit)
          ..whereEqualTo('userObjectId', userObjectId);
    var apiResponse = await userQueryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      //print('getFollowings success $keyAppName: ${apiResponse.result}');
      print('getFollowings success ${apiResponse.results!.first["Following"]}');
      return apiResponse.results!.first["Following"];
    } else {
      print('getFollowings error $keyAppName: ${apiResponse.result}');
      return [];
    }
  }

// 查看粉丝列表-----数据量大一般不提供或者只提供前1000个粉丝
// Future<List<dynamic>?> getFans(userObjectId) async {
//   ParseObject toUserObj;
//   var queryBuilder = QueryBuilder(ParseObject('Fans'))
//     ..whereEqualTo("toId", userObjectId);
//   var apiResponse = await queryBuilder.query();
//   if (apiResponse.success && apiResponse.count > 0) {
//     toUserObj = apiResponse.results!.first;
//     var relation = toUserObj.getRelation('follower');
//     var queryBuilder = relation.getQuery();
//     apiResponse = await queryBuilder.query();
//     if (apiResponse.success && apiResponse.count > 0) {
//       return apiResponse.results;
//     } else {
//       print('getFans error $keyAppName: ${apiResponse.result}');
//       return [];
//     }
//   } else {
//     print('getFans error $keyAppName: ${apiResponse.result}');
//     return [];
//   }
// }

//更新地理位置

//获取附近的人
  static Future<dynamic> getUsersNearby() async {
    // var myusers = <User>[];
    // print("查询用户列表: $myusers");
    // return myusers;
    return [];
  }

  //商品管理
  //商品上架/下载
  //{
  // "shopping": {
  //     "shoppingstatus": 1,  ----- 0：下架
  //     "shoppingfrom": "user123",
  //     "price": "99元",
  //     "sku": 3
  // }
  //}
  //Future<void> updatePost(String postId, Map<String, dynamic> params) async {}

  //更新商品库存
  static Future<void> updateShoppingSku(String postId, int amount) async {
    final post = ParseObject('AIPost')..objectId = postId;
    post.setIncrement("shopping.sku", amount);
    var apiResponse = await post.save();
    if (!apiResponse.success) {
      print('update sku error $keyAppName: ${apiResponse.result}');
    }
  }

  //商品分类列表: queryShopping(10, 0, "topic", "风景");
  //我上架的商品列表: queryShopping(10, 0, "shopping.shoppingfrom", "user12")
  //我拥有的商品列表: queryShopping(10, 0, "ownerUser", "user12")
  static Future<List<ParseObject>> queryShopping(
      int limit, int skip, String queryKey, dynamic queryValue) async {
    var queryBuilder = QueryBuilder<ParseObject>(ParseObject('AIPost'))
      //..orderByDescending('updatedAt')
      ..setAmountToSkip(skip)
      ..setLimit(limit)
      ..whereValueExists("shopping", true)
      ..whereEqualTo("shopping.shoppingstatus", 1)
      ..whereEqualTo(queryKey, queryValue);
    var apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.count > 0) {
      return apiResponse.result;
    } else {
      print('queryPosts error $keyAppName: ${apiResponse.error?.message}');
      return [];
    }
  }

  //订单管理
  //生成订单
  // {
  //     "userpointer": {
  //     "__type": "Pointer",
  //     "className": "_User",
  //     "objectId": "No7jNH1wtY"
  //    }
  //     "goods": [{"goodID":"postid1","number":1}, {"goodID":"postid2","number":1}],
  //     "address": "Beijing haidian",   ---订单地址
  //     "goodsType": "0",
  //     "mobile": "13889131234",       ---收件人联系方式
  //     "payPrice": "金额",
  //     "remark": "下单备注信息",
  //     "status": 0       ---订单状态：status  0：待提交 1：待支付 2：待发货 3：待收货  4：完成
  // }
  static Future<ParseObject> createOrder(
      String userId, Map<String, dynamic> params) async {
    var user = await ParseUser.currentUser();
    final order = ParseObject('AIOrder')..set('userpointer', user);
    //..set('userId', userId);

    for (var key in params.keys) {
      print('Key: $key, Value: ${params[key]}');
      order.set(key, params[key]);
    }

    var apiResponse = await order.save();
    if (apiResponse.success && apiResponse.count > 0) {
      //print('$keyAppName: ${apiResponse.result}');
      return order;
    } else {
      print("post save error ${apiResponse.error}");
      return apiResponse.results![0];
    }
  }

  //取消订单
  static Future<void> deleteOrder(String orderId) async {
    final order = ParseObject('AIOrder')..objectId = orderId;
    var response = await order.delete();
    print(response);
  }

  //订单支付  ---- 调用支付接口后更新支付状态
  //更新Order
  // {
  // "status": "xxx"
  // }
  static Future<void> updateOrder(
      String orderId, Map<String, dynamic> params) async {
    final order = ParseObject('AIOrder')..objectId = orderId;
    bool save = false;

    for (var key in params.keys) {
      print('Key: $key, Value: ${params[key]}');
      order.set(key, params[key]);
      save = true;
    }

    if (save) {
      var apiResponse = await order.save();
      if (apiResponse.success && apiResponse.count > 0) {
        print('$keyAppName: ${apiResponse.result}');
      }
    }
  }

  //订单详情
  static Future<ParseObject> getOrder(String orderId) async {
    final queryBuilder = QueryBuilder(ParseObject('AIOrder'))
      ..whereEqualTo('objectId', orderId);
    final apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      print(apiResponse.result);
      return apiResponse.result[0];
    } else {
      print('getPost error $keyAppName: ${apiResponse.result}');
      return apiResponse.result;
    }
  }

  // 我的订单
  // 分页查询
  static Future<List<ParseObject>> queryOrders(
      int limit, int skip, String queryKey, dynamic queryValue) async {
    var queryBuilder = QueryBuilder<ParseObject>(ParseObject('AIOrder'))
      ..orderByDescending('updatedAt')
      ..setAmountToSkip(skip)
      ..setLimit(limit)
      ..whereEqualTo(queryKey, queryValue);
    var apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.count > 0) {
      return apiResponse.result;
    } else {
      print('queryPosts error $keyAppName: ${apiResponse.error?.message}');
      return [];
    }
  }

  // APP config
  static Future<Map<String, dynamic>> getConfigs() async {
    final ParseConfig config = ParseConfig();
    final ParseResponse getResponse = await config.getConfigs();

    if (getResponse.success) {
      print('We have our configs:${getResponse.result}');
    } else {
      print('$keyAppName: ${getResponse.result}');
    }
    return getResponse.result;
  }


  //分类分页查询pos
  static Future<List<ParseObject>> getAllPostsByType(int limit,int skip, String topic) async {
    var myposts = <ParseObject>[];
    var queryBuilder = QueryBuilder(ParseObject('AIPost'))
      ..setLimit(limit)
      ..setAmountToSkip(skip)
      ..includeObject(['userpointer'])
      ..whereEqualTo("topic", topic);
    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      myposts =  apiResponse.result;
      return myposts;
    } else {
      return[];
    }
  }


  //关注用户的列表
  static Future<List<ParseObject>> getAllUsersToFollow(String userID) async {
    var myposts = <ParseObject>[];
    var queryBuilder = QueryBuilder(ParseObject('users'))
    ..whereRelatedTo("Following", "_User", userID);
    var apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.count > 0) {
      myposts =  apiResponse.result;
      return myposts;
    } else {
      return[];
    }
  }


}
