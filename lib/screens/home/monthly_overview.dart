import 'package:expenditure/constants.dart';
import 'package:flutter/material.dart';

class MonthlyOverview extends StatefulWidget {
  @override
  _MonthlyOverviewState createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(mMargin),
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.darken,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryAccentColor,
            primaryColor,
          ],
        ),
        color: primaryColor,
      ),
      child: Container(
        margin: EdgeInsets.all(mMargin + 10),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Jan 2020",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Expenses",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                Text(
                  "Rs 32,000.00",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.alphaBlend(primaryColor, Colors.black),
                  ),
                  child: Text(
                    "Income",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.alphaBlend(primaryColor, Colors.black),
                  ),
                  child: Text(
                    "Remaining",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            )
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     LinearProgressIndicator(
            //       value: 0.7,
            //       backgroundColor: Colors.white,
            //       // valueColor: Animation<Color>(),
            //       minHeight: 16,
            //     ),
            //     Text(
            //       "70%",
            //       style: TextStyle(fontSize: 16, color: Colors.purple),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
