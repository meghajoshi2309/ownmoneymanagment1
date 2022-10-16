import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/screens/home.dart';

class netBalance extends StatefulWidget {
  const netBalance({Key? key}) : super(key: key);

  @override
  State<netBalance> createState() => _netBalanceState();
}

class _netBalanceState extends State<netBalance> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _transaction =
        FirebaseFirestore.instance.collection('transaction');

    User? user = FirebaseAuth.instance.currentUser;

    num expence = 10;
    num income = 10;
    num total = 10;
    int i = 0;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: _transaction.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                //docs refers to rows in table(collection)
                total = 0;
                income = 0;
                expence = 0;
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        i++;
                        if (documentSnapshot['uid'] == user!.uid) {
                          //Adding Data in chartData List For Making Chart Of Expence In Chart.dart
                          if (documentSnapshot['transactiontype'] ==
                              'Expence') {
                            if (expence != null) {
                              expence = expence + documentSnapshot['amount'];
                            } else {
                              expence = num.parse(documentSnapshot['amount']);
                            }
                          }
                          if (documentSnapshot['transactiontype'] == 'Income') {
                            if (income != null) {
                              income = income + documentSnapshot['amount'];
                            } else {
                              income = num.parse(documentSnapshot['amount']);
                            }
                          }
                          if (total != null) {
                            total = income - expence;
                          }

                          return Container(
                            child: Card(
                              color: Colors.white,
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title:
                                    Text(documentSnapshot['amount'].toString()),
                                subtitle: Text(total.toString()),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(height: 0);
                        }
                      });
                }
                return const SizedBox(height: 0);
              },
            ),
            FlatButton(
              child: Text(
                'LogIn',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        income: income, expence: expence, total: total)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
