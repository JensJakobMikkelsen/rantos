import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/task_dao.dart';
import 'entity/task.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Task])
abstract class FlutterDatabase extends FloorDatabase {
  TaskDao get taskDao;
}