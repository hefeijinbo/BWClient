import 'dart:core';

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BWDatabaseTag extends HiveObject{
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String tagId = "";
  @HiveField(2)
  String tagName = "";
  @HiveField(3)
  String color = "";
  @HiveField(4)
  String icon = "";
  @HiveField(5)
  String background = "";
  @HiveField(6)
  var showNavi = 0;
  @HiveField(7)
  var cTime = 0;
  @HiveField(8)
  var mTime = 0;
  @HiveField(9)
  var idType = 0;
  @HiveField(10)
  var tagAlias = "";
  @HiveField(11)
  var postArticleCount = 0;
  @HiveField(12)
  var concernUserCount = 0;
  @HiveField(13)
  var categoryId = "";
  @HiveField(14)
  var rank = 0;

 void update(Map<String, dynamic> dic, String categoryId) {
   id = dic["id"];
   tagId = dic["tag_id"];
   tagName = dic["tag_name"];
   color = dic["color"];
   icon = dic["icon"];
   background = dic["back_ground"];
   showNavi = dic["show_navi"];
   cTime = dic["ctime"];
   mTime = dic['mtime'];
   idType = dic["id_type"];
   tagAlias = dic["tag_alias"];
   postArticleCount = dic["post_article_count"];
   concernUserCount = dic["concern_user_count"];
   this.categoryId = categoryId;
 }
}

// Can be generated automatically
class TagAdapter extends TypeAdapter<BWDatabaseTag> {
  @override
  final typeId = 1;

  @override
  BWDatabaseTag read(BinaryReader reader) {
    final tag = BWDatabaseTag();
    tag.id = reader.read();
    tag.tagId = reader.read();
    tag.tagName = reader.read();
    tag.color = reader.read();
    tag.icon = reader.read();
    tag.background = reader.read();
    tag.showNavi = reader.read();
    tag.cTime = reader.read();
    tag.mTime = reader.read();
    tag.idType = reader.read();
    tag.tagAlias = reader.read();
    tag.postArticleCount = reader.read();
    tag.concernUserCount = reader.read();
    tag.categoryId = reader.read();
    tag.rank = reader.read();
    return tag;
  }

  @override
  void write(BinaryWriter writer, BWDatabaseTag obj) {
    writer.write(obj.id);
    writer.write(obj.tagId);
    writer.write(obj.tagName);
    writer.write(obj.color);
    writer.write(obj.icon);
    writer.write(obj.background);
    writer.write(obj.showNavi);
    writer.write(obj.cTime);
    writer.write(obj.mTime);
    writer.write(obj.idType);
    writer.write(obj.tagAlias);
    writer.write(obj.postArticleCount);
    writer.write(obj.concernUserCount);
    writer.write(obj.categoryId);
    writer.write(obj.rank);
  }
}