// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ownmoneymanagment1/screens/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import './tansaction_model.dart';
import '../model/chart_model.dart';
import '../model/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:ownmoneymanagment1/model/user_model.dart';

class FilterScreen extends StatefulWidget {
  final List<TransactionModel> listof;
  final String selected;
  final String selectedType;
  const FilterScreen(
      {Key? key,
      required this.listof,
      required this.selected,
      required this.selectedType})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<TransactionModel> chartData = [];

  @override
  Widget build(BuildContext context) {
    chartData.clear();
    chartData.addAll(widget.listof);

    // Filter For PaymentMode
    if (widget.selectedType == "PaymentMode") {
      chartData.retainWhere((countryone) {
        if (countryone.paymentmode == widget.selected) {
          return true;
        }
        return false;
        //you can add another filter conditions too
      });
    }

    // Filter For Category
    if (widget.selectedType == "CategoryMode") {
      chartData.retainWhere((countryone) {
        if (countryone.category == widget.selected) {
          return true;
        }
        return false;
        //you can add another filter conditions too
      });
    }

    // Filter For Date
    if (widget.selectedType == "YearMode") {
      if (widget.selected == 'Current Date') {
        String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        print(cdate);
        chartData.retainWhere((countryone) {
          if (countryone.date == cdate) {
            return true;
          }
          return false;
          //you can add another filter conditions too
        });
      }

      if (widget.selected == 'Pervious Date') {
        DateTime pdate = DateTime.now().subtract(Duration(days: 1));
        String tempdate = DateFormat("yyyy-MM-dd").format(pdate);
        chartData.retainWhere((countryone) {
          if (countryone.date == tempdate) {
            return true;
          }
          return false;
          //you can add another filter conditions too
        });
      }

      if (widget.selected == 'Current Month') {
        String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        var dt = DateTime.now();
        var cmp = dt.month;
        print(cdate);
        chartData.retainWhere((countryone) {
          var temp1 = countryone.date;
          var tempdate = DateFormat("yyyy-MM-dd").parse(temp1!);
          if (tempdate.month == cmp) {
            return true;
          }
          return false;
          //you can add another filter conditions too
        });
      }

      if (widget.selected == 'Current Year') {
        String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        var dt = DateTime.now();
        var cmp = dt.year;
        print(cdate);
        chartData.retainWhere((countryone) {
          var temp1 = countryone.date;
          var tempdate = DateFormat("yyyy-MM-dd").parse(temp1!);
          if (tempdate.year == cmp) {
            return true;
          }
          return false;
          //you can add another filter conditions too
        });
      }
    }

    // Filter For Tranction Type
    if (widget.selectedType == "EntryTypeMode") {
      chartData.retainWhere((countryone) {
        if (countryone.transactiontype == widget.selected) {
          return true;
        }
        return false;
        //you can add another filter conditions too
      });
    }

    print(chartData);

    var listDiplay = ListView.builder(
        shrinkWrap: true,
        itemCount: chartData.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Container(
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text('${chartData[index].amount.toString()}'),
                subtitle: Text(chartData[index].date.toString()),
              ),
            ),
          );
        });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Own Money Managment")),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 30, 50, 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Own Money Managment" +
                      chartData.length.toString() +
                      " " +
                      widget.selected),
                  listDiplay
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
