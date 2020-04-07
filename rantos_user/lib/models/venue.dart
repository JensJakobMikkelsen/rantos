import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'dragRoute.dart';
import 'indoor_map.dart';
import 'login_screen.dart';

class venue extends StatefulWidget
{
  @override _venueActivity
  createState() => _venueActivity();


}

class _venueActivity extends State<venue>
{
  List<ListItem<Image>> list;
  var imag = [
    Image.asset("images/andys.png"),
    Image.asset("images/hive.png"),
    Image.asset("images/liquor.jpg"),
    Image.asset("images/panda.jpg"),
    Image.asset("images/liquor.jpg")
  ];
  @override

  void initState()
  {
    super.initState();
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

    var age = 25;

    List<String> iceCreamToppings = <String>[
      'Hot Fudge',
      'Sprinkles',
      'Caramel',
      'Oreos',
    ];
    List<String> selectedIceCreamToppings = <String>[
      'Hot Fudge',
      'Sprinkles',
    ];

    //List<Widget> movableItems = [new MoveableStackItem(), new MoveableStackItem()];

    return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        child: Dialog(
            child: new MapDemo(notifyParent:(){

            },
            /*
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    movableItems.add(MoveableStackItem());
                  });
                },
              ),
              body:
              Container(
                height: 500,
                child:
                Stack(
                  children: movableItems,

                ),

              ),
            )
                */
          ),
        ),

      );

      /*
          showMaterialResponsiveDialog(
            context: context,
            child: Center(
              child: Container(
              padding: EdgeInsets.all(30.0),
              child: Text(
              "This is the base dialog widget for the pickers. Unlike the off-the-shelf Dialog widget, it handles landscape orientations. You may place any content here you desire.",
                style: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
              ),
              ),
              ),
            ),
          );
*/
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
