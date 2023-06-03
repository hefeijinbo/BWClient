import 'dart:convert';

import 'package:bw_client/Common/common.dart';
import 'package:bw_client/Network/bw_database_article.dart';
import 'package:bw_client/Network/bw_database_category.dart';
import 'package:bw_client/Network/bw_database_cursor.dart';
import 'package:bw_client/Network/bw_database_tag.dart';
import 'package:http/http.dart' as http;

import 'bw_database.dart';


class BwNetwork extends Object {
  static const categoryAPI =
      "https://api.juejin.cn/tag_api/v1/query_category_briefs";
  static const tagAPI =
      "https://api.juejin.cn/recommend_api/v1/tag/recommend_tag_list";
  static const articleAPI =
      "https://api.juejin.cn/recommend_api/v1/article/recommend_cate_tag_feed";

  static handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      return [false, response.reasonPhrase, defaultCursorType];
    }
    final dic = jsonDecode(response.body) as Map<String, dynamic>;
    final errNo = dic["err_no"] ?? 1;
    if (errNo != 0) {
      final msg = dic["err_msg"] ?? "";
      printLog(msg);
      return [false, msg, defaultCursorType];
    }
    return [true, "", dic["data"], dic["cursor"]];
  }

  static Future<bool> requestCategory() async {
    printLog("download category");
    final response = await http.get(Uri.parse(categoryAPI));
    final result = handleResponse(response);
    if (result[0] == false) {
      return false;
    }
    final data = result[2] as List;
    final categorys = data.map((e) => BWDatabaseCategory(e)).toList();
    BWDatabase.saveCategory(categorys);
    return true;
  }

  static Future<bool> requestTag(String categoryId) async {
    printLog("download tag");
    final response = await http.post(Uri.parse(tagAPI), headers: {"Content-Type": "application/json"}, body: json.encode({"cate_id": categoryId}));
    final result = handleResponse(response);
    if (result[0] == false) {
      return false;
    }
    final data = result[2] as List;
    final tags = data.map((e) {
      final tag = BWDatabaseTag();
      tag.update(e, categoryId);
      return tag;
    });
    BWDatabase.saveTag(tags.toList(), categoryId);
    return true;
  }

  static Future<bool> requestArticle(String cursor, int sortType, String categoryId, String tagId) async {
    printLog("download article");
    final response = await http.post(Uri.parse(articleAPI), headers: {"Content-Type": "application/json"}, body: json.encode({"cursor": cursor, "cate_id": categoryId, "tag_id": tagId, "sort_type": sortType, "limit": 20}));
    final result = handleResponse(response);
    if (result[0] == false) {
      return false;
    }
    final data = result[2] as List;
    final articles = data.map((e) {
      final article = BWDatabaseArticle();
      article.update(e, tagId);
      return article;
    });
    BWDatabase.saveArticle(articles.toList());
    BWDatabase.saveCursor(BWDatabaseCursor(result[3], categoryId, tagId, sortType));
    return true;
  }
}
