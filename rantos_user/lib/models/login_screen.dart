import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rantos_user/dao/TableDao.dart';
import 'package:rantos_user/models/jsonlisttest.dart';
import '../database.dart';
import 'package:rantos_user/models/zerkertables.dart';
import 'package:zerker/zerker.dart';
import '../globalconfig.dart';
import 'dragRoute.dart';
import 'signup.dart';

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

MapDemo mymap;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 260, width: 400,
              child: FittedBox(
                child: Image.asset("liquor.jpg"), fit: BoxFit.fill,
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 0.0),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 0.0, left: 20.0),
                      child: InkWell(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,

                      child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PageViewDemo()),
                              //MaterialPageRoute(builder: (context) => (jsonlisttest())),
                            );
                          },
                          child: const Text('Login', style: TextStyle(fontSize: 20)),
                          color: Colors.green,
                        ),
                      ),

                      /*
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            controlState = false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PageViewDemo()),
                            );

                          },
                          /*
                          onPanUpdate: (details){
                            if (details.delta.dx > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => dragRoute()),
                              );
                              // swiping in right direction
                            }

                            if (details.delta.dx < 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => dragRoute()),
                              );
                              // swiping in right direction
                            }
                          },
                          */

                        ),
                      ),
                      */
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            venueId = 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new MapDemo(notifyParent:(){})
                              ),
                            );
                          },
                          child: const Text('Login with facebook', style: TextStyle(fontSize: 20)),
                          color: Colors.white,
                        ),
                      ),
                      /*
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child:
                              ImageIcon(AssetImage('assets/facebook.png')),
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(

                            onTap: () {
                              controlState = true;
                              /*
                              mymap= new MapDemo(notifyParent: () {
                              },

                              );
*/
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new MapDemo(notifyParent:(){})
                                ),
                              );
                            },

                            )
                          ],
                        ),
                      ),
                      */
                    )
                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to Liquer ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: RaisedButton(
                    onPressed: () {},
                    child: const Text('Register', style: TextStyle(fontSize: 20)),
                    color: Colors.white,
                  ),
                ),

              ],
            )
          ],
        ));
  }
}
