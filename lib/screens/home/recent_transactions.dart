import 'package:flutter/material.dart';

class RecentTransactions extends StatefulWidget {
  @override
  _RecentTransactionsState createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<Text> _sampleList = <Text>[
    Text("Hello World"),
    Text("Jurrasic Park"),
    Text("Hello World"),
    Text("Jurrasic Park"),
    Text("Hello World"),
    Text("Jurrasic Park"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        // color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Transactions",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: _sampleList,
            )
          ],
        ));
  }
}
