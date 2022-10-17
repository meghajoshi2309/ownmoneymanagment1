import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/model/user_model.dart';
import 'package:ownmoneymanagment1/screens/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class netBalance extends StatefulWidget {
  const netBalance({Key? key}) : super(key: key);

  @override
  State<netBalance> createState() => _netBalanceState();
}

class _netBalanceState extends State<netBalance> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var name;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        name = loggedInUser.username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _transaction =
        FirebaseFirestore.instance.collection('transaction');

    num expence = 10;
    num income = 10;
    num total = 10;
    int i = 0;

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Container(
              child: _textLiquidFillAnimation(),
            ),
            SizedBox(height: 10),
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText('Keep Track Of Your Transication With Us.',
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white)),
              ],
              onTap: () {
                print("I am executing");
              },
            ),
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
                          return SizedBox(height: 0);
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
                'Skip >>',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.purple,
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

  Widget _textLiquidFillAnimation() {
    return SizedBox(
      child: Center(
        child: TextLiquidFill(
          text: 'Hello ${loggedInUser.username}',
          waveDuration: Duration(seconds: 2),
          waveColor: Colors.purple,
          boxBackgroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
