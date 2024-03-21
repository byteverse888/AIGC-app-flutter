//import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  final String authorId;
  String? userid;
  String? user_faceURL;
  String? title;
  String? caption;
  String? timestamp;
  int? likes;
  int? reports;
  int? comments;
  List<String>? imagesUrl;
  String? position;
  //final int? shares;

  Post({
    this.id,
    required this.authorId,
    this.userid,
    this.user_faceURL,
    this.title,
    this.caption,
    this.imagesUrl,
    this.likes,
    this.comments,
    this.reports,
    this.position,
    this.timestamp,
  });

  factory Post.fromJson(var json) {
    var imagesUrl;
    if (json['imagesUrl'] != null) {
      imagesUrl = json['imagesUrl'].cast<String>();
    } else {
      imagesUrl = null;
    }
    return Post(
        id: json['objectId'],
        authorId: json['authorId'],
        userid: json['userid'],
        title: json['title'],
        caption: json['caption'],
        imagesUrl: imagesUrl,
        likes: json['likes'],
        comments: json['comments'],
        reports: json['reports'],
        position: json['position'].toString(),
        timestamp: json['updatedAt'].toString());
  }
  // factory Post.fromDoc(DocumentSnapshot doc) {
  //   return Post(
  //     id: doc.id,
  //     imageUrl: doc['imageUrl'],
  //     caption: doc['caption'],
  //     likeCount: doc['likeCount'],
  //     authorId: doc['authorId'],
  //     timestamp: doc['timestamp'],
  //   );
  // }
}
