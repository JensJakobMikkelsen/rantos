import 'package:floor/floor.dart';
import 'package:rantos_user/entity/table.dart';

@dao
abstract class TableDao {
  @Query('SELECT * FROM tables WHERE id = :id')
  Future<Tables> findTaskById(int id);

  @Query('SELECT * FROM tables')
  Future<List<Tables>> getAllTables();

  @Query('SELECT * FROM tables')
  Stream<List<Tables>> getAllTablesAsStream();

  @insert
  Future<void> insertTable(Tables table);

  @insert
  Future<void> insertTables(List<Tables> table);

  @update
  Future<void> updateTable(Tables table);

  @update
  Future<void> updateTables(List<Tables> table);

  @delete
  Future<void> deleteTable(Tables table);

  @delete
  Future<void> deleteTables(List<Tables> table);
}