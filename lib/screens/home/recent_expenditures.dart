import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_expenditures.dart';

class RecentExpenditures extends StatefulWidget {
  final String uid;
  RecentExpenditures({this.uid});

  @override
  _RecentExpendituresState createState() => _RecentExpendituresState(this.uid);
}

class _RecentExpendituresState extends State<RecentExpenditures> {
  List<Text> _sampleList = <Text>[
    Text("Hello World"),
    Text("Jurrasic Park"),
    Text("Hello World"),
    Text("Jurrasic Park"),
    Text("Hello World"),
    Text("Jurrasic Park"),
  ];

  String uid;
  _RecentExpendituresState(String uid) {
    this.uid = uid;
  }

  @override
  Widget build(BuildContext context) {
    print("[info]Getting snapshot");
    print("[debug] RecentExpenditureState.uid = $uid");
    DatabaseService(uid: uid).getUserSnapshot();

    return Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        // color: Colors.blue,
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
            StreamProvider<QuerySnapshot>.value(
              value: DatabaseService(uid: uid).expenditures,
              child: ListExpenditures(),
            ),
          ],
        ));
  }
}
