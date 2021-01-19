import 'package:bookstore/addBook.dart';
import 'package:bookstore/signInAndRegister/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  PageController _pageController;


  @override
  void initState() {
    super.initState();
    retrieveEmail();
    inputData();
    retrieveBook();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    amountController.dispose();
  }

  String userEmail;
  void retrieveEmail() async {
    final User user = await _auth.currentUser;
    final uEmail = user.email;
    setState(() {
      userEmail = uEmail.toString();
      print(userEmail);
    });
    // here you write the codes to input the data into firestore
  }

  String userID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final User user = await auth.currentUser;
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
        ModalRoute.withName('/'));
  }

  void deleteList(docID) async {
    FirebaseFirestore.instance.collection('book')
        .doc(docID)
        .delete();
  }

  Future<void> _deleteDialogExpense(docID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลหนังสือ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                deleteList(docID);
                setState(() {
                });
                Navigator.of(context).pop();
                Flushbar(
                  icon: Icon(MdiIcons.checkCircle, color: Colors.red,),
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  message:  "ลบหนังสือสำเร็จ",
                  duration:  Duration(seconds: 3),
                )..show(context);
              },
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  List <Widget> bookList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Card(
        elevation:5,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(document['name']),
                  Spacer(),
                  Text(DateFormat("dd/MM/yyyy").format(document['date'].toDate())),
                ],
              ),
              Text(document['price']),
              Text(document['amount']),
              Row(
                children: [
                  Text(document['totalAmount']),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey,
                    ),
                    child: IconButton(
                      onPressed: (){
                        _deleteDialogExpense(document['id']);
                      },
                      icon: Icon(MdiIcons.pencil),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  int totalBookPrice;

  //double totPrice;
  double price;
  double amount;
  double totalAmount;
  String name;

  void retrieveBook (){
    //double total = 0.0;
    FirebaseFirestore.instance.collection("book").where('userID', isEqualTo: userID).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //print(result.id);
        name = result.data()['name'];
        print(name);
        price = double.parse(result.data()['price'].toString());
        print(price);
        amount = double.parse(result.data()['amount'].toString());
        print(amount);
        totalAmount = double.parse(result.data()['totalAmount'].toString());
        print(totalAmount);
        //total += newValuePrice;
        //print(result.data['profit']);
      });
      //totPrice = total;
    });
  }

  //book page
  BookPage(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text('ทั้งหมด: '+totalBookPrice.toString()+' บาท', style: TextStyle(fontSize: 18),),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('book').where('userID', isEqualTo: userID).snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.data == null) return CircularProgressIndicator();
                    return Column(
                      children: bookList(snapshot),
                    );
                  },
                ),
                RaisedButton(
                  onPressed: (){
                    retrieveBook();
                  },
                  child: Text('Test'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBook()));
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }

  //sale page
  SalePage(){

    var dateNow = new DateTime.now();
    var now_1w = dateNow.subtract(Duration(days: 7));
    var now_1m = new DateTime(dateNow.year, dateNow.month-1, dateNow.day);
    var now_1y = new DateTime(dateNow.year-1, dateNow.month, dateNow.day);
    print(now_1w);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        ],
      ),
    );
  }

  //setting page
  SettingsPage(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(userEmail?? 'No user'),
          FlatButton(
            onPressed: (){
              signOut(context);
            },
            child: Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        actions: <Widget> [
          IconButton(
            onPressed: (){

            },
            icon: Icon(MdiIcons.magnify),
            color: Colors.grey,
          ),
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(color: Colors.blueGrey,),
            BookPage(),
            SalePage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index){
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('หน้าหลัก'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
            title: Text('หนังสือ'),
            icon: Icon(Icons.book),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            title: Text('ยอดขาย'),
            icon: Icon(Icons.show_chart),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              title: Text('การตั้งค่า'),
              icon: Icon(Icons.settings),
            activeColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}
