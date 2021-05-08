import 'package:expenditure/constants.dart';

import 'package:flutter/material.dart';

import 'expenditure_form_body.dart';
import 'update_expenditure_app_bar.dart';

class AddNewExpenditure extends StatelessWidget {
  final void Function() onBackPressed;
  AddNewExpenditure({this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] AddNewExpenditure.build called');
    return Container(
        padding: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UpdateExpenditureAppBar(
              header: 'Add New Expenditure',
              onBackPressed: onBackPressed,
            ),
            // Go to home, same behaviour as when back is pressed
            ExpenditureFormBody(onSaved: onBackPressed)
          ],
        ));
  }
}
