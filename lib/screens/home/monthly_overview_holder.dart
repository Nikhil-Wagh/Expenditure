import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/constants.dart';
import 'package:expenditure/models/monthly_overview.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';

import 'monthly_overview_detail.dart';

class MonthlyOverviewHolder extends StatefulWidget {
  @override
  _MonthlyOverviewHolderState createState() => _MonthlyOverviewHolderState();
}

class _MonthlyOverviewHolderState extends State<MonthlyOverviewHolder> {
  Color fontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(minHeight: 150),
      margin: EdgeInsets.all(mMargin),
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.darken,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          tileMode: TileMode.repeated,
          // transform: ,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // transform: GradientTransform(),
          colors: [
            // Colors.orange, // Accents with purple
            Colors.purple[900], // Accents with greens
            Colors.indigo, // Accents with red
          ],
        ),
        color: primaryColor,
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().monthlyOverviewStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          MonthlyOverview data = DatabaseService().monthlyOverviewFromSnapshot(snapshot);
          return MonthlyOverviewDetail(monthlyOverviewData: data);
        },
      ),
    );
  }
}
