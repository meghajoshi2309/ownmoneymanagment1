import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownmoneymanagment1/model/transaction_model.dart';
import 'home.dart';

class AddIncome extends StatefulWidget {
  final num income;
  final num expence;
  final num total;
  const AddIncome(
      {Key? key,
      required this.income,
      required this.expence,
      required this.total})
      : super(key: key);

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController dateInputController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String SelectedvalueInCategory = "Select Category";
  String? paymode;

  @override
  void initState() {
    dateInputController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Amount filed
    final amountFiled = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.currency_rupee_sharp),
        hintText: 'Enter Your Income Amount',
        labelText: 'Amount',
      ),
      keyboardType: TextInputType.number,
      controller: amountController,
    );

    // Date file
    final dateFiled = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        hintText: 'Enter Date of Cash In',
        labelText: 'Date',
      ),
      controller: dateInputController,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          setState(() {
            dateInputController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );

    // Category Filed
    final categoryFiled = DropdownButton(
      borderRadius: BorderRadius.circular(5),
      // borderRadiuscolor: Colors.black ,
      hint: SelectedvalueInCategory == null
          ? const Text("Select Category")
          : Text(SelectedvalueInCategory),
      items:
          <String>['Salary', 'Invertment Income', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInCategory = newValue!;
        });
      },
    );

    // Redio Filed for Online option
    final payModeListItem1 = RadioListTile(
      title: const Text("Online"),
      value: "Online",
      groupValue: paymode,
      onChanged: (value) {
        setState(() {
          paymode = value.toString();
        });
      },
    );

    // Redio filed for cash option
    final payModeListItem2 = RadioListTile(
      title: const Text("Cash"),
      value: "Cash",
      groupValue: paymode,
      onChanged: (value) {
        setState(() {
          paymode = value.toString();
        });
      },
    );

    // final paymodeList = Row(
    //     children: [payModeListItem1, payModeListItem2],
    //     crossAxisAlignment: CrossAxisAlignment.start);

    // Submit Btn
    final submitBtnInIncome = Material(
      //for shado
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //this is for setting length of login button equal to the length of input field
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          SaveIncomeData(int.parse(amountController.text),
              dateInputController.text, SelectedvalueInCategory, paymode);

          // savetemp(paymode!);
        },
        child: const Text(
          "Save",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Own Money Management")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // child: Padding(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            // padding: const EdgeInsets.fromLTRB(36, 20, 0, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Add Cash In Entry",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  amountFiled,
                  const SizedBox(height: 10),
                  dateFiled,
                  const SizedBox(height: 10),
                  // SizedBox(width: 100),
                  categoryFiled,
                  const SizedBox(height: 20),
                  // paymodeList
                  const Text("Payment Mode : "),
                  payModeListItem1,
                  payModeListItem2,
                  const SizedBox(height: 20),
                  submitBtnInIncome,
                  const SizedBox(height: 250)
                ],
              ),
            ),
            // ),
          ),
        ),
      ),
    );
  }

  void SaveIncomeData(
      num amount, String date, String category, String? paymode) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var tid;
    var newincome = widget.income + amount;
    var newTotal = widget.total + amount;
    User? user = _auth.currentUser;
    TransactionModel transactionModel = TransactionModel();
    transactionModel.uid = user?.uid;
    Random random = Random();
    transactionModel.tid = (random.nextInt(3000)).toString();
    transactionModel.amount = amount;
    transactionModel.date = date;
    transactionModel.category = category;
    transactionModel.paymentmode = paymode;
    transactionModel.transactiontype = "Income";

    await firebaseFirestore
        .collection("transaction")
        .doc(transactionModel.tid)
        .set(transactionModel.toMap());
    Fluttertoast.showToast(msg: "Income Added Successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                income: newincome, expence: widget.expence, total: newTotal)),
        (route) => false);
  }
}
