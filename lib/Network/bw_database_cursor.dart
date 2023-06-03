import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class BWDatabaseCursor extends HiveObject {
  @HiveField(0)
  String cursorId = "";
  @HiveField(1)
  var categoryId = "";
  @HiveField(2)
  String tagId = "";
  @HiveField(3)
  var sortValue = 0;

  BWDatabaseCursor(this.cursorId, this.categoryId, this.tagId, this.sortValue);
}

// Can be generated automatically
class CursorAdapter extends TypeAdapter<BWDatabaseCursor> {
  @override
  final typeId = 3;

  @override
  BWDatabaseCursor read(BinaryReader reader) {
    final cursor = BWDatabaseCursor(reader.read(), reader.read(), reader.read(), reader.read());
    return cursor;
  }

  @override
  void write(BinaryWriter writer, BWDatabaseCursor obj) {
    writer.write(obj.cursorId);
    writer.write(obj.categoryId);
    writer.write(obj.tagId);
    writer.write(obj.sortValue);
  }
}