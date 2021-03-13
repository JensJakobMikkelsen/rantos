import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:rantos_user/models/venue.dart';
import 'package:rantos_user/models/zerkertables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerker/zerker.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../database.dart';
import 'login_screen.dart';

class MyApp extends StatelessWidget {
  @override

  getString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    remember = (prefs.getString('remember'));
  }

  Widget build(BuildContext context) {
  getString();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(

        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: PageViewDemo(),

        ),
      ),
    );

  }
}

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

PageView pageView;
String remember = "abe";
WillPopScope will;

class _PageViewDemoState extends State<PageViewDemo> {

  refresh() {
    setState(() {});
  }

  PageController _controller = PageController(
    initialPage: 0,
    keepPage: true
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(remember == "abe")
    {

        pageView = PageView(
          controller: _controller,
          children: [
            //myPage1Widget(notifyParent: refresh),
            venue(),
            dragRoute(notifyParent: refresh),
            Zerker(app: MyZKApp(), clip: true, interactive: true)
          ],
        );

    }
    else{
        pageView = PageView(physics:new NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          //myPage1Widget(notifyParent: refresh),
          venue(),
          dragRoute(notifyParent: refresh),
          Zerker(app: MyZKApp(), clip: true, interactive: true)
        ],
      );
    }
      return pageView;
  }
}


class dragRoute extends StatefulWidget {

  final Function() notifyParent;
  dragRoute({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<dragRoute> {

  List<Widget> movableItems = [];
  var zek = Zerker(app: MyZKApp(), clip: true, interactive: true);


  setString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('remember', remember);
  }

  @override
  Widget build(BuildContext context) {

    will = WillPopScope(

        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Warning'),
            content: Text('Do you really want to exit'),
            actions: [
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {

                    remember = "abe";
                    setString();
                    Navigator.pop(c, true);
                  }
              ),
              FlatButton(
                child: Text('No'),
                onPressed: ()
                => Navigator.pop(c, false),
              ),

            ],
          ),
        ),

        child: Scaffold(
          appBar: AppBar(
            title: const Text('Layout place'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              remember = "jens";
              setString();

              setState(() {
                movableItems.add(MoveableStackItem());
              });

              //movableItems.add(MoveableStackItem());
              widget.notifyParent();


            },
          ),
          body:
          /*
          Zoom(
                  width: 1800,
                  height: 1800,
                  canvasColor: Colors.grey,
                  backgroundColor: Colors.orange,
                  colorScrollBars: Colors.purple,
                  opacityScrollBars: 0.9,
                  scrollWeight: 10.0,
                  centerOnScale: true,
                  enableScroll: true,
                  doubleTapZoom: true,
                  zoomSensibility: 2.3,
                  initZoom: 0.0,
*/

/*
                  Container(
                    //height: 1800,
                    //child: Zerker(app: MyZKApp(), clip: true, interactive: true),
*/
                    Stack(
                      children: movableItems,

                    )

              //)
          ),
        //)
    );

    return will;
  }

}

class MoveableStackItem extends StatefulWidget {
  @override State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}class _MoveableStackItemState extends State<MoveableStackItem> {

  void notiproof(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("On tap: "),
    ));
  }
  double xPosition = 0;
  double yPosition = 0;
  Color color;  @override
  void initState() {
    color = RandomColor().randomColor();
    super.initState();
  }  @override

  Widget build(BuildContext context) {

    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(

        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        onTap: ()
        {
          notiproof(context);
        },
        child: Container(
          width: 150,
          height: 150,
          color: color,
        ),
      ),
    );

  }
}

const lightBlue = Color(0xff00bbff);
const mediumBlue = Color(0xff00a2fc);
const darkBlue = Color(0xff0075c9);

final lightGreen = Colors.green.shade300;
final mediumGreen = Colors.green.shade600;
final darkGreen = Colors.green.shade900;

final lightRed = Colors.red.shade300;
final mediumRed = Colors.red.shade600;
final darkRed = Colors.red.shade900;

class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  MyBox(this.color, {this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


/*
class myPage1Widget extends StatefulWidget {

  final Function() notifyParent;
  myPage1Widget({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _venueWidget createState() => _venueWidget();
}

String _rememberColor = "normal";
var rememberedIndex = 0;



class _venueWidget extends State<myPage1Widget> {

  var id = ["title 1", "title 2", "title 3", "title 4", "title 5",];
  //var imag = ['images/rantos.png', 'images/panda.jpg', 'images/panda.jpg', 'images/panda.jpg' ,'images/panda.jpg'];

  var imag = [
    Image.asset("images/rantos.png"),
    Image.asset("images/panda.jpg"),
    Image.asset("images/panda.jpg"),
    Image.asset("images/panda.jpg"),
    Image.asset("images/liquor.jpg")
  ];

  void notiproof(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("On tap: " + _rememberColor),
    ));
  }

  getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    remember = (prefs.getString('remember'));
  }

  setColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('color', _rememberColor);
  }

 getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rememberedIndex = (prefs.getInt('index'));
  }

  setIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('index', rememberedIndex);
  }

  @override
  Widget build(BuildContext context) {
    getColor();
    getIndex();

      return new Scaffold(
        body: new ListView.builder(
            itemCount: id == null ? 0 : id.length,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector( //You need to make my child interactive
                onTap: () {
                  if (_rememberColor == "normal") {
                    _rememberColor = "red + " + index.toString();
                    rememberedIndex = index;
                    setColor();
                    setIndex();
                    notiproof(context);

                    setState(() {});
                  }
                  else {
                    _rememberColor = "normal";
                    rememberedIndex = 0;
                    setColor();
                    setIndex();
                    notiproof(context);

                    setState(() {});
                  }

                  widget.notifyParent();
                },

                child: new Card(

                  child: Container(

                    child: new Column(
                      children: <Widget>[

                        //new Image.network(video[index]),
                        new Padding(padding: new EdgeInsets.all(3.0)),
                        new Text(id[index],
                          style: new TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        //imag[index],

                      //new Image.network('https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60')

                    ],
                  ),),),
              );
            }),
      );
    }
  }

*/



/*
class dragRoute extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new MyHomePage(title: 'Flutter Demo Drag Box'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body:
      new DragGame(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DragGame extends StatefulWidget {
  @override
  _DragGameState createState() => new _DragGameState();
}

class _DragGameState extends State<DragGame> {
  int boxNumberIsDragged;

  @override
  void initState() {
    boxNumberIsDragged = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        constraints: BoxConstraints.expand(),
        color: Colors.grey,
        child: new Stack(
          children: <Widget>[
            buildDraggableBox(1, Colors.red, new Offset(30.0, 100.0)),
            buildDraggableBox(2, Colors.yellow, new Offset(30.0, 200.0)),
            buildDraggableBox(3, Colors.green, new Offset(30.0, 300.0)),
          ],
        ));
  }

  Widget buildDraggableBox(int boxNumber, Color color, Offset offset) {
    return new Draggable(
      maxSimultaneousDrags: boxNumberIsDragged == null || boxNumber == boxNumberIsDragged ? 1 : 0,
      child: _buildBox(color, offset),
      feedback: _buildBox(color, offset),
      childWhenDragging: _buildBox(color, offset, onlyBorder: true),
      onDragStarted: () {
        setState((){
          boxNumberIsDragged = boxNumber;
        });
      },
      onDragCompleted: () {
        setState((){
          boxNumberIsDragged = null;
        });
      },
      onDraggableCanceled: (_,__) {
        setState((){
          boxNumberIsDragged = null;
        });
      },
    );
  }

  Widget _buildBox(Color color, Offset offset, {bool onlyBorder: false}) {
    return new Container(
      height: 50.0,
      width: 50.0,
      margin: EdgeInsets.only(left: offset.dx, top: offset.dy),
      decoration: BoxDecoration(
          color: !onlyBorder ? color : Colors.grey,
          border: Border.all(color: color)),
    );
  }
}

*/

/*



class dragRoute extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<dragRoute> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Draggable(
              data: 5,
              child: Container(
                width: 100.0,
                height: 100.0,
                child: Center(
                  child: Text(
                    "5",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ),
                color: Colors.pink,
              ),
              feedback: Container(
                width: 100.0,
                height: 100.0,
                child: Center(
                  child: Text(
                    "5",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ),
                color: Colors.pink,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.green,
                  child: DragTarget(
                    builder:
                        (context, List<int> candidateData, rejectedData) {
                      print(candidateData);
                      return Center(child: Text("Even", style: TextStyle(color: Colors.white, fontSize: 22.0),));
                    },
                    onWillAccept: (data) {
                      return true;
                    },
                    onAccept: (data) {
                      if(data % 2 == 0) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Correct!")));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Wrong!")));
                      }
                    },
                  ),
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.deepPurple,
                  child: DragTarget(
                    builder:
                        (context, List<int> candidateData, rejectedData) {
                      return Center(child: Text("Odd", style: TextStyle(color: Colors.white, fontSize: 22.0),));
                    },
                    onWillAccept: (data) {
                      return true;
                    },
                    onAccept: (data) {
                      if(data % 2 != 0) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Correct!")));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Wrong!")));
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

*/
