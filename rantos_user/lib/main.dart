import 'dart:math';
import 'package:flutter/material.dart';

import 'database.dart';
import 'models/login_screen.dart';
import 'models/websocket_ex.dart';

var tabledao;


//void main() => runApp(MyWebsocketApp());


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('flutter_database.db')
      .build();
  tabledao = database.tableDao;

  runApp(
      MyApp()
  );
}


