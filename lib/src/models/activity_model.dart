//import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  //final Timestamp timestamp;
  final String timestamp;

  Activity({
    required this.id,
    required this.fromUserId,
    required this.postId,
    required this.postImageUrl,
    required this.comment,
    required this.timestamp,
  });

  // factory Activity.fromDoc(DocumentSnapshot doc) {
  //   return Activity(
  //     id: doc.id,
  //     fromUserId: doc['fromUserId'],
  //     postId: doc['postId'],
  //     postImageUrl: doc['postImageUrl'],
  //     comment: doc['comment'],
  //     timestamp: doc['timestamp'],
  //   );
  //}
}
