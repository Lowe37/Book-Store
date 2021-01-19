import 'package:bookstore/main.dart';
import 'package:bookstore/signInAndRegister/register.dart';
import 'package:bookstore/signInAndRegister/signIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  String error = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  //color palette
  Color color1 = Color(0xffDCDEDA);
  Color color2 = Color(0xff202B30);
  Color color3 = Color(0xffBD2F55);
  Color color4 = Color(0xffBE9159);

  resetPassword() {
    String email = emailController.text.trim();
    _auth.sendPasswordResetEmail(email: email);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("We send the detail to $email successfully.",
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green[300],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.2,
                  0.8,
                ],
                colors: [
                  /*Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.teal*/
                  color1,
                  color3,
                ])),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ป้อนอีเมล',
                  style: TextStyle(fontSize: 40, color: Colors.white, fontFamily: 'Iconic', fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: resetPassword,
                  child: Text('ตั้งรหัสผ่านใหม่', style: TextStyle(fontFamily: 'Iconic', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.greenAccent,
                ),
                RaisedButton(
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text('เข้าสู่ระบบ', style: TextStyle(fontFamily: 'Iconic', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.amberAccent,
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
