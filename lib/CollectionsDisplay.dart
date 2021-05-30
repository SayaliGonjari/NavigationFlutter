import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectionDynamicList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionList();
  }

}

class _CollectionList extends State {

  List<CollectionBean> collectionList;

  Future<List<CollectionBean>> getCollections() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/albums/1");
    var res = await http.get(url);
    var responsedata = json.decode(res.body);
  //  var responseData = jsonDecode(res.body);
   // var resBody = json.decode(json.decode(res.body));

    for (var i in responsedata) {
      CollectionBean collectionBean = CollectionBean(
          userId: i["userId"],
          id: i["id"],
          title: i["title"]);
      collectionList.add(collectionBean);
    }
    return collectionList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Collections')),body:Center(
      child: FutureBuilder(
        future: getCollections(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical, itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  Container(child: Column(children: <Widget>[
                    Text(snapshot.data[index].userId.toString(),textAlign: TextAlign.left),
                    Text(snapshot.data[index].id.toString(),textAlign: TextAlign.left),
                    Text(snapshot.data[index].title.toString(),textAlign: TextAlign.left)

                  ],),);
                }
            );
          }
        },
      ),
    ),);

  }


}

class CollectionBean {
  var userId, id, title;

  CollectionBean({this.userId, this.id, this.title});
}