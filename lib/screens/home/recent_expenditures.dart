import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'list_item_expenditure.dart';

class RecentExpenditures extends StatelessWidget {
  static const String TAG = 'RecentExpenditures';

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
              ListExpenditures(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListExpenditures extends StatefulWidget {
  /*
   * It should load the list of expenditures and create individual element
   * from ListItemExpenditure, this will also specify the onTapHandler for
   * ListItemExpenditure and Dismissible.
   */

  @override
  _ListExpendituresState createState() => _ListExpendituresState();
}

class _ListExpendituresState extends State<ListExpenditures> {
  static const String TAG = 'ListExpendituresState';

  ItemScrollController _scrollController = ItemScrollController();

  Expenditures expenditures;

  @override
  Widget build(BuildContext context) {
    // Loading expenditures
    expenditures = Provider.of<Expenditures>(context);

    print('[debug] $TAG.build'
        '.expenditures.length = ${expenditures.length}');
    print('[debug] $TAG.build'
        '.selectedIndex = ${expenditures.selectedExpenditureRef}');

    return Container(
      child: Expanded(
        child: ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          itemCount: expenditures.length,
          itemBuilder: (context, index) {
            print('[info] _ListExpendituresState.ListView'
                '.builder.itemBuilder called on index = $index');

            return Dismissible(
              key: UniqueKey(),
              onDismissed: (_) {
                setState(() {
                  debugPrint('[info] ListExpenditure.Dissimissible called'
                      ' on element $index');

                  _dismissElement(index);
                });
              },
              child: ListItemExpenditure(
                id: index,
                expenditure: expenditures[index],
                selected: expenditures[index].ref == expenditures.selectedExpenditureRef,
                onTapHandler: _expenditureOnTapHandler,
              ),
              background: _buildCardBackground(Alignment.centerLeft),
              secondaryBackground: _buildCardBackground(Alignment.centerRight),
            );
          },
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  void _expenditureOnTapHandler(Expenditure selectedExpenditure) {
    debugPrint('[debug] $TAG.expenditureOnTapHandler called for expenditure ' + selectedExpenditure.toString());
    expenditures.select(selectedExpenditure);
    _scrollController.scrollTo(
      index: expenditures.indexOf(selectedExpenditure.ref),
      duration: Duration(milliseconds: 500),
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

  void _dismissElement(int index) {
    Expenditure element = expenditures[index];
    debugPrint('[info] removing from UI expenditure = $element');

    print('[info] Item $element will be removed');
    expenditures.removeAt(index);

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

      expenditures.insertAt(index, element);
      print('[info] Item $element will be inserted');
    });
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
