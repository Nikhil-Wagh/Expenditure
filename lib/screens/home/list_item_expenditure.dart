import 'package:expenditure/models/expenditure_item.dart';
import 'package:flutter/material.dart';

class ListItemExpenditure extends StatelessWidget {
  final Expenditure expenditure;
  final int id;
  final bool selected;
  final Function(Expenditure) onTapHandler;
  final Function(Expenditure) onMoreOptionsPressHandler;
  ListItemExpenditure({
    @required this.id,
    @required this.expenditure,
    @required this.selected,
    @required this.onTapHandler,
    this.onMoreOptionsPressHandler,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(10));
  static const _cardBorder = RoundedRectangleBorder(
    borderRadius: _borderRadius,
  );

  static const String TAG = 'ListItemExpenditure';

  @override
  Widget build(BuildContext context) {
    // debugPrint('[info] $TAG.build called');
    debugPrint('[debug] $TAG id = $id, selected = $selected');
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: _cardBorder,
      child: InkWell(
        customBorder: _cardBorder,
        onTap: () {
          print('[info] $TAG tapped');
          onTapHandler(expenditure);
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: (selected == true) ? Colors.indigo : Colors.blue[400],
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: _borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    expenditure.description,
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        expenditure.amount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        expenditure.timestampToString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  // Icon(Icons.more_vert, color: Colors.white),
                  if (onMoreOptionsPressHandler != null)
                    IconButton(
                      color: Colors.white,
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => onMoreOptionsPressHandler(expenditure),
                      icon: Icon(Icons.more_vert),
                      constraints: BoxConstraints(maxWidth: 32),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
