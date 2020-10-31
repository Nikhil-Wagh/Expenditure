import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_expenditures.dart';

class RecentExpenditures extends StatelessWidget {
  final String uid;
  RecentExpenditures({this.uid});

  @override
  Widget build(BuildContext context) {
    print('[debug] RecentExpendituresState.build.uid = $uid');
    return StreamProvider<QuerySnapshot>(
      create: (context) {
        return DatabaseService(uid: uid).expenditures;
      },
      lazy: false,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Recent Expenditures",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            ListExpenditures(),
          ],
        ),
      ),
    );
  }
}
