import 'package:expenditure/constants.dart';
import 'package:expenditure/models/expenditures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

const String header = 'Payment Mode Distribution';

class PieChartModeDistribution extends StatelessWidget {
  final double graphHeight;
  final Expenditures expenditures;
  final DateTime currentMonth;

  PieChartModeDistribution(this.graphHeight, {this.expenditures, this.currentMonth});
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
              aspectRatio: 1.7,
              child: FlChartPieChart(expenditures, currentMonth),
            ),
          ),
        ),
      ],
    );
  }
}

class FlChartPieChart extends StatefulWidget {
  final Expenditures expenditures;
  final DateTime currentMonth;
  FlChartPieChart(this.expenditures, this.currentMonth);

  @override
  _FlChartPieChartState createState() => _FlChartPieChartState();
}

class _FlChartPieChartState extends State<FlChartPieChart> {
  static const String TAG = 'FlChartPieChart';

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(PieChartData(
              sections: _pieChartSections(),
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                setState(() {
                  final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent && pieTouchResponse.touchInput is! PointerUpEvent;
                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                    touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              }),
            )),
          ),
        ),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(PAYMENT_MODES.length, (index) {
            return Indicator(
              color: PAYMENT_MODES[index]['color'],
              text: PAYMENT_MODES[index]['name'],
            );
          }),
        ),
      ],
    );
  }

  List<PieChartSectionData> _pieChartSections() {
    double totalAmount = 0;

    Map<String, double> modeWiseAmount = {};

    PAYMENT_MODES.forEach((mode) {
      if (!modeWiseAmount.containsKey(mode['name'])) modeWiseAmount[mode['name']] = 0.0;

      Expenditures currentModeExpenditures = widget.expenditures.where(
        (e) => e.mode == mode['name'],
      );

      currentModeExpenditures.items.forEach((element) {
        modeWiseAmount[mode['name']] = modeWiseAmount[mode['name']] + element.amount.toDouble();
        totalAmount += element.amount.toDouble();
      });
    });

    debugPrint('[debug] $TAG, modeWiseAmount: $modeWiseAmount');

    return List.generate(PAYMENT_MODES.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final double value = (modeWiseAmount[PAYMENT_MODES[index]['name']] / totalAmount) * 100;
      return PieChartSectionData(
          color: PAYMENT_MODES[index]['color'],
          value: value,
          radius: radius,
          title: '${value.round()} %',
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ));
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final Color textColor;

  const Indicator({
    @required this.color,
    @required this.text,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
