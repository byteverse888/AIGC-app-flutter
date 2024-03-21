//import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? id;
  final String authorId;
  final String postId;
  final String content;
  //final Timestamp timestamp;
  final String? timestamp;

  Comment({
    this.id,
    required this.authorId,
    required this.postId,
    required this.content,
    this.timestamp,
  });

  factory Comment.fromJson(var json) {
    return Comment(
      id: json['objectId'],
      authorId: json['authorId'],
      postId: json['postId'],
      content: json['content'],
      timestamp: json['updatedAt'].toString(),
    );
  }
}
