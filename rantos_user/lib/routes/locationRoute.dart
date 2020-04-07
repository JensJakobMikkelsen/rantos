import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rantos_user/models/dragRoute.dart';
import 'package:rantos_user/models/login_screen.dart';
import 'package:rantos_user/models/usageRoute.dart';
import 'package:rantos_user/models/user.dart';
class pushArguments
{
  String title = "abe";
  String message = "abe2";

  pushArguments(this.title, this.message);
}

class locationRoute extends StatelessWidget {
  @override
  var images = ['images/panda.jpg', 'images/panda.jpg', 'images/panda.jpg', 'images/panda.jpg' ,'images/panda.jpg'];


  var id = ["title 1", "title 2", "title 3", "title 4", "title 5",];
  void enterVenue(BuildContext context, id) {
    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>dragRoute()));
    /*
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Sending Message:" + id.toString()),
    ));
*/
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
          itemCount: id == null ? 0 : id.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector( //You need to make my child interactive
              onTap: () => enterVenue(context, index),
              child: new Card( //I am the clickable child
                child: new Column(
                  children: <Widget>[
                    //new Image.network(video[index]),
                    new Padding(padding: new EdgeInsets.all(3.0)),
                    new Text(id[index],
                      style: new TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    //new Image.network('https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60')
                    new Image.asset(images[index]),


                  ],
                ),),
            );
          }),
    );
  }
}


  /*
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );

  }
  */



