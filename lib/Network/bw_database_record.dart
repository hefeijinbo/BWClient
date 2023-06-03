import 'package:hive/hive.dart';

const statusIsCollect = 1 << 0; // 收藏状态
const statusIsDeleted = 1 << 1; // 删除状态

// 记录客户端的用户数据
@HiveType(typeId: 4)
class BWDatabaseRecord extends HiveObject {
  @HiveField(0)
  String id = "";
  @HiveField(1)
  int status = 0;

  BWDatabaseRecord(this.id, this.status);
}

// Can be generated automatically
class RecordAdapter extends TypeAdapter<BWDatabaseRecord> {
  @override
  final typeId = 4;

  @override
  BWDatabaseRecord read(BinaryReader reader) {
    final record = BWDatabaseRecord(reader.read(), reader.read());
    return record;
  }

  @override
  void write(BinaryWriter writer, BWDatabaseRecord obj) {
    writer.write(obj.id);
    writer.write(obj.status);
  }
}