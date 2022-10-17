import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ownmoneymanagment1/screens/home.dart';
import '../model/transaction_model.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel model;
  final num income;
  final num expence;
  final num total;
  // final int model;
  // final String selected;
  // final String selectedType;
  const TransactionDetailsScreen(
      {Key? key,
      required this.model,
      required this.income,
      required this.expence,
      required this.total})
      : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final List<TransactionModel> chartData = [];

  num newincome = 0;
  num newtotal = 0;
  num newexpence = 0;
  deleteTransaction(String tid) {
    if (widget.model.transactiontype == 'Income') {
      newincome = widget.income - num.parse(widget.model.amount.toString());
      newtotal = widget.total - num.parse(widget.model.amount.toString());
      FirebaseFirestore.instance
          .collection('transaction')
          .doc(tid)
          .delete()
          .then(
            (doc) => Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        income: newincome,
                        expence: widget.expence,
                        total: newtotal)),
                (route) => false),
            onError: (e) => print("Error updating document $e"),
          );
    }
    if (widget.model.transactiontype == 'Expence') {
      newexpence = widget.expence - num.parse(widget.model.amount.toString());
      newtotal = widget.total + num.parse(widget.model.amount.toString());
      FirebaseFirestore.instance
          .collection('transaction')
          .doc(tid)
          .delete()
          .then(
            (doc) => Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        income: widget.income,
                        expence: newexpence,
                        total: newtotal)),
                (route) => false),
            onError: (e) => print("Error updating document $e"),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deletebtn = Material(
      //for shado
      // elevation: 5,
      // borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //this is for setting length of login button equal to the length of input field
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              // title: Text(''),
              content: Text('Are You Sure For Delete This Transaction?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () => deleteTransaction(
                    widget.model.tid.toString(),
                  ),
                ),
              ],
            ),
          );
          //deleteTransaction(widget.model.tid.toString());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.purple,
              size: 20.0,
            ),
            const Text(
              " Delete Transaction",
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
          ],
        ),
      ),
    );

    var card = Container(
      child: Card(
          color: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(
                color: Color.fromARGB(255, 188, 4, 4),
                thickness: 9,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              SizedBox(height: 10),
              // 1st Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: 12),
                      Text("Cash Out",
                          style: TextStyle(
                              color: Color.fromARGB(255, 115, 105, 105))),
                      const SizedBox(width: 130),
                      Text(
                        widget.model.date.toString(),
                      )
                      // const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              // 2nd row
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(width: 20),
                Text(widget.model.amount.toString(),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ]),
              SizedBox(height: 3),
              Divider(
                color: Color.fromARGB(255, 112, 111, 111),
                indent: 8,
                endIndent: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 12),
                  ListTile(
                    subtitle: Text("Category"),
                    title: Text('${widget.model.category.toString()}'),
                  ),
                  ListTile(
                    title: Text(widget.model.paymentmode.toString()),
                    subtitle: Text("Payment Mode"),
                  ),
                  // Text(
                  //     "    Tranction Type : ${widget.model.transactiontype}"),
                  // Text(
                  //     "    Payment Mode : ${widget.model.paymentmode}"),
                  Divider(
                    color: Color.fromARGB(255, 112, 111, 111),
                    indent: 8,
                    endIndent: 8,
                  ),
                  deletebtn
                ],
              )
            ],
          )),
    );

    if (widget.model.transactiontype == 'Income') {
      card = Container(
        child: Card(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(
                  color: Colors.green,
                  thickness: 9,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
                SizedBox(height: 10),

                // 1st Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(width: 12),
                        Text("Cash In",
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 105, 105))),
                        const SizedBox(width: 130),
                        Text(
                          widget.model.date.toString(),
                        )
                        // const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                // 2nd row
                SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(width: 20),
                  Text(widget.model.amount.toString(),
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
                SizedBox(height: 3),
                Divider(
                  color: Color.fromARGB(255, 112, 111, 111),
                  indent: 8,
                  endIndent: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12),
                    ListTile(
                      subtitle: Text("Category"),
                      title: Text('${widget.model.category.toString()}'),
                    ),
                    ListTile(
                      title: Text(widget.model.paymentmode.toString()),
                      subtitle: Text("Payment Mode"),
                    ),
                    // Text(
                    //     "    Tranction Type : ${widget.model.transactiontype}"),
                    // Text(
                    //     "    Payment Mode : ${widget.model.paymentmode}"),
                    Divider(
                      color: Color.fromARGB(255, 112, 111, 111),
                      indent: 8,
                      endIndent: 8,
                    ),
                    deletebtn
                  ],
                )
              ],
            )),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Transaction Details"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(50, 23, 50, 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 18),
                  card,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
