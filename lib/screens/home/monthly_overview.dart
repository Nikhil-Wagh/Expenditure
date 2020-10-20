import 'package:expenditure/constants.dart';
import 'package:flutter/material.dart';

class MonthlyOverview extends StatefulWidget {
  @override
  _MonthlyOverviewState createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview> {
  Color fontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Rs 1,00,000.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Jan 2020",
                        style: TextStyle(
                          fontSize: 16,
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            Divider(
              height: 40,
              thickness: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Income",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs 1,10,000.000",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expenses",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Rs 10,000.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
