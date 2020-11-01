import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/screens/home/list_item_expenditure.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListExpenditures extends StatefulWidget {
  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<ListExpenditures> {
  @override
  Widget build(BuildContext context) {
    print("provider = ${Provider.of<QuerySnapshot>(context)}");
    final expendituresSnapshots = Provider.of<QuerySnapshot>(context);

    if (expendituresSnapshots == null) {
      // TODO: Pretify me
      return Text("Nothing to see here");
    }

    final expenditures = DatabaseService.expendituresListFromSnapshots(expendituresSnapshots);

    print('[debug] _ListExpenditureState.build.expenditures = $expenditures');
    print('[debug] _ListExpenditureState.build.expenditures.length = ${expenditures.length}');

    return ListView.builder(
      shrinkWrap: true,
      // padding: EdgeInsets.all(0),
      itemCount: expenditures.length,
      itemBuilder: (context, index) {
        print("[info] _ListExpendituresState.ListView.builder.itemBuilder called");
        return ListItemExpenditure(expenditure: expenditures[index]);
      },
    );
  }
}
