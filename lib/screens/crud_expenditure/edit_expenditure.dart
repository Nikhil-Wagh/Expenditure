import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenditure_form_body.dart';
import 'update_expenditure_app_bar.dart';

class EditExpenditure extends StatefulWidget {
  final Expenditure expenditure;
  EditExpenditure(this.expenditure);
  @override
  _EditExpenditureState createState() => _EditExpenditureState();
}

class _EditExpenditureState extends State<EditExpenditure> {
  Expenditures expenditures;

  static const String TAG = 'EditExpenditure';
  @override
  Widget build(BuildContext context) {
    expenditures = Provider.of<Expenditures>(context);

    debugPrint('[info] $TAG.build called');
    return Container(
        padding: EdgeInsets.only(left: mMargin, right: mMargin, top: mMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UpdateExpenditureAppBar(
              header: 'Edit Expenditure',
              onBackPressed: _navigateToHome,
              action: _buildDeleteExpenditureAction(),
            ),
            ExpenditureFormBody(
              expenditure: widget.expenditure,
              onSaved: _navigateToHome,
            )
          ],
        ));
  }

  void _navigateToHome() {
    Navigator.pop(context);
  }

  Widget _buildDeleteExpenditureAction() {
    return IconButton(
      onPressed: () async {
        bool confirmDelete = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete expenditure?'),
                  content: Text('Are you sure, you want to delete this item?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(false),
                        child: Text('No')),
                    TextButton(
                        onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(true),
                        child: Text('Yes')),
                  ],
                ));
        if (confirmDelete) {
          _deleteExpenditure(widget.expenditure);
        }
      },
      icon: Icon(Icons.delete),
      padding: EdgeInsets.all(0),
      iconSize: 28,
      constraints: BoxConstraints(maxHeight: 28, maxWidth: 28),
    );
  }

  void _deleteExpenditure(Expenditure element) {
    int index = expenditures.indexOf(element.ref);
    expenditures.removeAt(index);

    debugPrint('[debug] $TAG attempting to remove from database');
    DatabaseService.removeExpenditure(element).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Deleted Sucessfully'),
            action: SnackBarAction(
              label: 'Undo',
              // On undo insert element again
              onPressed: () {
                _undoDelete(index, element);
              },
            )),
      );
    }).catchError((error) {
      debugPrint('[error] $TAG Unable to delete');
      debugPrint('[error] $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete expenditure')),
      );
    }).then((_) => _navigateToHome());
  }

  void _undoDelete(index, element) {
    expenditures.insertAt(index, element);
    DatabaseService.addNewExpenditure(element);
  }
}
