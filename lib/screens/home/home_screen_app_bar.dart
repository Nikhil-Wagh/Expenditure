import 'package:expenditure/models/user.dart';
import 'package:flutter/material.dart';

class HomeScreenAppBar extends StatelessWidget {
  final User user;
  HomeScreenAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            child: CircleAvatar(
              maxRadius: 24,
              child: Image(
                image: NetworkImage(user.photoURL),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.displayName,
                  style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Icon(
            Icons.notifications_none,
            size: 38,
          ),
          Icon(
            Icons.more_vert,
            size: 40,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
