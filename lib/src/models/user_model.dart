class User {
  String? id;
  String? username;
  String? userid;
  String? nickname;
  String? faceURL;
  String? email;
  String? bio;
  String? user_pos;

  User({
    this.id,
    this.username,
    this.userid,
    this.nickname,
    this.faceURL,
    this.email,
    this.bio,
    this.user_pos,
  });

  factory User.fromJson(var json) {
    return User(
      id: json['objectId'],
      username: json['username'],
      userid: json['userid'],
      nickname: json['nickname'],
      faceURL: json['faceURL'],
      email: json['email'],
      bio: json['bio'],
      user_pos: json['user_pos'],
    );
  }
}
