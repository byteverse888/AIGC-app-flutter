import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

import '../../routes/app_navigator.dart';
import '../../widgets/widgets.dart';
import '../../src/models/user_model.dart';

class UserContainer extends StatelessWidget {
  final User user;

  const UserContainer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: isDesktop ? 5.0 : 0.0,
      ),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _UserHeader(user: user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final User user;

  const _UserHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => AppNavigator.startMyInfo(),
        child: Row(
          children: [
            AvatarView(url: user.faceURL),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nickname ?? user.id!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${user.username} • ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        '${user.userid} • ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text("签名:" + (user.bio ?? "啥也没有....")),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () => print('More'),
            ),
          ],
        ));
  }
}
