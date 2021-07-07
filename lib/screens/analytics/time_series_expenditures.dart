import 'dart:math';

import 'package:expenditure/models/expenditure_item.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:expenditure/utils.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';

const String header = 'Time Series of Expenditures';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            header,
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(height: 8),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3),
            ),
            child: AspectRatio(
              aspectRatio: 2,
              child: FlChartLineChart(expenditures, currentMonth),
            ),
          ),
        ),
      ],
    );
  }
}

class FlChartLineChart extends StatelessWidget {
  static const String TAG = 'FlChartLineChart';

  final Expenditures expenditures;
  final DateTime currentMonth;
  FlChartLineChart(this.expenditures, this.currentMonth);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = _spots(expenditures);

    double _minAmount = double.infinity;
    double _maxAmount = double.negativeInfinity;

    spots.forEach((e) {
      _minAmount = min(_minAmount, e.y);
      _maxAmount = max(_maxAmount, e.y);
    });

    double maxY = _minAmount + _maxAmount;
    double maxX = DateTime(currentMonth.year, currentMonth.month + 1, 0).day.toDouble();
    debugPrint('[debug] $TAG, maxX: $maxX, maxY: $maxY');
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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                // maxContentWidth: 100,
                getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final textStyle = TextStyle(
                  color: touchedSpot.bar.colors[0],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                return LineTooltipItem(
                  '${_getDateString(touchedSpot.x)}, ${_getAmountString(touchedSpot.y)}',
                  textStyle,
                );
              }).toList();
            }),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              interval: 7,
              getTitles: (value) => _getDateString(value),
              margin: 10,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) => _getAmountString(value),
              margin: 10,
              interval: _maxAmount / 4,
              reservedSize: 30,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              dotData: FlDotData(show: true),
              isCurved: true,
              gradientFrom: Offset(0.5, 0.5),
              gradientTo: Offset(1, 1),
            ),
          ]),
      // swapAnimationDuration: Duration(seconds: 5),
    );
  }

  String _getDateString(double x) {
    return Utils.dayMonthFromDateTime(
      DateTime(currentMonth.year, currentMonth.month, x.toInt()),
    );
  }

  String _getAmountString(double y) {
    return NumberFormat.compactSimpleCurrency(
      locale: Intl.defaultLocale,
      decimalDigits: 1,
    ).format(y);
  }

  List<FlSpot> _spots(Expenditures expenditures) {
    List<FlSpot> spots = [];
    for (int i = 0; i < expenditures.length; i++) {
      Expenditure e = expenditures[i];
      double amountForTheDay = e.amount.value;

      // Added amount of expenditures for that day
      // Expenditures are always sorted by timestamp
      while (i < expenditures.length - 1 && expenditures[i].timestamp.toDate().day <= expenditures[i + 1].timestamp.toDate().day) {
        amountForTheDay += expenditures[i + 1].amount.value;
        i++;
      }

      FlSpot spot = FlSpot(
        e.timestamp.toDate().day.toDouble(),
        amountForTheDay,
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
