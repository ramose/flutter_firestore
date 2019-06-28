import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController t1Controller = TextEditingController();
  TextEditingController t2Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Firestore.instance.collection('books').document().setData({ 'title': 'title', 'author': 'author' });
  }

  add() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: t1Controller,
                  decoration: InputDecoration(labelText: 'name'),
                ),
                TextField(
                  controller: t2Controller,
                  decoration: InputDecoration(labelText: 'genre'),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(child: Text('Batal'), onPressed: (){
                Navigator.of(context).pop();
              },),
              FlatButton(child: Text('Simpan'), onPressed: (){
                sendToFirestore(name: t1Controller.text, genre: t2Controller.text);
              },)
            ],
          );
        });
  }

  sendToFirestore({String name, String genre}) {
    // print('======> t1: ${t1Controller.text}');
    Firestore.instance.collection("bands").add({
      "band_name": name,
      "band_genre": genre
    }).then((val) {
      Navigator.of(context).pop();
      // val.get().then((doc) {
      //   AlertDialog dialog = new AlertDialog(
      //       title: new Text("Message Sent"),
      //       content: new Text("Your message has been sent!"),
      //       actions: <Widget>[
      //         new FlatButton(
      //           child: new Text('Regret'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ]);

      //   showDialog(context: context, builder: (context) {
      //     return dialog;
      //   });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('bands').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Firestore'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: add,
                )
              ],
            ),
            body: snapshot.hasError
                ? Center(child: Text('Error: ${snapshot.error}'))
                : snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: Text('Loading...'))
                    : ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return new ListTile(
                            title: new Text(document['band_name']),
                            subtitle: new Text(document['band_genre']),
                          );
                        }).toList(),
                      ),
          );
        });

    // },
    // );
  }
}
