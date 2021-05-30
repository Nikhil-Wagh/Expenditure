import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/utils.dart';
import 'package:expenditure/utils/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'time_series_expenditures.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  static const String TAG = 'AnalyticsPage';
  DateTime currentMonth;

  @override
  void initState() {
    currentMonth = DateTime.now();
    super.initState();
  }

  void _goToPreviousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    debugPrint('[debug] $TAG going to next month');
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
    debugPrint('[debug] $TAG :: $currentMonth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: MonthController(
            currentMonth,
            onLeftPressed: _goToPreviousMonth,
            onRightPressed: _goToNextMonth,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                showMonthPicker(
                  context: context,
                  initialDate: currentMonth,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      currentMonth = value;
                    });
                  }
                });
              },
            )
          ]),
      body: GraphsList(currentMonth: currentMonth),
    );
  }
}

class MonthController extends StatefulWidget {
  final DateTime currentMonth;
  final void Function() onLeftPressed;
  final void Function() onRightPressed;

  MonthController(this.currentMonth, {this.onLeftPressed, this.onRightPressed});

  @override
  _MonthControllerState createState() => _MonthControllerState();
}

class _MonthControllerState extends State<MonthController> with SingleTickerProviderStateMixin {
  static const String TAG = 'MonthController';
  AnimationController _monthTextAnimationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _monthTextAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    )..addListener(() => setState(() {}));

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _monthTextAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLeftButton(),
        _buildCurrentMonthText(),
        _buildRightButton(),
      ],
    ));
  }

  // Animation has bugs, removed for now
  Widget _buildLeftButton() {
    return IconButton(
      onPressed: () {
        widget.onLeftPressed();
        // _monthTextAnimationController.reverse();
      },
      icon: Icon(Icons.chevron_left),
    );
  }

  Widget _buildRightButton() {
    return IconButton(
      onPressed: () {
        widget.onRightPressed();
        // _monthTextAnimationController.forward();
      },
      icon: Icon(Icons.chevron_right),
    );
  }

  Widget _buildCurrentMonthText() {
    return Container(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Text(Utils.monthYearFromDateTime(widget.currentMonth)),
      ),
    );
  }

  @override
  void dispose() {
    _monthTextAnimationController.dispose();
    super.dispose();
  }
}

class GraphsList extends StatefulWidget {
  final DateTime currentMonth;
  GraphsList({@required this.currentMonth});

  @override
  _GraphsListState createState() => _GraphsListState();
}

class _GraphsListState extends State<GraphsList> {
  Expenditures expenditures;

  @override
  Widget build(BuildContext context) {
    expenditures = Provider.of<Expenditures>(context).where(
      (e) => e.month == widget.currentMonth.month && e.year == widget.currentMonth.year,
    );
    double graphHeight = 250;

    return expenditures.length >= 2
        ? Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TimeSeriesExpenditures(
                  graphHeight,
                  expenditures: expenditures,
                  currentMonth: widget.currentMonth,
                ),
              ],
            ),
          )
        : Container(
            // TODO: Create a vector here
            child: Text('Not enough data'),
          );
  }
}
