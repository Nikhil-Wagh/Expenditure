import 'package:expenditure/models/expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentExpenditures extends StatelessWidget {
  final int selectedExpenditureIndex;
  RecentExpenditures({@required this.selectedExpenditureIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _RecentExpendituresHeader(),
              SizedBox(height: 10),
              _ListExpenditures(selectedIndex: selectedExpenditureIndex),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListExpenditures extends StatefulWidget {
  int selectedIndex;
  _ListExpenditures({this.selectedIndex});

  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<_ListExpenditures> {
  @override
  Widget build(BuildContext context) {
    List<Expenditure> expenditures = Provider.of<List<Expenditure>>(context);

    if (expenditures == null) {
      // TODO: Showing a loading widget
      return Text("Still Loading .. Please wait");
    }

    print('[debug] _ListExpenditureState.build'
        '.expenditures.length = ${expenditures.length}');
    print('[debug] _ListExpenditureState.build'
        '.selectedIndex = ${widget.selectedIndex}');

    return Expanded(
      child: Container(
        child: NotificationListener<ExpenditureSelectedNotification>(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: expenditures.length,
            itemBuilder: (context, index) {
              print('[info] _ListExpendituresState.ListView'
                  '.builder.itemBuilder called on index = $index');

              return _ListItemExpenditure(
                id: index,
                expenditure: expenditures[index],
                selected: index == widget.selectedIndex,
              );
            },
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
          ),
          onNotification: (notification) {
            debugPrint('[debug] RecentExpenditure.ListExpenditureState got '
                'notification selectedIndex = ${notification.selectedIndex}');
            setState(() {
              widget.selectedIndex = notification.selectedIndex;
            });
            return false; // Send up the tree
          },
        ),
      ),
    );
  }
}

class _ListItemExpenditure extends StatefulWidget {
  final Expenditure expenditure;
  final int id;
  final bool selected;
  _ListItemExpenditure({
    @required this.id,
    @required this.expenditure,
    @required this.selected,
  });

  @override
  _ListItemExpenditureState createState() => _ListItemExpenditureState();
}

class _ListItemExpenditureState extends State<_ListItemExpenditure> {
  @override
  Widget build(BuildContext context) {
    final _cardBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Card(
        shape: _cardBorder,
        color: (widget.selected == true) ? Colors.indigo : Colors.blue[400],
        child: InkWell(
          customBorder: _cardBorder,
          onTap: () {
            setState(() {
              ExpenditureSelectedNotification(
                selectedIndex: widget.id,
              ).dispatch(context);
            });
            print('[info] ListItemExpenditure tapped');
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

class ExpenditureSelectedNotification extends Notification {
  final int selectedIndex;

  ExpenditureSelectedNotification({this.selectedIndex}) {
    print('[debug] SelectedNotification generated with index = $selectedIndex');
  }
}
