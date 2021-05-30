
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DyanmicList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DyanmicList();
  }

}

class _DyanmicList extends State {
  List<String> litems ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

 

  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    Future<List<User>> getRequest() async {

      var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

      final response = await http.get(url);

      var responseData = json.decode(response.body);

      List<User> users = [];

      for (var singleUser in responseData) {
        User user = User(
            id: singleUser["id"],
            userId: singleUser["userId"],
            title: singleUser["title"],
            body: singleUser["body"]);

        //Adding user to the list.
        users.add(user);
      }

      return users;
    }
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Opportunity"),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }/*else if(snapshot.error){
                return Container();
              }*/else {
                return ListView.builder(

                    scrollDirection: Axis.vertical,//For Horizontal List
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) => Card(
                      child: Container(
                        child: Column(
                          children: [
                            Text(snapshot.data[index].id.toString()),
                            SizedBox(height: 10,),
                            Text(snapshot.data[index].title),
                            SizedBox(height: 10,),
                            Text(snapshot.data[index].body,style: TextStyle(color:index%2==0?Colors.blue:Colors.blueGrey,),),
                          ],
                        ),
                      ),
                      color: index%2==0?Colors.lightBlue[50]:Colors.grey[50],
                    )
                  /*ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].body),
                    contentPadding: EdgeInsets.only(bottom: 20.0),
                  ),*/
                );
              }
            },
          ),
        ),
      ),
    );
  }

}

class User {
  final int id;
  final int userId;
  final String title;
  final String body;

  User({
    this.id,
    this.userId,
    this.title,
    this.body,
  });

}