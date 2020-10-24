import 'package:expenditure/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreenAppBar extends StatelessWidget {
  String displayName, photoURL;
  HomeScreenAppBar({this.displayName, this.photoURL});

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
                image: NetworkImage(photoURL),
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
                  displayName,
                  style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Icon(
            Icons.notifications_none,
            size: 38,
          ),
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.more_vert,
              size: 38,
              color: Colors.black,
            ),
            onSelected: (value) => choicesAction(value),
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  value: "Logout",
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text("Sign out")
                      ],
                    ),
                  ),
                )
              ];
            },
            // onSelected: ,
          ),
        ],
      ),
    );
  }

  choicesAction(value) {
    switch (value) {
      case "Logout":
        AuthService().signOut();
    }
  }
}
