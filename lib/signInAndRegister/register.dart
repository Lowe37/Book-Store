import 'package:bookstore/main.dart';
import 'package:bookstore/signInAndRegister/signIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
    loginCheck(context);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future loginCheck(BuildContext context) async {
    User user = await _auth.currentUser;
    if (user != null) {
      print("Already singed-in with " + user.email);
      /*Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CustomDrawer(user)));*/
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => receiveUserInfo(user)));
    }*/
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  bool _showHidePassword = true;

  void toggleShowHidePassword() {
    setState(() {
      _showHidePassword = !_showHidePassword;
    });
  }

  signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (password == confirmPassword && password.length >= 6) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print("Sign up user successful.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      }).catchError((error) {
        print(error.message);
      });
    } else {
      print("Password and Confirm-password is not match.");
    }
  }

  //color palette
  Color color1 = Color(0xffDCDEDA);
  Color color2 = Color(0xff202B30);
  Color color3 = Color(0xffBD2F55);
  Color color4 = Color(0xffBE9159);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
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
                    'สมัครสมาชิก',
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
                  TextFormField(
                    controller: passwordController,
                    validator: (val) => val.length < 6 ? 'Enter a password with more than 6 characters' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    obscureText: _showHidePassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _showHidePassword = !_showHidePassword;
                            });
                          },
                          icon: Icon(
                            _showHidePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        labelText: 'รหัสผ่าน'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (val) => val.length < 6 ? 'Enter a password with more than 6 characters' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    obscureText: _showHidePassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _showHidePassword = !_showHidePassword;
                            });
                          },
                          icon: Icon(
                            _showHidePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        labelText: 'ยืนยันรหัสผ่าน'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: (){
                      signUp();
                    },
                    child: Text('ยืนยัน', style: TextStyle(fontFamily: 'Iconic', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
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
      ),
    );
  }
}
