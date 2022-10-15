// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import './tansaction_model.dart';
import '../model/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:ownmoneymanagment1/model/user_model.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // User? user = FirebaseAuth.instance.currentUser;
  // final _auth = FirebaseAuth.instance;

  final List<GDPData> chartData = [
    GDPData('abc', 1200),
    GDPData('123', 1280),
    GDPData('424', 1270),
    GDPData('abc13', 1260),
    GDPData('abc33', 1200),
    GDPData('ab3', 100),
  ];

  // @override
  // void initState() {
  //   super.initState();
  // }

  // final cards = StreamBuilder(
  //   stream: FirebaseFirestore.instance.collection('transaction').snapshots(),
  //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
  //     //docs refers to rows in table(collection)
  //     if (streamSnapshot.hasData) {
  //       return ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: streamSnapshot.data!.docs.length,
  //         itemBuilder: (context, index) {
  //           final DocumentSnapshot documentSnapshot =
  //               streamSnapshot.data!.docs[index];
  //           if (documentSnapshot['uid'] ==
  //               FirebaseAuth.instance.currentUser!.uid) {
  //             GDPData temp = new GDPData(
  //                 documentSnapshot['category'].toString(),
  //                 documentSnapshot['amount']);
  //             chartData.add(temp);
  //             // return Container(
  //             //   child: Card(
  //             //     color: Colors.red,
  //             //     margin: const EdgeInsets.all(10),
  //             //     child: ListTile(
  //             //       title: Text(documentSnapshot['amount'].toString()),
  //             //       subtitle: Text(documentSnapshot['transactiontype']),
  //             //     ),
  //             //   ),
  //             // );
  //           } else {
  //             return SizedBox(
  //               height: 0,
  //             );
  //           }
  //           return SizedBox(
  //             height: 0,
  //           );
  //         },
  //       );
  //     }
  //     print("documentSnapshot['uid'] == user!.uid55");
  //     return const SizedBox(height: 0);
  //   },
  // );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCircularChart(
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
              PieSeries<GDPData, String>(
                dataSource: chartData,
                xValueMapper: (GDPData data, _) => data.continent,
                yValueMapper: (GDPData data, _) => data.gdp,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ]),
      ),
    );
  }

  // List<GDPData> getChartData() {
  //   final List<GDPData> chartData = [
  //     GDPData('abc', 1200),
  //     GDPData('123', 1280),
  //     GDPData('424', 1270),
  //     GDPData('abc13', 1260),
  //     GDPData('abc33', 1200),
  //     GDPData('ab3', 100),
  //   ];
  //   return chartData;
  // }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
