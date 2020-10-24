import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListExpenditures extends StatefulWidget {
  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<ListExpenditures> {
  Widget _noExpendituresYet() {
    return Text("No expenditures, yaay");
  }

  @override
  Widget build(BuildContext context) {
    final expenditures = Provider.of<QuerySnapshot>(context);

    print("[info] Getting expenditures");

    for (var exp in expenditures.docs) {
      print("exp = ${exp.data()}");
    }

    if (expenditures != null) {
      print("NOT NULL");
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: expenditures.size,
        itemBuilder: (context, index) {
          print("[info] ListExpenditure.ListView.builder.itemBuilder called");
          return Text("Amount = ${expenditures.docs[index].get("amount")}");
        },
      );
    } else
      return _noExpendituresYet();
  }
}
