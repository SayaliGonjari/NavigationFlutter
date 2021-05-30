import 'dart:convert';

import 'package:basic_demo/CollectionsDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ListView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    List<String> litems;
    final TextEditingController eCtrl = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(child: Container(
        child: FutureBuilder(
            future: RestAPICAll().getOpportunity(),
            builder: (BuildContext ctx,AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(child: Container(child: Center(child: CircularProgressIndicator())));
              }else if(snapshot.error != null){
                return Text("Error"+snapshot.error);
              }else{
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx,index) =>
                        Card(
                          child: Container(child: Column(children: <Widget>[
                            Text(
                              snapshot.data[index].toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],),),
                        ));
              }

            }),
      )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Sayali Gonjari"),
              accountEmail: Text("gonjari@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme
                    .of(context)
                    .platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(leading: Icon(Icons.work,color: Colors.orange,),title: Text(
                'Opportunity', style: TextStyle(color: Colors.orange)),
                onTap: () {
                  Navigator.pop(context);
                 /* widget.title = 'Opportunity';
                  Navigator.pushNamed(context, "/notifications");*/
                  //RestAPICAll().getOpportunity();

                    Navigator.push((context), MaterialPageRoute(builder:(context)=>DyanmicList()));
                }),
            Divider(height: 1, thickness: 1, color: Colors.blueGrey[900]),
            ListTile(leading:Icon(Icons.group_work,color: Colors.green,),title: Text(
                'Workspace', style: TextStyle(color: Colors.green)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CollectionDynamicList()));
                }),
            Divider(height: 1, thickness: 1, color: Colors.blueGrey[900]),
            ListTile(
                leading:Icon(Icons.group,color: Colors.red,),
                title: Text('Team', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                }),
            Divider(height: 1, thickness: 1, color: Colors.blueGrey[900]),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}

class RestAPICAll extends State {


  Future<List<User>> getOpportunity() async {
    var url = Uri.parse('https://vritti.ekatm.co.in/api/LoginAPI/GetEnvis');

    final response = await http.get(url);
    var responseData = json.decode(response.body);
    var responseList = json.decode(responseData);
    print(responseList);
    List<User> userList = [];
    for (int i = 0; i < responseList.length; i++) {
      User user = new User(
          responseList[i]["AppCode"],
          responseList[i]["Environment"],
          responseList[i]["AppEnvMasterId"],
          responseList[i]["IsChatApplicable"],
          responseList[i]["IsGPSLocation"]);
      userList.add(user);
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(title:Text('Opportunity',style: TextStyle(color: Colors.white),),),
  body: SingleChildScrollView(child: Container(
    child: FutureBuilder(
      future: RestAPICAll().getOpportunity(),
        builder: (BuildContext ctx,AsyncSnapshot snapshot){
        if(snapshot.data == null){
return Container(child: Container(child: Center(child: CircularProgressIndicator())));
        }else if(snapshot.error){
return Text("Error"+snapshot.error);
        }else{
return ListView.builder(
  scrollDirection: Axis.horizontal,
    itemCount: snapshot.data.length,
    itemBuilder: (ctx,index) =>
        Card(
          child: Container(),
        ));
        }

    }),
  )),
);
  }


}

class User {
  var appCode, environment, appEnvMasterId, IsChatApplicable, IsGPSLocation;

  User(this.appCode, this.environment, this.appEnvMasterId, this.IsChatApplicable, this.IsGPSLocation);


}
/*
class Routes {
  static const String contacts = ContactsPage.routeName;
  static const String events = EventsPage.routeName;
  static const String notes = NotesPage.routeName;
}*/


