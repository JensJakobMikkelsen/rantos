
import 'dart:ui';

import 'package:floor/floor.dart';

@entity
class Tables {
  @PrimaryKey(autoGenerate: true)
  final int tableId;
  final int floorId;
  final String tableOwner;
  final double xcoord;
  final double ycoord;

  Tables(this.tableId, this.floorId, this.tableOwner, this.xcoord, this.ycoord);


}