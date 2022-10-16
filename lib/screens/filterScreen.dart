// ignore: file_names

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../model/transaction_model.dart';

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

    var listDiplay;

    listDiplay = ListView.builder(
        shrinkWrap: true,
        itemCount: chartData.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Container(
            child: Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          child: Text(chartData[index].category.toString(),
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: Text(chartData[index].amount.toString(),
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {/* ... */},
                        ),
                        // const SizedBox(width: 8),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 5, 4),
                        ),
                        Text(
                            "Tranction Type : ${chartData[index].transactiontype}"),
                        Text("Payment Mode : ${chartData[index].paymentmode}"),
                        Divider(
                          color: Color.fromARGB(255, 201, 201, 201),
                        ),
                        Text(chartData[index].date.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 105, 105))),
                      ],
                    )
                  ],
                )),
          );
        });

    if (chartData.length == 0) {
      listDiplay = Container(
        child: Column(
          children: const [
            Text("There is not any Transication",
                style: TextStyle(color: Colors.red, fontSize: 20)),
          ],
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Filter Transication")),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 23, 50, 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Filter By " + widget.selected,
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: 18),
                  listDiplay,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
