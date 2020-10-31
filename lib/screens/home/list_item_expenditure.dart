import 'dart:math';

import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure.dart';
import 'package:flutter/material.dart';
import 'package:expenditure/utils.dart';

class ListItemExpenditure extends StatelessWidget {
  final Expenditure expenditure;
  ListItemExpenditure({this.expenditure});

  @override
  Widget build(BuildContext context) {
    print('[debug] ListItemExpenditure item = $expenditure');
    // print('[DEBUG] SHIT ${Util.getCurrency()}');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      color: Colors.indigo,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    expenditure.description,
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                ),
                SizedBox(width: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      // child: ,
                      child: Text(
                        "Rs ",
                        // expenditure.amount.currency.format(expenditure.amount),
                        // expenditure.currency,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      expenditure.amount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(expenditure.timestamp.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
