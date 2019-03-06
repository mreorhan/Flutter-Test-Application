import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import './button.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  timeDilation = 2.0;
  runApp(new MyApp());
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
      home: MyHomePage(title: 'Flutter Get Model'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = "Get device info";
  String model = "";
  String _ipAddress = "";
  List list = List();
  var isLoading = false;
  final url1 = Uri.https('httpbin.org', 'ip');
  final url2 = Uri.https('mighty-wildwood-18390.herokuapp.com', 'users');
  final httpClient = HttpClient();

  getPhoneDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String device = (prefs.getString('device') ?? "0");
    if (device == "0") {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        model = androidInfo.model;
      });
      await prefs.setString('device', device);
    } else {
      setState(() {
        model = device.toString();
      });
    }
  }

  _getIPAddress(url) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      list = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  void _showDialog(title, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title.toString()),
          content: new Text(content.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        //leading: new Container(), for hide
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$model'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            CustomCard(
              title: "Get IP",
              onPress: () {
                _getIPAddress(url2);
                _showDialog("Your IP", '${_ipAddress ?? "Empty"}');
              },
            ),
            CustomCard(
              title: "Fetch Api",
              onPress: () {
                _getIPAddress(url1);
                _showDialog("Your API", '${list.first.toString() ?? "Empty"}');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPhoneDetails,
        tooltip: 'Get Android Model',
        child: Icon(Icons.android),
      ),
      drawer: SizedBox(
          width: 180,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Home'),
                ),
                ListTile(
                  title: Text('Item1'),
                )
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black87),
              title: new Container(height: 0.0)), //For reset titles
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.black87),
              title: new Container(height: 0.0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: Colors.blue),
              title: new Container(height: 0.0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark, color: Colors.black87),
              title: new Container(height: 0.0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black87),
              title: new Container(height: 0.0))
        ],
      ),
    );
  }
}
