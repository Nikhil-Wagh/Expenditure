import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchExpenditure extends StatefulWidget {
  @override
  _SearchExpenditureState createState() => _SearchExpenditureState();
}

class _SearchExpenditureState extends State<SearchExpenditure> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _SearchBar(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.selectSearch),
          onPressed: () => showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
          ),
        )
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  String query;
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
    InheritedBlocs.of(context);

    return Container(
      child: StreamBuilder(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

class InheritedBlocs extends InheritedWidget {
  static InheritedBlocs of(BuildContext context) {}

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}
