import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/user_model.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // final _scaffoldkey = GlobalKey<ScaffoldState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _auth = FirebaseAuth.instance;
  var name;
  var email;

  final usernameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  bool _usernameValid = true;
  bool _emailValid = true;

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
        email = loggedInUser.email;
        usernameEditingController.text = name;
        emailEditingController.text = email;
        print(name);
        print(email);
      });
    });
  }

  updateProfileData() {
    setState(() {
      usernameEditingController.text.trim().length < 3 ||
              usernameEditingController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
      emailEditingController.text.trim().length < 10 ||
              emailEditingController.text.isEmpty
          ? _emailValid = false
          : _emailValid = true;
    });
    if (_emailValid && _usernameValid) {
      FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
        'username': usernameEditingController.text,
        'email': emailEditingController.text,
      });

      // var message;
      // FirebaseAuth.instance.currentUser
      //     .updateEmail(emailEditingController.text)
      //     .then(
      //       (value) => message = 'Success',
      //     )
      //     .catchError((onError) => message = 'error');

      // FirebaseAuth.instance.sendPasswordResetEmail(email: "user@example.com");
      // Future<void> updateEmail(String email1) async {
      //   // var firebaseUser = await user;
      //   user.updateEmail(email1);
      // }

      // FirebaseUser firebaseUser = FirebaseAuth.instance.currentUser();
      // firebaseUser.updateEmail(email);

      //SnackBar snackbar = SnackBar(content: Text("Profile Updated!"));
      //_scaffoldkey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("User Name Can Not Be Empty.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid User Name Of 3 Character.");
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: name,
        errorText: _usernameValid ? null : "Display Name Not Updated",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //email fild
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //Register Expression For Email Validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter Your Email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: email,
        errorText: _emailValid ? null : "Email Not Updated",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final updateProfileButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //this is for setting length of login button equal to the length of input field
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          updateProfileData();
        },
        child: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

    return Scaffold(
      // key: _scaffoldkey,
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profileimg.png'),
                  radius: 60,
                ),
              ),
              SizedBox(height: 20),
              emailField,
              SizedBox(height: 20),
              usernameField,
              SizedBox(height: 40),
              updateProfileButton,
            ],
          ),
        ),
      ),
    );
  }
}
