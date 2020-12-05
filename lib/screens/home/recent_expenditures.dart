import 'package:expenditure/models/expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentExpenditures extends StatelessWidget {
  final String uid;
  RecentExpenditures({this.uid});

  @override
  Widget build(BuildContext context) {
    print('[debug] RecentExpendituresState.build.uid = $uid');
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _RecentExpendituresHeader(),
            SizedBox(height: 10),
            _ListExpenditures(),
          ],
        ),
      ),
    );
  }
}

class _ListExpenditures extends StatefulWidget {
  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<_ListExpenditures> {
  @override
  Widget build(BuildContext context) {
    List<Expenditure> expenditures = Provider.of<List<Expenditure>>(context);

    print('[debug] _ListExpenditureState.build.expenditures = $expenditures');
    print('[debug] _ListExpenditureState.build.expenditures.length = ${expenditures.length}');

    if (expenditures == null) {
      return Text("Still Loading .. Please wait");
    }
    return ListView.builder(
      shrinkWrap: true,
      reverse: true, // latest first
      itemCount: expenditures.length,
      itemBuilder: (context, index) {
        print("[info] _ListExpendituresState.ListView.builder.itemBuilder called");
        return _ListItemExpenditure(id: index, expenditure: expenditures[index]);
      },
    );
  }
}

class _ListItemExpenditure extends StatefulWidget {
  final Expenditure expenditure;
  final int id;
  _ListItemExpenditure({@required this.id, @required this.expenditure});

  @override
  _ListItemExpenditureState createState() => _ListItemExpenditureState();
}

class _ListItemExpenditureState extends State<_ListItemExpenditure> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final _cardBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Card(
        shape: _cardBorder,
        color: (selected == true) ? Colors.indigo : Colors.blue[400],
        child: InkWell(
          customBorder: _cardBorder,
          onTap: () {
            setState(() {
              selected = true;
              SelectedNotification(selectedIndex: widget.id);
            });
            print('[info] ListItemExpenditure tapped');
            print('[debug] ListItemExpenditure.selected = $selected');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.expenditure.description,
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
                          widget.expenditure.amount.toString(),
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
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      // TODO:
                      // These take values that are not in database,
                      // which is incorrect
                      // They should be assigned default values by model or database
                      widget.expenditure.timestampToString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentExpendituresHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Recent Expenditures",
      style: Theme.of(context).textTheme.headline6.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class SelectedNotification extends Notification {
  final int selectedIndex;

  SelectedNotification({this.selectedIndex}) {
    print('[debug] SelectedNotification generated with index = $selectedIndex');
  }
}

