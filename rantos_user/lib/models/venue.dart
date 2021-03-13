import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database.dart';
import '../globalconfig.dart';

class VenueClass
{
  List<String> nameList;
  List<AssetImage> imagelist;
}

class venue extends StatefulWidget
{
  @override _venueActivity
  createState() => _venueActivity();
}

class _venueActivity extends State<venue>
{

  bool _loading = true;
  // LAV SØGEFUNKTION
  List<ListItem<Image>> list;
  var imag = [

    Image.asset("images/andys.png"),
    Image.asset("images/hive.png"),
    Image.asset("images/liquor.jpg"),
    Image.asset("images/panda.jpg"),
    Image.asset("images/liquor.jpg")
  ];

  void imageload() async
  {
    final Completer<void> completer = Completer<void>();

    for(int i = 0; i < 2; i++)
      {
        Image img = new Image.network("http://192.168.43.161:3002/establishments$i");
            img.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool syncCall) => completer.complete()));
        await completer.future;
        imag[i] = img;

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
  }

  @override
  void initState()
  {
    super.initState();
    imageload();
    populateData();
  }

  void populateData() {
    list = [];
    for (int i = 0; i < 5; i++)
      list.add(ListItem<Image>(imag[i]));
  }

  @override Widget
  build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar
        (
        title: Text("List Selection"),
      ),
      body:

      ListView.builder(itemCount: list.length,itemBuilder: _getListItemTile,
      ),
    );
  }
  Widget _getListItemTile(BuildContext context, int index)
  {
    return GestureDetector(
    onTap: () {
      venueId = index;
      showDialog(
        context: context,
        child: Dialog(
            child: new MapDemo(notifyParent:()
            {
            },
          ),
        ),
      );

      if (list.any((item) => item.isSelected))
          {
            setState(()
            {
              list[index].isSelected = !list[index].isSelected;
            }
            );
          }
    },
    onLongPress: ()
    {
      setState(()
      {
        list[index].isSelected = true;
      }
      );
    },

    child:
        Container(
          color: Colors.black,
          //margin: EdgeInsets.symmetric(horizontal: ),
          child: Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      color: list[index].isSelected ? Colors.red[100] : Colors.white,
      child: ListTile(
        title: imag[index],
      ),
    ),),
  );

  }
}

class ListItem<T>
{
  bool isSelected = false;
  T data;
  ListItem(this.data); //Constructor to assign the data

}
