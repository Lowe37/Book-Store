import 'package:bookstore/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    amountController.dispose();
  }

  DateTime _date = new DateTime.now();
  String name;
  double totalPrice;

  void addBook() async {

    double amount = double.parse(amountController.text);
    double price = double.parse(priceController.text);
    totalPrice = price*amount;

    FirebaseFirestore.instance.collection('book').add({
      'userID' : userID,
      'name': nameController.text,
      'price' : priceController.text,
      'amount' : amountController.text,
      'date' : _date,
      'totalAmount' : totalPrice.toString(),

    }).then((value){
      print(value.id);
      FirebaseFirestore.instance.collection('book').doc(value.id).update({
        'id' : value.id,
      });
    });
  }

  String userID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มหนังสือ'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ชื่อหนังสือ', style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    hintText: 'ชื่อ'
                ),
              ),
              SizedBox(height: 20,),
              Text('ราคา', style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    hintText: '0'
                ),
              ),
              SizedBox(height: 20,),
              Text('จำนวน', style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    hintText: '0'
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Spacer(),
                  SizedBox(width: 10,),
                  RaisedButton(
                    onPressed: (){
                      addBook();
                      Flushbar(
                        icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                        margin: EdgeInsets.all(8),
                        borderRadius: 8,
                        message:  "เพิ่มหนังสือสำเร็จ",
                        duration:  Duration(seconds: 3),
                      )..show(context);
                      /*Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyHomePage()));*/
                    },
                    child: Text('ยืนยัน', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
