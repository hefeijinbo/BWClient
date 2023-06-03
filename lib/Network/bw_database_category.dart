//
//  BWDatabaseCategory.dart
//  BWClient
//
//  Created by jinbo on 2021/10/20.
//

import 'dart:core';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class BWDatabaseCategory extends HiveObject {
  @HiveField(0)
  String categoryId = "";
  @HiveField(1)
  String categoryName = "";
  @HiveField(2)
  String categoryUrl = "";
  @HiveField(3)
  int rank = 0;
  @HiveField(4)
  String backGround = "";
  @HiveField(5)
  String icon = "";
  @HiveField(6)
  var cTime = 0;
  @HiveField(7)
  int mTime = 0;
  @HiveField(8)
  int showType = 0;
  @HiveField(9)
  int itemType = 0;
  @HiveField(10)
  int promoteTagCap = 0;
  @HiveField(11)
  int promotePriority = 0;

  BWDatabaseCategory(Map<String, dynamic> dic) {
    if (dic.isEmpty) {
      return;
    }
    categoryId = dic["category_id"];
    categoryName = dic["category_name"];
    categoryUrl = dic["category_url"];
    rank = dic["rank"];
    backGround = dic["back_ground"];
    icon = dic["icon"];
    cTime = dic["ctime"];
    mTime = dic["mtime"];
    showType = dic["show_type"];
    itemType = dic["item_type"];
    promoteTagCap = dic["promote_tag_cap"];
    promotePriority = dic["promote_priority"];
  }
}

// Can be generated automatically
class CategoryAdapter extends TypeAdapter<BWDatabaseCategory> {
  @override
  final typeId = 0;

  @override
  BWDatabaseCategory read(BinaryReader reader) {
    final category = BWDatabaseCategory({});
    category.categoryId = reader.read();
    category.categoryName = reader.read();
    category.categoryUrl = reader.read();
    category.rank = reader.read();
    category.icon = reader.read();
    category.cTime = reader.read();
    category.mTime = reader.read();
    category.showType = reader.read();
    category.itemType = reader.read();
    category.promoteTagCap = reader.read();
    category.promotePriority = reader.read();
    return category;
  }

  @override
  void write(BinaryWriter writer, BWDatabaseCategory obj) {
    writer.write(obj.categoryId);
    writer.write(obj.categoryName);
    writer.write(obj.categoryUrl);
    writer.write(obj.rank);
    writer.write(obj.icon);
    writer.write(obj.cTime);
    writer.write(obj.mTime);
    writer.write(obj.showType);
    writer.write(obj.itemType);
    writer.write(obj.promoteTagCap);
    writer.write(obj.promotePriority);
  }
}