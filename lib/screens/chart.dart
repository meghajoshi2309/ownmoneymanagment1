import 'package:flutter/material.dart';
import '../model/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  final List<ChartClassData> text;
  const ChartScreen({Key? key, required this.text}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Own Money Managment")),
        body: SfCircularChart(
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            PieSeries<ChartClassData, String>(
              // dataSource: chartData,
              dataSource: widget.text,
              xValueMapper: (ChartClassData data, _) => data.category,
              yValueMapper: (ChartClassData data, _) => data.amount,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
