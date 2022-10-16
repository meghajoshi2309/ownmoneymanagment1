// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/screens/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import './tansaction_model.dart';
import '../model/chart_model.dart';
import '../model/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:ownmoneymanagment1/model/user_model.dart';

class ChartScreen extends StatefulWidget {
  final List<ChartClassData> text;
  const ChartScreen({Key? key, required this.text}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  

  final List<GDPData> chartData = [ ];

  @override
  Widget build(BuildContext context) {
    print("Helllo");

    final cards = StreamBuilder(
      stream: FirebaseFirestore.instance.collection('transaction').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //docs refers to rows in table(collection)

        if (streamSnapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              if (documentSnapshot['uid'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return Container(
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['amount'].toString()),
                      subtitle: Text(documentSnapshot['transactiontype']),
                    ),
                  ),
                );
              } else {
                return SizedBox(height: 0);
              }
            },
          );
        }
        //print("documentSnapshot['uid'] == user!.uid55");
        return const SizedBox(height: 0);
      },
    );
    // final cards = StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('transaction').snapshots(),
    //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    //     //docs refers to rows in table(collection)
    //     print("has row or not");
    //     print(streamSnapshot.hasData);
    //     if (streamSnapshot.hasData) {
    //       print("i am at 1st if");
    //       ListView.builder(
    //         shrinkWrap: true,
    //         itemCount: streamSnapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           final DocumentSnapshot documentSnapshot =
    //               streamSnapshot.data!.docs[index];
    //           print("at before 2nd if");
    //           print(documentSnapshot['uid'] ==
    //               FirebaseAuth.instance.currentUser!.uid);
    //           if (documentSnapshot['uid'] ==
    //               FirebaseAuth.instance.currentUser!.uid) {
    //             // GDPData temp = new GDPData(
    //             //     documentSnapshot['category'].toString(),
    //             //     documentSnapshot['amount']);
    //             chartData.add(GDPData(documentSnapshot['category'].toString(),
    //                 documentSnapshot['amount']));
    //             print(documentSnapshot['category']);
    //             print(documentSnapshot['amount']);
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
    //     print("terminate");
    //     return const SizedBox(height: 0);
    //   },
    // );

    // final chart = SfCircularChart(
    //   legend:
    //       Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
    //   series: <CircularSeries>[
    //     PieSeries<GDPData, String>(
    //       dataSource: chartData,
    //       xValueMapper: (GDPData data, _) => data.continent,
    //       yValueMapper: (GDPData data, _) => data.gdp,
    //       dataLabelSettings: DataLabelSettings(isVisible: true),
    //     )
    //   ],
    // );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Own Money Managment")),
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

  Widget card(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('transaction').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //docs refers to rows in table(collection)
        print("dosd");
        print(FirebaseAuth.instance.currentUser!.uid);
        if (streamSnapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              print("dosd111");
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              if (documentSnapshot['uid'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return Container(
                  child: Card(
                    color: Colors.red,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['amount'].toString()),
                      subtitle: Text(documentSnapshot['transactiontype']),
                    ),
                  ),
                );
              } else {
                return Container(
                  child: const Card(
                    color: Colors.red,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('abc'),
                      subtitle: Text('xyz'),
                    ),
                  ),
                );
              }
            },
          );
        }
        //print("documentSnapshot['uid'] == user!.uid55");
        return const SizedBox(height: 0);
      },
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

  Widget chart(context) {
    return SfCircularChart(
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        PieSeries<GDPData, String>(
          dataSource: chartData,
          // dataSource: text,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        )
      ],
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
