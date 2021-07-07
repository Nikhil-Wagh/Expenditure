import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/screens/crud_expenditure/edit_expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'list_item_expenditure.dart';

class RecentExpenditures extends StatelessWidget {
  static const String TAG = 'RecentExpenditures';

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] $TAG build called');
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

  ItemScrollController _scrollController;

  Expenditures expenditures;

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] $TAG build called');
    // Loading expenditures
    expenditures = Provider.of<Expenditures>(context);
    _scrollController = Provider.of<ItemScrollController>(context);

    if (expenditures.isLoading) {
      // TODO: Create a loading placeholder
      return Container(child: Text('Loading ...'));
    }

    print('[debug] $TAG.build'
        '.expenditures.length = ${expenditures.length}');
    print('[debug] $TAG.build'
        '.selectedIndex = ${expenditures.selectedExpenditureRef}');

    return Expanded(
      child: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: expenditures.length,
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemBuilder: (context, index) {
          print('[info] _ListExpendituresState.ListView'
              '.builder.itemBuilder called on index = $index');
          // Using custom Dismissible instead of lib Slidable because of
          // padding issue between the background and slidable object
          // which for now is not customisable.
          return ListItemExpenditure(
            id: index,
            expenditure: expenditures[index],
            selected: expenditures[index].ref == expenditures.selectedExpenditureRef,
            onTapHandler: _expenditureOnTapHandler,
            onMoreOptionsPressHandler: _expenditureOnMoreOptionsPressHandler,
          );
        },
      ),
    );
  }

  void _editExpenditure(Expenditure oldExpenditure) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditExpenditure(oldExpenditure),
        ));
  }

  void _expenditureOnTapHandler(Expenditure selectedExpenditure) {
    debugPrint('[debug] $TAG.expenditureOnTapHandler called for expenditure ' + selectedExpenditure.toString());
    expenditures.select(selectedExpenditure);
    _scrollController.scrollTo(
      index: expenditures.indexOf(selectedExpenditure.ref),
      duration: Duration(milliseconds: 500),
    );
  }

  void _expenditureOnMoreOptionsPressHandler(Expenditure element) {
    debugPrint('[debug] $TAG.expenditureOnLongPressHandler called for expenditure ' + element.toString());
    expenditures.select(element);
    _editExpenditure(element);
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
