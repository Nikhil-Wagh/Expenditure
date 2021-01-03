import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/services/database.dart';
import 'package:expenditure/utils/expenditure_selected_notification.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RecentExpenditures extends StatelessWidget {
  final int selectedExpenditureIndex;
  final List<Expenditure> expenditures;
  final bool shouldScroll;
  RecentExpenditures({
    @required this.selectedExpenditureIndex,
    @required this.expenditures,
    this.shouldScroll = true,
  });

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
              ListExpenditures(
                selectedIndex: selectedExpenditureIndex,
                expenditures: expenditures,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListExpenditures extends StatefulWidget {
  int selectedIndex;
  final List<Expenditure> expenditures;
  ListExpenditures({
    @required this.selectedIndex,
    @required this.expenditures,
  }) {
    assert(
        expenditures != null,
        'ListExpenditures received a null for '
        'expenditures, it should be a list');
  }

  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<ListExpenditures> {
  ItemScrollController _scrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.shouldScroll)
    //     _scrollController.scrollTo(
    //       index: widget.selectedIndex,
    //       duration: Duration(milliseconds: 500),
    //     );
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('[debug] _ListExpenditureState.build'
        '.expenditures.length = ${widget.expenditures.length}');
    print('[debug] _ListExpenditureState.build'
        '.selectedIndex = ${widget.selectedIndex}');

    return Container(
      child: Expanded(
        child: NotificationListener<ExpenditureSelectedNotification>(
          child: ScrollablePositionedList.builder(
            itemScrollController: _scrollController,
            itemCount: widget.expenditures.length,
            itemBuilder: (context, index) {
              print('[info] _ListExpendituresState.ListView'
                  '.builder.itemBuilder called on index = $index');

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (_) {
                  setState(() {
                    debugPrint('[info] RecentExpenditure.Dissimissible called'
                        ' on element $index');

                    Expenditure element = widget.expenditures.elementAt(index);
                    debugPrint('[info] removing from UI expenditure = $element');
                    widget.expenditures.removeAt(index);

                    debugPrint('[debug] attempting to remove from database');
                    DatabaseService.removeExpenditure(
                      element,
                    ).catchError((error) {
                      debugPrint('[error] Unable to delete');
                      debugPrint('[error] $error');
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Unable to delete expenditure .. Please try again',
                      )));
                      widget.expenditures.insert(index, element);
                    });
                  });
                },
                child: _ListItemExpenditure(
                  id: index,
                  expenditure: widget.expenditures[index],
                  selected: index == widget.selectedIndex,
                ),
                background: _buildCardBackground(Alignment.centerLeft),
                secondaryBackground: _buildCardBackground(Alignment.centerRight),
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
              int selectedIndex = notification.selectedIndex;
              widget.selectedIndex = selectedIndex;
              _scrollController.scrollTo(
                index: selectedIndex,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            });
            return false; // Send up the tree
          },
        ),
      ),
    );
  }

  Widget _buildCardBackground(Alignment position) {
    return Container(
      color: Colors.red,
      alignment: position,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4,
      ),
      child: Icon(Icons.delete, color: Colors.white),
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
  static const _borderRadius = BorderRadius.all(Radius.circular(10));
  static const _cardBorder = RoundedRectangleBorder(
    borderRadius: _borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      shape: _cardBorder,
      child: InkWell(
        customBorder: _cardBorder,
        onTap: () {
          print('[info] ListItemExpenditure tapped');
          setState(() {
            ExpenditureSelectedNotification(
              selectedIndex: widget.id,
            ).dispatch(context);
          });
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: (widget.selected == true) ? Colors.indigo : Colors.blue[400],
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: _borderRadius,
          ),
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
