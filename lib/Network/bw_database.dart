import 'dart:io';

import 'package:bw_client/Common/common.dart';
import 'package:bw_client/Network/bw_database_article.dart';
import 'package:bw_client/Network/bw_database_category.dart';
import 'package:bw_client/Network/bw_database_cursor.dart';
import 'package:hive/hive.dart';

import 'bw_database_category.dart';
import 'bw_database_record.dart';
import 'bw_database_tag.dart';

// Category
class BWDatabase {
  static config() async {
    printLog("system db path: " + Directory.systemTemp.path);
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(ArticleAdapter());
    Hive.registerAdapter(CursorAdapter());
    Hive.registerAdapter(RecordAdapter());
    await Hive.openBox<BWDatabaseCategory>("category", path: Directory.systemTemp.path);
    await Hive.openBox<BWDatabaseTag>("tag", path: Directory.systemTemp.path);
    await Hive.openBox<BWDatabaseArticle>("article", path: Directory.systemTemp.path);
    await Hive.openBox<BWDatabaseCursor>("cursor", path: Directory.systemTemp.path);
    await Hive.openBox<BWDatabaseRecord>("record", path: Directory.systemTemp.path);
  }
  static var categoryBox = Hive.box<BWDatabaseCategory>("category");
  static var tagBox = Hive.box<BWDatabaseTag>("tag");
  static var articleBox = Hive.box<BWDatabaseArticle>("article");
  static var cursorBox = Hive.box<BWDatabaseCursor>("cursor");
  static var recordBox = Hive.box<BWDatabaseRecord>("record");

  static bool hasCategory() {
    return categoryBox.values.any((element) => element.categoryId.isNotEmpty);
  }

  static saveCategory(List<BWDatabaseCategory> objects) {
    for (var element in objects) {
      categoryBox.put(element.categoryId, element);
      element.save();
    }
  }

  static List<BWDatabaseCategory> getLocalCategory() {
    var list = categoryBox.values.where((element) => element.categoryId.isNotEmpty).toList();
    list.sort((e1, e2) => e1.rank > e2.rank ? 1 : 0);
    return list;
  }

  static bool hasTag(String categoryId) {
    return tagBox.values.any((element) => element.categoryId == categoryId && element.tagId.isNotEmpty);
  }

  static void saveTag(List<BWDatabaseTag> objects, String categoryId) {
    var i = 0;
    for (var element in objects) {
      element.rank = i;
      i++;
      tagBox.put(element.tagId + "," + categoryId, element);
      element.save();
    }
  }

  static List<BWDatabaseTag> getLocalTag(String categoryId) {
    var list = tagBox.values.where((element) => element.tagId.isNotEmpty && element.categoryId == categoryId).toList();
    list.sort((e1, e2) => e1.rank > e2.rank ? 1 : 0);
    return list;
  }

  static bool hasArticle(String categoryId, String tagId) {
    return articleBox.values.any((element) => element.articleId.isNotEmpty && element.categoryId == categoryId && element.tagId == tagId);
  }

  static void saveArticle(List<BWDatabaseArticle> objects) {
    for (var element in objects) {
      articleBox.put(element.tagId + "," + element.articleId, element);
      element.save();
    }
  }

  static List<BWDatabaseArticle> getLocalArticle(String categoryId, String tagId) {
    var list = articleBox.values.where((element) => element.articleId.isNotEmpty && element.categoryId == categoryId && element.tagId == tagId).toList();
    list.sort((e1, e2) => e2.mtime.compareTo(e1.mtime));
    return list;
  }

  static BWDatabaseCursor getLocalCursor(String categoryId, String tagId, int sortType) {
    final list = cursorBox.values.where((element) => element.cursorId.isNotEmpty && element.categoryId == categoryId && element.tagId == tagId);
    var cursor = BWDatabaseCursor("0", categoryId, tagId, sortType);
    if (list.isNotEmpty) {
      cursor = list.first;
    }
    return cursor;
  }

  static void saveCursor(BWDatabaseCursor cursor) {
    cursorBox.put(cursor.categoryId+","+cursor.tagId+","+cursor.sortValue.toString(), cursor);
    cursor.save();
  }

  static void saveArticleRecord(BWDatabaseArticle article, int status) {
    final record = BWDatabaseRecord(article.articleId, status);
    recordBox.put(article.articleId, record);
    record.save();
  }

  static BWDatabaseRecord? getRecord(String id) {
    final records = recordBox.values.where((element) => element.id.isNotEmpty && element.id == id);
    return records.isEmpty ? null : records.first;
  }

  static List<BWDatabaseRecord> getCollectArticleRecords() {
    final records = recordBox.values.where((element) => element.id.isNotEmpty && element.status & statusIsCollect == statusIsCollect);
    return records.toList();
  }

  static List<BWDatabaseRecord> getDeleteArticleRecords() {
    final records = recordBox.values.where((element) => element.id.isNotEmpty && element.status & statusIsDeleted == statusIsDeleted);
    return records.toList();
  }
}