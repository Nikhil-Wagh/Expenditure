import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenditure_form_body.dart';

class EditExpenditure extends StatefulWidget {
  final Expenditure expenditure;
  EditExpenditure(this.expenditure);
  @override
  _EditExpenditureState createState() => _EditExpenditureState();
}

class _EditExpenditureState extends State<EditExpenditure> {
  @override
  Widget build(BuildContext context) {
    debugPrint('[info] AddNewExpenditure.build called');
    return Container(
        padding: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            EditExpenditureAppBar(),
            ExpenditureFormBody(
              expenditure: widget.expenditure,
            )
          ],
        ));
  }
}

class EditExpenditureAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24.0),
      child: Stack(
        children: [
          Icon(
            Icons.arrow_back,
            size: 24.0,
          ),
          // SizedBox(width: 16),
          Center(
              child: Text(
            'Edit New Expenditure',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ))
        ],
      ),
    );
  }
}
