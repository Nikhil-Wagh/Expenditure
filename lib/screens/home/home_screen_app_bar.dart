import 'package:expenditure/models/expenditure.dart';
import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/home/recent_expenditures.dart';
import 'package:expenditure/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenAppBar extends StatelessWidget {
  // HomeScreenAppBar();

  // final String displayName, photoURL;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final String displayName = user.displayName;
    final String photoURL = user.photoURL;

    final List<Expenditure> expenditures = Provider.of<List<Expenditure>>(context);

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
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  displayName,
                  style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 38,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(expenditures: expenditures),
            ),
          )
        ],
      ),
    );
  }

  choicesAction(value) {
    switch (value) {
      case "Logout":
        AuthService().signOut();
    }
  }
}

class CustomSearchDelegate extends SearchDelegate<Expenditure> {
  final List<Expenditure> expenditures;

  CustomSearchDelegate({this.expenditures});

  int selectedIndex = 0;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
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
    return Container(
      child: Center(child: Text(expenditures[selectedIndex].description)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Expenditure> suggestionList = [];
    debugPrint('[info] building suggestions');
    query.isEmpty
        ? suggestionList = expenditures
        : suggestionList.addAll(
            expenditures.where((element) => element.contains(
                  query.toLowerCase(),
                )),
          );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: NotificationListener<ExpenditureSelectedNotification>(
          onNotification: (notification) {
            close(context, expenditures[notification.selectedIndex]);
            return true;
          },
          child: ListExpenditures(
            selectedIndex: -1,
            expenditures: suggestionList,
            shouldScroll: false,
          )),
    );
  }
}
