import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/model/user_model.dart';
import './expence.dart';
import './income.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String SelectedvalueInYear = "Select Date";
  String SelectedvalueInPaymentMode = "Select payment mode ";
  String SelectedvalueInCategoryMode = "Select Category";

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  num? income = 0;
  num? expence = 0;
  num? total = 0;
  // income = 0;
  //we can accsess table(collection) transaction using _transaction instance
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');

  // Timer _timer = Timer(Duration(seconds: 200), () => print('done'));

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Welcome Message
    final welcomeMessage = Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        "Welcome ${loggedInUser.username}",
        style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),
      ),
    );

    //Filter For Year
    final yearfilter = DropdownButton(
      borderRadius: BorderRadius.circular(50),
      hint: SelectedvalueInYear == null
          ? Text("Select Date")
          : Text(SelectedvalueInYear),
      items: <String>['Date', 'Month', 'Year'].map((String value) {
        return DropdownMenuItem<String>(
          child: Text(
            value,
          ),
          value: value,
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInYear = newValue!;
        });
      },
    );

    // Filter For Payment Mode
    final paymentmodefilter = DropdownButton(
      borderRadius: BorderRadius.circular(50),
      hint: SelectedvalueInPaymentMode == null
          ? Text("Select Payment Mode")
          : Text(SelectedvalueInPaymentMode),
      items: <String>['Cash', 'online'].map((String value) {
        return DropdownMenuItem<String>(
          child: Text(
            value,
          ),
          value: value,
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInPaymentMode = newValue!;
        });
      },
    );

    // Filter For Category
    final categoryfilter = DropdownButton(
      borderRadius: BorderRadius.circular(50),
      // borderRadiuscolor: Colors.black ,
      hint: SelectedvalueInCategoryMode == null
          ? Text("Select Category")
          : Text(SelectedvalueInCategoryMode),
      // value: Selectedvalue,
      items: <String>['Food', 'Shopping'].map((String value) {
        return DropdownMenuItem<String>(
          child: Text(
            value,
          ),
          value: value,
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          SelectedvalueInCategoryMode = newValue!;
        });
      },
    );

    //netBalanceCard
    final netBalanceCard = Container(
      //giving 90% of all the width
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
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
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            Text(
              "Total Balance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              total.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardIncome(income.toString()),
                  cardExpence(expence.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final incomeExpanceCount = StreamBuilder(
      stream: _transaction.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //docs refers to rows in table(collection)
        print("streamSnapshot.hasData12345");
        print(streamSnapshot.hasData);
        if (streamSnapshot.hasData) {
          print("documentSnapshot['uid'] == user!.uid12");
          //Container(
          // child: Text("abc"),
          //child:
          print(streamSnapshot.data!.docs.length);
          print(context);
          ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              print("documentSnapshot['uid'] == user!.uid22");
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              print("documentSnapshot['uid'] == user!.uid");
              print(documentSnapshot['uid'] == user!.uid);
              if (documentSnapshot['uid'] == user!.uid) {
                if (documentSnapshot['transactiontype'] == 'Income') {
                  if (income != null) {
                    income = income! + documentSnapshot['amount'];
                  } else {
                    income = num.parse(documentSnapshot['amount']);
                  }
                }
                print('income....');
                // if (documentSnapshot['transactiontype'] == 'Expence') {
                //   print("Expence....");
                //   if (expence != null) {
                //     expence = expence! + documentSnapshot['amount'];
                //   } else {
                //     expence = num.parse(documentSnapshot['amount']);
                //   }
                // }
              }
              // if (total != null) {
              //   total = income! - expence!;
              // }
              print("documentSnapshot['uid'] == user!.uid44");
              return SizedBox(height: 0);
            },
            //),

            // return SizedBox(height: 0);
          );
        }
        print("documentSnapshot['uid'] == user!.uid55");
        return SizedBox(height: 0);
      },
    );

    final cards = StreamBuilder(
      stream: _transaction.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //docs refers to rows in table(collection)

        if (streamSnapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              if (documentSnapshot['uid'] == user!.uid) {
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
                  child: Card(
                    color: Colors.red,
                    margin: const EdgeInsets.all(10),
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
        print("documentSnapshot['uid'] == user!.uid55");
        return SizedBox(height: 0);
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Own Money Management")),
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
                  SizedBox(
                    height: 20,
                  ),
                  //incomeExpanceCount,
                  welcomeMessage,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        yearfilter,
                        SizedBox(width: 10),
                        categoryfilter,
                        SizedBox(width: 10),
                        paymentmodefilter,
                        // SizedBox(height: 500)
                      ],
                    ),
                  ),
                  netBalanceCard,
                  cards,
                  // FutureBuilder(
                  //   future: Future.delayed(Duration(milliseconds: 2000)),
                  //   builder: (context, snapshot) {
                  //     // Checks whether the future is resolved, ie the duration is over
                  //     if (snapshot.connectionState == ConnectionState.done)
                  //       return netBalanceCard;
                  //     else
                  //       return netBalanceCard; // Return empty container to avoid build errors
                  //   },
                  // ),

                  // FutureBuilder(
                  //   future: Future.delayed(Duration(milliseconds: 2000)),
                  //   builder: (context, snapshot) {
                  //     // Checks whether the future is resolved, ie the duration is over
                  //     if (snapshot.connectionState == ConnectionState.done)
                  //       return cards;
                  //     else
                  //       return cards; // Return empty container to avoid build errors
                  //   },
                  // ),
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
                    MaterialPageRoute(builder: (context) => AddIncome()),
                  );
                },
                label: Text("Cash In"),
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
                    MaterialPageRoute(builder: (context) => AddExpence()),
                  );
                },
                label: Text("Cash Out"),
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
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: TextStyle(
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
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expence",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: TextStyle(
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
