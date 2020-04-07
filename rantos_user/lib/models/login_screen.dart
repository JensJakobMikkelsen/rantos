import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rantos_user/models/indoor_map.dart';
import 'package:rantos_user/models/zerkertables.dart';
import 'package:zerker/zerker.dart';
import '../database.dart';
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
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
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

                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
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
                              child: Center(

                                child: Text('Log in with facebook',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              )


                            )
                          ],
                        ),
                      ),
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
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
}



/*
class LoginPage extends StatefulWidget {
  LoginPage(String s);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginCallBack {
  BuildContext _ctx;
  bool _isLoading = false;
  var formKey = new GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();  String _username, _password;  LoginResponse _response;  _LoginPageState() {
    _response = new LoginResponse(this);
  }  void _submit() {
    final form = formKey.currentState;    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(_username, _password);
      });
    }
  }  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }  @

  override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn, loginForm, exBtn;
      loginBtn = new RaisedButton(
        onPressed: _submit,
        child: new Text("Login"),
        color: Colors.green,
        );

    exBtn = new RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => locationRoute()),
        );
      },
      child: new Text("Login"),

      color: Colors.green,
    );

      loginForm = new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new TextFormField(
                    onSaved: (val) => _username = val,
                    decoration: new InputDecoration(labelText: "Username"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new TextFormField(
                    onSaved: (val) => _password = val,
                    decoration: new InputDecoration(labelText: "Password"),
                  ),
                )
              ],
            ),
          ),

          loginBtn, exBtn,
        ],

      );

    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text("Login Page"),
        ),
        key: scaffoldKey,
        body: new Container(
          child: new Center(
            child: loginForm,
          ),
        ),
      )
    );
    }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }  @override
  void onLoginSuccess(User user) async {        if(user != null){
    Navigator.of(context).pushNamed("/home");
  }else{
    // TODO: implement onLoginSuccess
    _showSnackBar("Login Gagal, Silahkan Periksa Login Anda");
    setState(() {
      _isLoading = false;
    });
  }

  }
}
*/