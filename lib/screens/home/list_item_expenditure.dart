import 'package:expenditure/models/expenditure_item.dart';
import 'package:flutter/material.dart';

class ListItemExpenditure extends StatelessWidget {
  final Expenditure expenditure;
  final int id;
  final bool selected;
  final Function(Expenditure) onTapHandler;
  final Function(Expenditure) onLongPressHandler;
  ListItemExpenditure({
    @required this.id,
    @required this.expenditure,
    @required this.selected,
    @required this.onTapHandler,
    this.onLongPressHandler,
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
        onLongPress: () {
          debugPrint('[info] $TAG long press');
          onLongPressHandler(expenditure);
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: (selected == true) ? Colors.indigo : Colors.blue[400],
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: _borderRadius,
          ),
          child: Column(
            children: [
              Row(
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
                  Text(
                    expenditure.amount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
