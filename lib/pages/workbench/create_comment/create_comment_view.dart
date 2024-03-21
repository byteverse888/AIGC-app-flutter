import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_comment_logic.dart';

import '../../../core/controller/im_controller.dart';
import '../../../src/parse_services/database_service.dart';
import '../../../src/models/comment_model.dart';
import '../../../widgets/widgets.dart';

class CreateCommentPage extends StatefulWidget {
  @override
  _CreateCommentPageState createState() => _CreateCommentPageState();
}

class _CreateCommentPageState extends State<CreateCommentPage> {
  final logic = Get.find<CreateCommentLogic>();
  final imLogic = Get.find<IMController>();
  var currentPost = Get.arguments;

  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  List<Widget> _getCommentsList(var comments) {
    var list = <Widget>[];
    //comments
    var length = comments.length;
    for (var index = 0; index < length; index++) {
      var onecomment = _buildComment(comments[index]);
      list.add(onecomment);
    }
    return list;
  }

  _buildComment(Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/user_placeholder.jpg'),
      ),
      title: Text(comment.authorId),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(comment.content),
          SizedBox(height: 6.0),
          Text(
            comment.timestamp!,
            //DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
            //"20221106-jincm2",
          ),
        ],
      ),
    );
  }

  _buildCommentTF() {
    final currentUserId = imLogic.userInfo.value.getShowName();

    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Expanded(
              // child: TextField(
              //   controller: _commentController,
              //   textCapitalization: TextCapitalization.sentences,
              //   onChanged: (input) {
              //     print("输入的评论字符串为: $input");
              //     setState(() {
              //       _isCommenting = true;
              //     });
              //   },
              //   decoration: InputDecoration.collapsed(hintText: '发布评论'),
              // ),
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 18.0),
                minLines: 2,
                maxLines: 6,
                //autofocus: true,
                showCursor: true,
                decoration: InputDecoration(
                  labelText: '内心真实的想法...',
                  border: OutlineInputBorder(),
                ),
                //onChanged: (input) => _caption = input,
                onChanged: (input) {
                  print("输入的评论字符串为: $input");
                  setState(() {
                    //_caption = input;
                    _isCommenting = true;
                  });
                },
                //decoration: InputDecoration.collapsed(hintText: '发布评论'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_isCommenting) {
                    DatabaseService.createComment(currentUserId,
                        currentPost.id!, _commentController.text);
                    //print("提交一个评论");
                    _commentController.clear();
                    setState(() {
                      _isCommenting = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var curComments_widgets;
    return FutureBuilder(
        future: DatabaseService.getPostComments(currentPost.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            var mycomments = snapshot.data;
            curComments_widgets = _getCommentsList(mycomments);

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: BackButton(color: Colors.black),
                centerTitle: false,
                title: Text(
                  '评论',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: ListView(
                //显示post and comments 等信息
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  PostContainer(post: currentPost),
                  ...curComments_widgets,
                  Divider(height: 1.0),
                  _buildCommentTF(),
                ],
              ),
            );
            //return SizedBox.shrink();
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
