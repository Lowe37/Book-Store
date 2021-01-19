import 'package:bookstore/main.dart';
import 'package:bookstore/signInAndRegister/register.dart';
import 'package:bookstore/signInAndRegister/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    loginCheck(context);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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

  Future<User> signIn() async {
    final User user = await _auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((user) {
      //print("Signed in with ${user.email}");
      loginCheck(context); //
      loading = true; // add here
    }).catchError((error) {
      print(error.message);
      /*scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));*/
    });
  }

  //color palette
  Color color1 = Color(0xffDCDEDA);
  Color color2 = Color(0xff202B30);
  Color color3 = Color(0xffBD2F55);
  Color color4 = Color(0xffBE9159);

  //show/hide password
  bool _showHidePassword = true;

  void toggleShowHidePassword() {
    setState(() {
      _showHidePassword = !_showHidePassword;
    });
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
                  'Biology in Al qur aan',
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
                      labelText: 'รหัสผ่าน'
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: signIn,
                  child: Text('เข้าสู่ระบบ', style: TextStyle(fontFamily: 'Iconic', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.greenAccent,
                ),
                RaisedButton(
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text('สมัครสมาชิก', style: TextStyle(fontFamily: 'Iconic', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.amberAccent,
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ResetPassword()));
                  },
                  child: Text('ลืมรหัสผ่าน?', style: TextStyle(fontFamily: 'Iconic', decoration: TextDecoration.underline,fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
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
