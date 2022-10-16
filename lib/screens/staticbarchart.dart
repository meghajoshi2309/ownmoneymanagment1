import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/model/barchart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  final List<BarChartData> chartListdata;
  MyHomePage({Key? key, required this.chartListdata}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<BarChartData> data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bar Chart")),
      body: Center(
        child: Container(
          // child: Row(
          //   children: [
          // SizedBox(width: 20),
          child: SfCartesianChart(
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries>[
              ColumnSeries<BarChartData, String>(
                  yAxisName: "Income",
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  dataSource: widget.chartListdata,
                  xValueMapper: (BarChartData data, _) => data.x,
                  yValueMapper: (BarChartData data, _) => data.y),
              ColumnSeries<BarChartData, String>(
                  yAxisName: "Expance",
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  dataSource: widget.chartListdata,
                  xValueMapper: (BarChartData data, _) => data.x,
                  yValueMapper: (BarChartData data, _) => data.y1),
              ColumnSeries<BarChartData, String>(
                  yAxisName: "Total",
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  dataSource: widget.chartListdata,
                  xValueMapper: (BarChartData data, _) => data.x,
                  yValueMapper: (BarChartData data, _) => data.y2)
            ],
          ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
