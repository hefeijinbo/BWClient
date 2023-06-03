
import 'package:bw_client/Common/BWWebView.dart';
import 'package:bw_client/Common/common.dart';
import 'package:bw_client/Network/bw_database.dart';
import 'package:bw_client/Network/bw_database_article.dart';
import 'package:bw_client/Network/bw_database_category.dart';
import 'package:bw_client/Network/bw_database_cursor.dart';
import 'package:bw_client/Network/bw_database_record.dart';
import 'package:bw_client/Network/bw_database_tag.dart';
import 'package:bw_client/Network/bw_network.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:bw_client/main.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

enum HomeViewType {
  category,
  tag,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BWDatabaseCategory> categorys = [];
  var selectCategoryIndex = 0;
  List<BWDatabaseTag> tags = [];
  var selectTagIndex = 0;
  List<BWDatabaseArticle> articles = [];
  final currentSortType = sortTypeLatest;

  @override
  void initState() {
    super.initState();
    reloadData(false, false);
  }

  ListView getListView(HomeViewType viewType) {
    var listView = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewType == HomeViewType.category ? categorys.length : tags.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position, viewType);
        });
    return listView;
  }
  final EasyRefreshController _refreshController = EasyRefreshController();

  SizedBox getContentListView() {
    var listView = ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int position) {
          return Column(children: [getContentListTitle(articles[position]), const Divider(height: 0.0, indent: 0.0, color: Colors.black12)]);
        });
    final refreshView = EasyRefresh(enableControlFinishRefresh: true,
        enableControlFinishLoad: true, child: listView, onRefresh: () async {
      reloadData(true, false);
    }, onLoad: () async {
      reloadData(false, true);
      }, controller: _refreshController);
    return SizedBox(child: refreshView, width: BWScreenWidth, height: BWScreenHeight);
  }

  ListTile getContentListTitle(BWDatabaseArticle article) {
    final desc = article.userName + "\n" + BWUtil.getDescriptionWithTime(int.parse(article.mtime));
    final descText = Text(desc, style: const TextStyle(fontSize: 10));
    const fontStyle = TextStyle(fontSize: 14);
    const fontStyle2 = TextStyle(fontSize: 12);
    return ListTile(title: Text(article.title, style: fontStyle, maxLines: 2),
        subtitle: Text(article.briefContent, style: fontStyle2, maxLines: 2),
        leading: article.coverImage.isEmpty ? null : Image.network(article.coverImage, width: 80, fit: BoxFit.cover), trailing: descText,
    onTap: () async {
      final _url = "https://juejin.cn/post/"+article.articleId + "?device_platform=iphone";
      if (Platform.isAndroid || Platform.isIOS) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BWWebView(_url, article.title)),
        );
      } else {
        // if (!await launch(_url)) printLog('Could not launch $_url');
        final webview = await WebviewWindow.create();
        webview.launch(_url);
      }
    },
    onLongPress: () {
      showLongPressAlert(article);
    });
  }

  void showLongPressAlert(BWDatabaseArticle article) async {
    await showDialog(context: context, builder: (context) {
      final collectionButton = MaterialButton(child: const Text("收藏"), onPressed: () {
        final status = BWDatabase.getRecord(article.articleId)?.status ?? 0;
        BWDatabase.saveArticleRecord(article, status | statusIsCollect);
        Navigator.pop(context);
      });
      final deleteButton = MaterialButton(child: const Text("删除"), onPressed: () {
        final status = BWDatabase.getRecord(article.articleId)?.status ?? 0;
        BWDatabase.saveArticleRecord(article, status | statusIsDeleted);
        reloadData(false, false);
        Navigator.pop(context);
      });
      final alert = AlertDialog(title: const Text("请选择操作"), actions: [collectionButton, deleteButton]);
      return alert;
    });
  }

  Widget getRow(int i, HomeViewType viewType) {
    final name = viewType == HomeViewType.category ? categorys[i].categoryName : tags[i].tagName;
    final selected = viewType == HomeViewType.category ? i == selectCategoryIndex : i == selectTagIndex;
    var style = TextStyle(color: selected ? Colors.blue : Colors.black);
    if (viewType == HomeViewType.tag) {
      style = TextStyle(color: selected ? Colors.white : Colors.black);
    }
    var text = Container(padding: const EdgeInsets.fromLTRB(5, 0, 5, 0), child:Text(name, style: style));
    if (viewType == HomeViewType.tag) {
      var dec = BoxDecoration(color: selected ? Colors.blue : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(20)));
      text = Container(decoration: dec, padding: const EdgeInsets.fromLTRB(5, 0, 5, 0), child:Text(name, style: style));
    }
    final detector = GestureDetector(child:Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: text), onTap: () async {
     selectRow(i, viewType);
    });
    return detector;
  }

  void selectRow(int i, HomeViewType viewType) async {
    if (viewType == HomeViewType.category) {
      selectCategoryIndex = i;
      selectTagIndex = 0;
    } else{
      selectTagIndex = i;
    }
    reloadData(false, false);
  }

  void reloadData(bool forceUpdate, bool isLoadMore) async {
    if (categorys.isEmpty) {
      categorys = BWDatabase.getLocalCategory();
    }
    if (categorys.isEmpty || forceUpdate) {
      selectCategoryIndex = 0;
      await BwNetwork.requestCategory();
      categorys = BWDatabase.getLocalCategory();
    }
    if (categorys.isEmpty) {
      MotionToast.error(description: const Text("分类数据请求异常,请检查网络"));
      return;
    }
    final selectCategoryId = categorys[selectCategoryIndex].categoryId;
    tags = BWDatabase.getLocalTag(selectCategoryId);
    if (tags.isEmpty || forceUpdate) {
      await BwNetwork.requestTag(selectCategoryId);
      tags = BWDatabase.getLocalTag(selectCategoryId);
    }
    if (tags.isEmpty) {
      MotionToast.error(description: const Text("标签数据请求异常,请检查网络"));
      return;
    }
    final selectTagId = tags[selectTagIndex].tagId;
    articles = BWDatabase.getLocalArticle(selectCategoryId, selectTagId);
    if (articles.isEmpty || forceUpdate) {
      BWDatabase.saveCursor(BWDatabaseCursor(defaultCursorType, selectCategoryId, selectTagId, currentSortType));
      await BwNetwork.requestArticle(defaultCursorType, currentSortType, selectCategoryId, selectTagId);
      articles = BWDatabase.getLocalArticle(selectCategoryId, selectTagId);
    } else if (isLoadMore) {
      BWDatabaseCursor cursor = BWDatabase.getLocalCursor(selectCategoryId, selectTagId, currentSortType);
      await BwNetwork.requestArticle(cursor.cursorId, currentSortType, selectCategoryId, selectTagId);
      articles = BWDatabase.getLocalArticle(selectCategoryId, selectTagId);
    }
    final recordIds = BWDatabase.getDeleteArticleRecords().map((e) => e.id);
    articles.removeWhere((element) => recordIds.contains(element.articleId));
    setState(() {
    });
    _refreshController.finishRefresh();
    if (isLoadMore) {
      _refreshController.finishLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    BWScreenWidth = MediaQuery.of(context).size.width;
    BWScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), height: 40, child:
            getListView(HomeViewType.category)),
            const Divider(height: 0.0, indent: 0.0, color: Colors.black26),
            Container(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), height: 40, color: const Color.fromARGB(1, 245, 245, 245), child:
            getListView(HomeViewType.tag)),
            const Divider(height: 0.0, indent: 0.0, color: Colors.black26),
            getContentListView()
          ],
        ),
      ),
    );
  }
}