import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ownmoneymanagment1/model/user_model.dart';
import 'package:ownmoneymanagment1/screens/filterScreen.dart';
import 'package:ownmoneymanagment1/screens/login.dart';
import 'package:ownmoneymanagment1/screens/profile.dart';
import 'package:ownmoneymanagment1/screens/staticbarchart.dart';
import '../model/barchart_model.dart';
import '../model/chart_model.dart';
import '../model/transaction_model.dart';
import './expence.dart';
import './income.dart';
import './chart.dart';

class HomeScreen extends StatefulWidget {
  final num income;
  final num expence;
  final num total;
  const HomeScreen(
      {Key? key,
      required this.income,
      required this.expence,
      required this.total})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String SelectedvalueInYear = "Select Date";
  String SelectedvalueInPaymentMode = "Select Payment Mode ";
  String SelectedvalueInCategoryMode = "Select Category";
  String SelectedvalueIEMode = "Entry Type ";

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _auth = FirebaseAuth.instance;
  List<TransactionModel> listof = [];

  //we can accsess table(collection) transaction using _transaction instance
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');

  final List<ChartClassData> chartData = [];
  final List<ChartClassData> chartDataForIncome = [];
  List<BarChartData> BarchartData = <BarChartData>[
    BarChartData('Today', 0, 0, 0),
    BarChartData('Pervios Day', 0, 0, 0),
    BarChartData('2 Day Ago', 0, 0, 0),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var cards;

    // For Comapare date so define date
    String currentdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    DateTime previousdateindate = DateTime.now().subtract(Duration(days: 1));
    String previousdate = DateFormat("yyyy-MM-dd").format(previousdateindate);
    DateTime twosagodateindate = DateTime.now().subtract(Duration(days: 2));
    String twosagodate = DateFormat("yyyy-MM-dd").format(twosagodateindate);

    //Welcome Message
    // final welcomeMessage = Padding(
    //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
    //   child: Text(
    //     "Welcome ${loggedInUser.username}",
    //     style:
    //         const TextStyle(fontSize: 15, decoration: TextDecoration.underline),
    //   ),
    // );

    //Filter For Year
    final yearfilter = DropdownButton(
      // borderRadius: BorderRadius.circular(50),
      // style: TextStyle(fontSize: 18),
      hint: SelectedvalueInYear == null
          ? const Text("Select Date")
          : Text(SelectedvalueInYear),
      items: <String>[
        'Current Date',
        'Current Month',
        'Current Year',
        'Pervious Date'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInYear = newValue!;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                    listof: listof,
                    selected: SelectedvalueInYear,
                    selectedType: "YearMode")),
          );
        });
      },
    );

    // Filter For Payment Mode
    final paymentmodefilter = DropdownButton(
      // borderRadius: BorderRadius.circular(50),
      // style: TextStyle(fontSize: 18),
      hint: SelectedvalueInPaymentMode == null
          ? const Text("Select Payment Mode")
          : Text(SelectedvalueInPaymentMode),
      items: <String>['Cash', 'Online'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInPaymentMode = newValue!;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                    listof: listof,
                    selected: SelectedvalueInPaymentMode,
                    selectedType: 'PaymentMode')),
          );
        });
      },
    );

    // Filter For Category
    final categoryfilter = DropdownButton(
      // borderRadius: BorderRadius.circular(50),
      // borderRadiuscolor: Colors.black ,
      // style: TextStyle(fontSize: 18),
      hint: SelectedvalueInCategoryMode == null
          ? const Text("Select Category")
          : Text(SelectedvalueInCategoryMode),
      // value: Selectedvalue,
      items: <String>[
        'Food',
        'Vehical',
        'Shopping',
        'Clothes',
        'Kids',
        'Gifts',
        'Fuel',
        'Holidays',
        'Travel',
        'General',
        'Entertainment',
        'Sports',
        'Salary',
        'Invertment Income'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInCategoryMode = newValue!;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                    listof: listof,
                    selected: SelectedvalueInCategoryMode,
                    selectedType: "CategoryMode")),
          );
        });
      },
    );

    // Filter For Income AND Expance
    final IEmodefilter = DropdownButton(
      // borderRadius: BorderRadius.circular(50),
      // style: TextStyle(fontSize: 18),
      hint: SelectedvalueIEMode == null
          ? const Text("Entry Type")
          : Text(SelectedvalueIEMode),
      items: <String>['Income', 'Expence'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueIEMode = newValue!;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterScreen(
                    listof: listof,
                    selected: SelectedvalueIEMode,
                    selectedType: 'EntryTypeMode')),
          );
        });
      },
    );

    //netBalanceCard
    final netBalanceCard = Container(
      //giving 90% of all the width
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.all(12.0),
      child: Container(
        decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 207, 121, 222),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 190, 80, 209),
              Color.fromARGB(255, 95, 2, 111),
            ],
          ),
          borderRadius: BorderRadius.all(
            //elevation: 12,
            Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            const Text(
              "Total Balance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.total.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardIncome(widget.income.toString()),
                  cardExpence(widget.expence.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    cards = StreamBuilder(
      stream: _transaction.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //docs refers to rows in table(collection)
        chartData.clear();
        listof.clear();
        chartDataForIncome.clear();
        BarchartData = <BarChartData>[
          BarChartData('Today', 0, 0, 0),
          BarChartData('Pervios Day', 0, 0, 0),
          BarChartData('2 Day Ago', 0, 0, 0),
        ];
        print("at cards main...");
        if (streamSnapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              if (documentSnapshot['uid'] == user!.uid) {
                //Adding Data in chartData List For Making Chart Of Expence In Chart.dart
                if (documentSnapshot['transactiontype'] == 'Expence') {
                  var flag = 0;
                  for (int i = 0; i < chartData.length; i++) {
                    if (chartData[i].category == documentSnapshot['category']) {
                      flag = 1;
                      int temp = chartData[i].amount;
                      temp += int.parse(documentSnapshot['amount'].toString());
                      chartData.removeAt(i);
                      chartData.insert(
                        i,
                        ChartClassData(
                            documentSnapshot['category'].toString(), temp),
                      );
                    }
                  }
                  if (flag == 0) {
                    chartData.add(ChartClassData(
                        documentSnapshot['category'].toString(),
                        documentSnapshot['amount']));
                  }
                }

                if (documentSnapshot['transactiontype'] == 'Income') {
                  var flag = 0;
                  for (int i = 0; i < chartDataForIncome.length; i++) {
                    if (chartDataForIncome[i].category ==
                        documentSnapshot['category']) {
                      flag = 1;
                      int temp = chartDataForIncome[i].amount;
                      temp += int.parse(documentSnapshot['amount'].toString());
                      chartDataForIncome.removeAt(i);
                      chartDataForIncome.insert(
                        i,
                        ChartClassData(
                            documentSnapshot['category'].toString(), temp),
                      );
                    }
                  }
                  if (flag == 0) {
                    chartDataForIncome.add(ChartClassData(
                        documentSnapshot['category'].toString(),
                        documentSnapshot['amount']));
                  }
                }

                if (documentSnapshot['date'] == currentdate) {
                  if (documentSnapshot['transactiontype'] == 'Income') {
                    int temp = BarchartData[0].y ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y = temp;

                    int tempoftotal = BarchartData[0].y2 ?? 0;
                    tempoftotal +=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y2 = tempoftotal;
                  }

                  if (documentSnapshot['transactiontype'] == 'Expence') {
                    int temp = BarchartData[0].y1 ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y1 = temp;

                    int tempoftotal = BarchartData[0].y2 ?? 0;
                    tempoftotal -=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y2 = tempoftotal;
                  }
                }

                if (documentSnapshot['date'] == previousdate) {
                  if (documentSnapshot['transactiontype'] == 'Income') {
                    int temp = BarchartData[0].y ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y = temp;

                    int tempoftotal = BarchartData[0].y2 ?? 0;
                    tempoftotal +=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y2 = tempoftotal;
                  }

                  if (documentSnapshot['transactiontype'] == 'Expence') {
                    int temp = BarchartData[1].y1 ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[1].y1 = temp;

                    int tempoftotal = BarchartData[1].y2 ?? 0;
                    tempoftotal -=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[1].y2 = tempoftotal;
                  }
                }

                if (documentSnapshot['date'] == twosagodate) {
                  if (documentSnapshot['transactiontype'] == 'Income') {
                    int temp = BarchartData[2].y ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[2].y = temp;

                    int tempoftotal = BarchartData[2].y2 ?? 0;
                    tempoftotal +=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[2].y2 = tempoftotal;
                  }

                  if (documentSnapshot['transactiontype'] == 'Expence') {
                    int temp = BarchartData[0].y1 ?? 0;
                    temp += int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y1 = temp;

                    int tempoftotal = BarchartData[0].y2 ?? 0;
                    tempoftotal -=
                        int.parse(documentSnapshot['amount'].toString());
                    BarchartData[0].y2 = tempoftotal;
                  }
                }

                TransactionModel temp = TransactionModel(
                    uid: user!.uid,
                    tid: documentSnapshot['tid'],
                    amount: documentSnapshot['amount'],
                    date: documentSnapshot['date'],
                    category: documentSnapshot['category'],
                    paymentmode: documentSnapshot['paymentmode'],
                    transactiontype: documentSnapshot['transactiontype']);
                listof.add(temp);

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
                                child: Text(
                                    documentSnapshot['category'].toString(),
                                    style: TextStyle(fontSize: 16)),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: Text(
                                    documentSnapshot['amount'].toString(),
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
                                  "Tranction Type : ${documentSnapshot['transactiontype']}"),
                              Text(
                                  "Payment Mode : ${documentSnapshot['paymentmode']}"),
                              Divider(
                                color: Color.fromARGB(255, 201, 201, 201),
                              ),
                              Text(documentSnapshot['date'].toString(),
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 115, 105, 105))),
                            ],
                          )
                        ],
                      )),
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

    void SelectedItem(BuildContext context, item) {
      switch (item) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProfile()),
          );
          break;
        case 1:
          // print("Privacy Clicked");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChartScreen(text: chartData, title: "Expance")),
          );
          break;
        case 2:
          _auth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          break;

        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChartScreen(text: chartDataForIncome, title: "Income")),
          );
          break;

        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(chartListdata: BarchartData)),
          );
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Own Money Management"),
        actions: [
          //list if widget in appbar actions
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Profile"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Expence Chart"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("Income Chart"),
              ),
              const PopupMenuItem<int>(
                value: 4,
                child: Text("Bar Chart"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text("Logout")
                  ],
                ),
              ),
            ],
            onSelected: (item) => {SelectedItem(context, item)},
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 0,
                  ),
                  //incomeExpanceCount,
                  // welcomeMessage,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        yearfilter,
                        const SizedBox(width: 10),
                        IEmodefilter,
                        const SizedBox(width: 10),
                        paymentmodefilter,
                        const SizedBox(width: 10),
                        categoryfilter,
                        // SizedBox(height: 500)
                      ],
                    ),
                  ),
                  // netBalanceCard,
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        netBalanceCard,
                        cards,
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // The bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        //color: Color.fromARGB(255, 235, 224, 227),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150.0,
              height: 40.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddIncome(
                            income: widget.income,
                            expence: widget.expence,
                            total: widget.total)),
                  );
                },
                label: const Text("Cash In"),
                icon: const Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                ),
              ),
            ),
            SizedBox(
              width: 150.0,
              height: 40.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddExpence(
                            income: widget.income,
                            expence: widget.expence,
                            total: widget.total)),
                  );
                },
                label: const Text("Cash Out"),
                icon: const Icon(Icons.remove),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[700]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpence(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expence",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
