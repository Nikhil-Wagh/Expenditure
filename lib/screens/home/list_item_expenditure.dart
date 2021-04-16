import 'package:expenditure/models/expenditure_item.dart';
import 'package:flutter/material.dart';

// TODO: Make this a stateless widget
class ListItemExpenditure extends StatefulWidget {
  final Expenditure expenditure;
  final int id;
  final bool selected;
  final Function(Expenditure) onTapHandler;
  ListItemExpenditure({
    @required this.id,
    @required this.expenditure,
    @required this.selected,
    @required this.onTapHandler,
  });

  @override
  _ListItemExpenditureState createState() => _ListItemExpenditureState();
}

class _ListItemExpenditureState extends State<ListItemExpenditure> {
  static const _borderRadius = BorderRadius.all(Radius.circular(10));
  static const _cardBorder = RoundedRectangleBorder(
    borderRadius: _borderRadius,
  );

  static const String TAG = 'ListItemExpenditureState';

  @override
  Widget build(BuildContext context) {
    // debugPrint('[info] $TAG.build called');
    debugPrint('[debug] $TAG id = ${widget.id}, selected = ${widget.selected}');
    return Card(
      margin: EdgeInsets.all(4),
      shape: _cardBorder,
      child: InkWell(
        customBorder: _cardBorder,
        onTap: () {
          print('[info] ListItemExpenditure tapped');
          widget.onTapHandler(widget.expenditure);
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
