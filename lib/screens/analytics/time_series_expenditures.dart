import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/utils.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';

class TimeSeriesExpenditures extends StatelessWidget {
  TimeSeriesExpenditures(
    this.graphHeight, {
    this.expenditures,
    this.currentMonth,
  });

  final Expenditures expenditures;
  final double graphHeight;
  final DateTime currentMonth;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3),
        ),
        child: ConstrainedBox(
          child: FlChartLineChart(expenditures, currentMonth),
          constraints: BoxConstraints(maxHeight: graphHeight),
        ),
      ),
    );
  }
}

class FlChartLineChart extends StatelessWidget {
  final Expenditures expenditures;
  final DateTime currentMonth;
  FlChartLineChart(this.expenditures, this.currentMonth);

  @override
  Widget build(BuildContext context) {
    double _maxAmount = expenditures.maxAmount;
    double _minAmount = expenditures.minAmount;

    double maxY = _maxAmount + _minAmount;
    double maxX = DateTime(currentMonth.year, currentMonth.month + 1, 0).day.toDouble();
    double intervalY = maxY / 5;
    return LineChart(
      LineChartData(
          minY: 0,
          maxY: maxY,
          minX: 1,
          maxX: maxX,
          // backgroundColor: Colors.purple,
          gridData: FlGridData(
            show: true,
            horizontalInterval: intervalY,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              interval: 7,
              getTitles: (value) => Utils.dayMonthFromDateTime(
                currentMonth,
              ),
              margin: 10,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) => NumberFormat.compactSimpleCurrency(
                locale: Intl.defaultLocale,
                decimalDigits: 1,
              ).format(value),
              margin: 10,
              interval: _maxAmount / 4,
              reservedSize: 30,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _spots(expenditures),
              dotData: FlDotData(show: true),
              isCurved: true,
              gradientFrom: Offset(0.5, 0.5),
              gradientTo: Offset(1, 1),
            ),
          ]),
      // swapAnimationDuration: Duration(seconds: 5),
    );
  }

  List<FlSpot> _spots(Expenditures expenditures) {
    List<FlSpot> spots = [];
    for (Expenditure e in expenditures.items) {
      FlSpot spot = FlSpot(
        e.timestamp.toDate().day.toDouble(),
        e.amount.toDouble(),
      );
      spots.add(spot);
    }
    return spots;
  }
}

class GoogleChartsTimeSeries extends StatelessWidget {
  final Expenditures expenditures;
  final bool animate;

  GoogleChartsTimeSeries(this.expenditures, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<Expenditure, DateTime>(
          id: 'Expenditures',
          displayName: 'Timeseries of your expenditures',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFormatterFn: (Expenditure expenditure, _) => Utils.formatDateTime,
          domainFn: (Expenditure expenditure, _) => expenditure.timestamp.toDate(),
          measureFormatterFn: (Expenditure expenditure, _) => _amountFormatter,
          measureFn: (Expenditure expenditure, _) => expenditure.amount.toDouble(),
          labelAccessorFn: (Expenditure expenditure, _) => expenditure.amount.toString(),
          data: expenditures.items,
        ),
      ],
      animate: animate,
    );
  }

  String _amountFormatter(num n) {
    return Utils.formatCurrency(n.toDouble(), Intl.defaultLocale);
  }
}
