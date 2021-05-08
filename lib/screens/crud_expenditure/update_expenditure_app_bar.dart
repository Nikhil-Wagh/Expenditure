import 'package:flutter/material.dart';

class UpdateExpenditureAppBar extends StatelessWidget {
  final String header;
  final void Function() onBackPressed;
  final Widget action;
  UpdateExpenditureAppBar({@required this.header, @required this.onBackPressed, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24.0),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              onBackPressed();
              // Navigator.pop(context);
            },
            padding: EdgeInsets.all(0),
            iconSize: 28,
            constraints: BoxConstraints(maxHeight: 28, maxWidth: 28),
          ),

          // SizedBox(width: 16),
          Center(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: action,
          )
        ],
      ),
    );
  }
}
