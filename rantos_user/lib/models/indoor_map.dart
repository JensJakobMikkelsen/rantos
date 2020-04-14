import 'dart:ui';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

//void main() => runApp(MyApp());

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageViewDemo(notifyParent: () {},),

    );
  }
}
*/

class MapObject {
  final Widget child;

  ///relative offset from the center of the map for this map object. From -1 to 1 in each dimension.
  Offset offset;

  ///size of this object for the zoomLevel == 1
  final Size size;

  MapObject({
    @required this.child,
    @required this.offset,
    this.size,
  });
}

List<MapObject> _objects = [
                    MapObject(
                      child: Container(
                        color: Colors.red,
                      ),
                      offset: Offset(0, 0),
                      size: Size(10, 10),
                    ),
];

class _ImageViewportState extends State<ImageViewport> {
  double _zoomLevel;
  ImageProvider _imageProvider;
  ui.Image _image;
  bool _resolved;
  Offset _centerOffset;
  double _maxHorizontalDelta;
  double _maxVerticalDelta;
  Offset _normalized;
  bool _denormalize = false;
  Size _actualImageSize;
  Size _viewportSize;

  double abs(double value) {
    return value < 0 ? value * (-1) : value;
  }

  Size getActualImageWitdh()
  {
    Size temp_actualImageSize = Size(
        (_image.width / window.devicePixelRatio) * _zoomLevel,
        (_image.height / ui.window.devicePixelRatio) * _zoomLevel);
    return temp_actualImageSize;
  }

  bool only_once = false;
  void _updateActualImageDimensions() {

    if(!only_once) {
      _actualImageSize = Size(
          (_image.width / window.devicePixelRatio) * _zoomLevel,
          (_image.height / ui.window.devicePixelRatio) * _zoomLevel);
      only_once = true;
    }

  }

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.zoomLevel;
    _imageProvider = widget.imageProvider;
    _resolved = false;
    _centerOffset = Offset(0, 0);
    _objects = widget.objects;
  }

  void _resolveImageProvider(){
    ImageStream stream = _imageProvider.resolve(createLocalImageConfiguration(context));

    var temp_witdh;
    var temp_height;

    stream.addListener(ImageStreamListener((info, _)
    {
      _image = info.image;
      _resolved = true;
      _updateActualImageDimensions();
      setState(() {});
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImageProvider();
  }

  @override
  void didUpdateWidget(ImageViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.imageProvider != _imageProvider) {
      _imageProvider = widget.imageProvider;
      _resolveImageProvider();
    }
    double normalizedDx = _maxHorizontalDelta == 0 ? 0 : _centerOffset.dx / _maxHorizontalDelta;
    double normalizedDy = _maxVerticalDelta == 0 ? 0 : _centerOffset.dy / _maxVerticalDelta;
    _normalized = Offset(normalizedDx, normalizedDy);
    _denormalize = true;
    _zoomLevel = widget.zoomLevel;
    _updateActualImageDimensions();
  }

  ///This is used to convert map objects relative global offsets from the map center
  ///to the local viewport offset from the top left viewport corner.
  Offset _globaltoLocalOffset(Offset value) {
    double hDelta = (_actualImageSize.width / 2) * value.dx;
    double vDelta = (_actualImageSize.height / 2) * value.dy;
    double dx = (hDelta - _centerOffset.dx) + (_viewportSize.width / 2);
    double dy = (vDelta - _centerOffset.dy) + (_viewportSize.height / 2);
    return Offset(dx, dy);
  }

  ///This is used to convert global coordinates of long press event on the map to relative global offsets from the map center
  Offset _localToGlobalOffset(Offset value) {
    double dx = value.dx - _viewportSize.width / 2;
    double dy = value.dy - _viewportSize.height / 2;
    double dh = dx + _centerOffset.dx;
    double dv = dy + _centerOffset.dy;
    return Offset(
      dh / (_actualImageSize.width / 2),
      dv / (_actualImageSize.height / 2),
    );
  }

  @override
  Widget build(BuildContext context) {

    void handleDrag(DragUpdateDetails updateDetails) {
      Offset newOffset = _centerOffset.translate(-updateDetails.delta.dx, -updateDetails.delta.dy);
      if (abs(newOffset.dx) <= _maxHorizontalDelta && abs(newOffset.dy) <= _maxVerticalDelta)
        setState(() {
          _centerOffset = newOffset;
        });
    }

    void addMapObject(MapObject object) => setState(() {
      _objects.add(object);
    });

    void removeMapObject(MapObject object) => setState(() {
      _objects.remove(object);
    });

    List<Widget> buildObjects() {
      return _objects
          .map(
            (MapObject object) => Positioned(
          left: _globaltoLocalOffset(object.offset).dx - (object.size == null ? 0 : (object.size.width * _zoomLevel) / 2),
          top: _globaltoLocalOffset(object.offset).dy - (object.size == null ? 0 : (object.size.height * _zoomLevel) / 2),
          child: GestureDetector(
            onTapUp: (TapUpDetails details) {

              if(controlState) {

                Dialog errorDialog = Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0)),
                  //this right here
                  child: Container(
                    height: 300.0,
                    width: 300.0,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            'Cool', style: TextStyle(color: Colors.red),),
                        ),

                        Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                            child: IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.arrow_back),
                              onPressed: ()
                              {
                                MapObject newObject;
                                Offset off = Offset(object.offset.dx - 0.01, object.offset.dy);

                                newObject = MapObject(
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                  offset: off,
                                  size: Size(100, 100),
                                );
                                addMapObject(newObject);
                                if(object != null) {
                                  removeMapObject(object);
                                }
                                object = newObject;
                                /*
                                setState(() {
                                  _zoomLevel = _zoomLevel * 2;
                                }
                                );
                                 */
                              },
                            ),
                          ),

                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.arrow_forward),
                              onPressed: ()
                              {
                                MapObject newObject;
                                Offset off = Offset(object.offset.dx + 0.01, object.offset.dy);

                                newObject = MapObject(
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                  offset: off,
                                  size: Size(100, 100),
                                );
                                addMapObject(newObject);
                                if(object != null) {
                                  removeMapObject(object);
                                }
                                object = newObject;
                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.arrow_upward),
                              onPressed: ()
                              {
                                MapObject newObject;
                                Offset off = Offset(object.offset.dx, object.offset.dy - 0.01);

                                newObject = MapObject(
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                  offset: off,
                                  size: Size(100, 100),
                                );
                                addMapObject(newObject);
                                if(object != null) {
                                  removeMapObject(object);
                                }
                                object = newObject;

                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.arrow_downward),
                              onPressed: ()
                              {
                                MapObject newObject;
                                Offset off = Offset(object.offset.dx, object.offset.dy + 0.01);

                                newObject = MapObject(
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                  offset: off,
                                  size: Size(100, 100),
                                );
                                addMapObject(newObject);
                                if(object != null) {
                                  removeMapObject(object);
                                }
                                object = newObject;
                              },
                            ),
                           ]
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(onPressed: () {

                              Dialog choiseDialog = Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                //this right here
                                child: Container(
                                  height: 300.0,
                                  width: 300.0,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(top: 50.0)),
                                      FlatButton(onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                          child: Text('Choose Table', style: TextStyle(
                                              color: Colors.purple, fontSize: 18.0),))


                                    ],
                                  ),
                                ),
                              );
                              showDialog(context: context,
                                  builder: (BuildContext context) => choiseDialog);

                              //Navigator.of(context).pop();
                            }, child: Text("abe"),
                            ),

                          ],

                        ),
                      ],
                    ),
                  ),
                );
                showDialog(context: context,
                    builder: (BuildContext context) => errorDialog);
              }
              else
                {
                  Dialog errorDialog = Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    //this right here
                    child: Container(
                      height: 300.0,
                      width: 300.0,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          FlatButton(onPressed: () {
                            Navigator.of(context).pop();
                          },
                              child: Text('Choose Table', style: TextStyle(
                                  color: Colors.purple, fontSize: 18.0),))


                        ],
                      ),
                    ),
                  );
                  showDialog(context: context,
                      builder: (BuildContext context) => errorDialog);
                }
            },

            child: Container(
              width: object.size == null ? null : object.size.width * _zoomLevel,
              height: object.size == null ? null : object.size.height * _zoomLevel,
              child: object.child,
            ),
          ),
        ),
      )
          .toList();
    }
    return _resolved
        ? LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _viewportSize = Size(min(constraints.maxWidth, _actualImageSize.width), min(constraints.maxHeight, _actualImageSize.height));
        _maxHorizontalDelta = (_actualImageSize.width - _viewportSize.width) / 2;
        _maxVerticalDelta = (_actualImageSize.height - _viewportSize.height) / 2;
        bool reactOnHorizontalDrag = _maxHorizontalDelta > _maxVerticalDelta;
        bool reactOnPan = (_maxHorizontalDelta > 0 && _maxVerticalDelta > 0);
        if (_denormalize) {
          _centerOffset = Offset(_maxHorizontalDelta * _normalized.dx, _maxVerticalDelta * _normalized.dy);
          _denormalize = false;
        }

        return GestureDetector(

          onPanUpdate: reactOnPan ? handleDrag : null,
          onHorizontalDragUpdate: reactOnHorizontalDrag && !reactOnPan ? handleDrag : null,
          onVerticalDragUpdate: !reactOnHorizontalDrag && !reactOnPan ? handleDrag : null,
          onLongPressEnd: (LongPressEndDetails details) {

            RenderBox box = context.findRenderObject();
            Offset localPosition = box.globalToLocal(details.globalPosition);
            Offset newObjectOffset = _localToGlobalOffset(localPosition);

            if(controlState) {
              MapObject newObject;
              if (globalColor == "red") {
                newObject = MapObject(
                  child: Container(
                    color: Colors.red,
                  ),
                  offset: newObjectOffset,
                  size: Size(50, 50),
                );
              }
              else {
                newObject = MapObject(

                  child: Container(
                    color: Colors.blue,
                  ),
                  offset: newObjectOffset,
                  size: Size(50, 50),
                );
              }
              addMapObject(newObject);
            }
          },
          child: Stack(
            children: <Widget>[
              CustomPaint(
                size: _viewportSize,
                painter: MapPainter(_image, _zoomLevel, _centerOffset),
              ),

            ]+
                buildObjects(),
          ),
        );
      },
    )
        : SizedBox();
  }
}

class ImageViewport extends StatefulWidget {
  final double zoomLevel;
  final ImageProvider imageProvider;
  final List<MapObject> objects;

  ImageViewport({
    @required this.zoomLevel,
    @required this.imageProvider,
    this.objects,
  });

  @override
  State<StatefulWidget> createState() => _ImageViewportState();
}

class MapPainter extends CustomPainter {
  final ui.Image image;
  final double zoomLevel;
  final Offset centerOffset;

  MapPainter(this.image, this.zoomLevel, this.centerOffset);

  @override
  void paint(Canvas canvas, Size size) {
    double pixelRatio = window.devicePixelRatio;
    Size sizeInDevicePixels = Size(size.width * pixelRatio, size.height * pixelRatio);
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    Offset centerOffsetInDevicePixels = centerOffset.scale(pixelRatio / zoomLevel, pixelRatio / zoomLevel);
    Offset centerInDevicePixels = Offset(image.width / 2, image.height / 2).translate(centerOffsetInDevicePixels.dx, centerOffsetInDevicePixels.dy);
    Offset topLeft = centerInDevicePixels.translate(-sizeInDevicePixels.width / (2 * zoomLevel), -sizeInDevicePixels.height / (2 * zoomLevel));
    Offset rightBottom = centerInDevicePixels.translate(sizeInDevicePixels.width / (2 * zoomLevel), sizeInDevicePixels.height / (2 * zoomLevel));
    canvas.drawImageRect(
      image,
      Rect.fromPoints(topLeft, rightBottom),
      Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ZoomContainerState extends State<ZoomContainer> {
  double _zoomLevel;
  ImageProvider _imageProvider;
  List<MapObject> _objects;

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.zoomLevel;
    _imageProvider = widget.imageProvider;
    _objects = widget.objects;
  }

  @override
  void didUpdateWidget(ZoomContainer oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.imageProvider != _imageProvider) _imageProvider = widget.imageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ImageViewport(
          zoomLevel: _zoomLevel,
          imageProvider: _imageProvider,
          objects: _objects,
        ),
        Row(
          children: <Widget>[
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                setState(() {
                  _zoomLevel = _zoomLevel * 2;
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                setState(() {
                  _zoomLevel = _zoomLevel / 2;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ZoomContainer extends StatefulWidget {
  final double zoomLevel;
  final ImageProvider imageProvider;
  final List<MapObject> objects;

  ZoomContainer({
    this.zoomLevel = 1,
    @required this.imageProvider,
    this.objects = const [],
  });

  @override
  State<StatefulWidget> createState() => ZoomContainerState();
}

bool controlState = true;

class MapDemo extends StatefulWidget {

  final Function() notifyParent;
  MapDemo({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _MapDemoState createState() => _MapDemoState();
}

var globalColor = "red";

class _MapDemoState extends State<MapDemo> {

  var abe;

  @override
  Widget build(BuildContext context) {
    List<Widget> movableItems = [];
    var abe = Image.asset("assets/map_reshaped.png");

    if(controlState) {
      return Scaffold(
        //https://medium.com/flutterpub/flutter-navigation-drawer-from-basic-to-custom-drawer-66a60d27d687
        //drawer
        //For full screen: //For full screen:
        //          /*
        //          drawer: Container(
        //            width: MediaQuery.of(context).size.width,
        //            height: MediaQuery.of(context).size.height,
        //            color: Colors.white,
        //            child: ListView(
        //              padding: EdgeInsets.zero,
        //              children: [
        //                DrawerHeader(
        //                  decoration: BoxDecoration(
        //                      image: DecorationImage(
        //                          image: AssetImage("images/header.jpeg"),
        //                          fit: BoxFit.cover)),
        //                  child: Text("Header"),
        //                ),
        //                ListTile(
        //                  title: Text("Home"),
        //                  onTap: () {
        //                    Navigator.of(context).pop();
        //                  },
        //                )
        //              ],
        //            ),
        //          ),
        //
        //           */

        endDrawer: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/header.jpeg"),
                        fit: BoxFit.cover
                    )
                ),
                child: Text("Header"), //Or column
              ),
              ListTile(
                title: Text("Home"),
                onTap: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),

        appBar: AppBar(
          title: Text("Move the map"),
        ),

        body: Builder(
          builder: (ctx) =>
              Center(
                child: Column(
                  children:
                  <Widget>[
                    Container(
                      height: 400,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1.0,
                      padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ZoomContainer(
                        zoomLevel: 2,
                        imageProvider: abe.image,
                        objects:
                        List.generate(_objects.length, (index) {
                          return (_objects[index]);
                        }),

                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child:
                        FloatingActionButton(onPressed: () {
                          if (globalColor == "red") {
                            globalColor = "blue";
                          }
                          else {
                            globalColor = "red";
                          }

                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text("On tap: change color"),
                          ));
                        },
                        )

                    ),
                  ],
                ),
              ),),
      );
    }
    else
      {
        return Scaffold(
          appBar: AppBar(
            title: Text("Move the map"),
          ),
          body: Builder(
            builder: (ctx) =>
                Center(
                  child: Column(
                    children:
                    <Widget>[
                      Container(
                        height: 400,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 1.0,
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ZoomContainer(
                          zoomLevel: 2,
                          imageProvider: abe.image,
                          objects:
                          List.generate(_objects.length, (index) {
                            return (_objects[index]);
                          }),

                        ),
                      ),
                    ],
                  ),
                ),),
        );

      }
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
