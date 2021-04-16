import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/home/list_item_expenditure.dart';
import 'package:expenditure/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenAppBar extends StatelessWidget {
  static const TAG = 'HomeScreenAppBar';

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final Expenditures expenditures = Provider.of<Expenditures>(context);

    assert(user != null, 'No user provided to HomeScreenAppBar');

    final String displayName = user.displayName;
    final String photoURL = user.photoURL;

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.all(
                  Radius.circular(14.0),
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: CircleAvatar(
                maxRadius: 24,
                child: Image(
                  image: NetworkImage(photoURL),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(welcome,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    )),
                Text(displayName,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              debugPrint("Sign out button pressed");
              AuthService().signOut();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 38,
            ),
            onPressed: () => showSearch(
              context: context,
              // FIXME: This doesn't updates on item select
              delegate: CustomSearchDelegate(expenditures: expenditures),
            ),
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<Expenditure> {
  final Expenditures expenditures;

  CustomSearchDelegate({this.expenditures});
  static const String TAG = 'CustomSearchDelegate';

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) close(context, null);
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Just close the search bar as selectedExpenditureRef is updated
    debugPrint('[debug] $TAG, buildResults called. Closing Search');
    close(context, null);
    return Container(); // This is never shown, we close search on selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Expenditure> listExpenditures = expenditures.items.where((item) => item.toString().toLowerCase().contains(query.toLowerCase())).toList();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        child: ListView.builder(
          itemCount: listExpenditures.length,
          itemBuilder: (context, index) {
            debugPrint('[debug] $TAG.ListViewBuilder for expenditure: ${listExpenditures[index].toString()}');
            return ListItemExpenditure(
              id: index,
              expenditure: listExpenditures[index],
              selected: false,
              onTapHandler: (Expenditure selectedExpenditure) {
                debugPrint('[debug] $TAG.onTapHandler called for expenditure ' + selectedExpenditure.toString());
                expenditures.select(selectedExpenditure);
                close(context, null);
              },
            );
          },
        ),
      ),
    );
  }
}
