import 'dart:async';
import 'package:answer/Ans.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import "dart:math";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getList() async {
    return await http
        .get(Uri.parse(
            "https://script.googleusercontent.com/macros/echo?user_content_key=qDVC_C3MJOK55q9cUWVmL94b_altbG6DKrLNeYh3yac2g1ahBkWOuzeXNkZOaTYw9gDGXemZuavASoP3rvpcctj1seAfWojjm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPfRUPWAAkj90fLU3KrG_TUW2fzbI-axWbLvgHFcyBgjc8GUWQimwzwlxmO7Lz_lSLKiOWDAmIl1ocI-_B-2LBTYcO6QfBAKw9z9Jw9Md8uu&lib=MW3Wq-EdSSCkAr0pHnecDwDOXfJvouzTu"))
        .then((response) {
      // print(convert.jsonDecode(response.body));
      // return response.body.toString();
      if (response.statusCode == 200) {
        var jsonans = convert.jsonDecode(response.body) as List;
        return jsonans.map((json) => Answer.fromJson(json)).toList();
      } else {
        getList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getList().then((answ) {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SecondScreen(
                      answerslist: answ,
                    )));
      });
    });
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Image.asset(
          'assets/images/LOGO.jpg',
          height: 150,
          width: 150,
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key, required this.answerslist}) : super(key: key);
  final List<Answer> answerslist;
  @override
  _SecondScreenState createState() => _SecondScreenState(answ: answerslist);
}

class _SecondScreenState extends State<SecondScreen> {
  _SecondScreenState({required this.answ});
  String randomAnsw = " ";
  List<String> str = ["YES", "NO"];
  List<Answer> answ;
  var element, el;

  final _random = new Random();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    element = answ[_random.nextInt(answ.length)];
    setState(() {
      randomAnsw = element.ans!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Answer"),
      ),
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Answers"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                element = answ[_random.nextInt(answ.length)];
                Navigator.pop(context);
                setState(() {
                  randomAnsw = element.ans!;
                });
              },
            ),
            ListTile(
              title: Text("YES/NO"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                el = str[_random.nextInt(str.length)];
                Navigator.pop(context);
                setState(() {
                  randomAnsw = el;
                });
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          randomAnsw,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
