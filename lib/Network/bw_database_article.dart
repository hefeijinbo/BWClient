import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class BWDatabaseArticle extends HiveObject {
  @HiveField(0)
  String articleId = "";
  @HiveField(1)
  var userId = "";
  @HiveField(2)
  String categoryId = "";
  @HiveField(3)
  List tagIds = [];
  @HiveField(4)
  int visibleLevel = 0;
  @HiveField(5)
  String linkUrl = "";
  @HiveField(6)
  String coverImage = "";
  @HiveField(7)
  int isGfw = 0;
  @HiveField(8)
  String title = "";
  @HiveField(9)
  String briefContent = "";
  @HiveField(10)
  var isEnglish = 0;
  @HiveField(11)
  var isOriginal = 0;
  @HiveField(12)
  var userIndex = 0;
  @HiveField(13)
  var originalType = 0;
  @HiveField(14)
  var originalAuthor = "";
  @HiveField(15)
  var content = "";
  @HiveField(16)
  var ctime = "";
  @HiveField(17)
  var mtime = "";
  @HiveField(18)
  var rtime = "";
  @HiveField(19)
  var draftId = "";
  @HiveField(20)
  var viewCount = 0;
  @HiveField(21)
  var collectCount = 0;
  @HiveField(22)
  var diggCount = 0;
  @HiveField(23)
  var commentCount = 0;
  @HiveField(24)
  var hotIndex = 0;
  @HiveField(25)
  var isHot = 0;
  @HiveField(26)
  var rankIndex = 0.0;
  @HiveField(27)
  var status = 0;
  @HiveField(28)
  var verifyStatus = 0;
  @HiveField(29)
  var auditStatus = 0;
  @HiveField(30)
  var markContent = "";
  @HiveField(31)
  var userName = "";
  @HiveField(32)
  var userInteract = "";
  @HiveField(33)
  var org = "";
  @HiveField(34)
  var reqId = 0;
  @HiveField(35)
  var pushStatus = 0;
  @HiveField(36)
  var tagId = "";

  void update(Map<String, dynamic> dic, String tagId) {
    this.tagId = tagId;
    articleId = dic["article_id"];
    var articleInfo = dic["article_info"];
    userId = articleInfo["user_id"];
    categoryId = articleInfo["category_id"];
    tagIds = articleInfo["tag_ids"];
    visibleLevel = articleInfo["visible_level"];
    linkUrl = articleInfo["link_url"];
    coverImage = articleInfo["cover_image"];
    isGfw = articleInfo["is_gfw"];
    title = articleInfo["title"];
    briefContent = articleInfo["brief_content"];
    isEnglish = articleInfo["is_english"];
    isOriginal = articleInfo["is_original"];
    // userIndex = articleInfo["user_index"];
    originalType = articleInfo["original_type"];
    originalAuthor = articleInfo["original_author"];
    content = articleInfo["content"];
    ctime = articleInfo["ctime"];
    mtime = articleInfo["mtime"];
    rtime = articleInfo["rtime"];
    draftId = articleInfo["draft_id"];
    viewCount = articleInfo["view_count"];
    collectCount = articleInfo["collect_count"];
    diggCount = articleInfo["digg_count"];
    commentCount = articleInfo["comment_count"];
    hotIndex = articleInfo["hot_index"];

    isHot = articleInfo["is_hot"];
    final value = articleInfo["rank_index"];
    if (value is int) {
      rankIndex = value.toDouble();
    } else {
      rankIndex = value;
    }
    status = articleInfo["status"];
    verifyStatus = articleInfo["verify_status"];
    auditStatus = articleInfo["audit_status"];
    markContent = articleInfo["mark_content"];
    userName = dic["author_user_info"]["user_name"];
  }
}

// Can be generated automatically
class ArticleAdapter extends TypeAdapter<BWDatabaseArticle> {
  @override
  final typeId = 2;

  @override
  BWDatabaseArticle read(BinaryReader reader) {
    final article = BWDatabaseArticle();
    article.articleId = reader.read();
    article.userId = reader.read();
    article.categoryId = reader.read();
    article.tagIds = reader.read();
    article.visibleLevel = reader.read();
    article.linkUrl = reader.read();
    article.coverImage = reader.read();
    article.isGfw = reader.read();
    article.title = reader.read();
    article.briefContent = reader.read();
    article.isEnglish = reader.read();
    article.isOriginal = reader.read();
    article.userIndex = reader.read();
    article.originalType = reader.read();
    article.originalAuthor = reader.read();
    article.content = reader.read();
    article.ctime = reader.read();
    article.mtime = reader.read();
    article.rtime = reader.read();
    article.draftId = reader.read();
    article.viewCount = reader.read();
    article.collectCount = reader.read();
    article.diggCount = reader.read();
    article.commentCount = reader.read();
    article.hotIndex = reader.read();

    article.isHot = reader.read();
    article.rankIndex = reader.read();
    article.status = reader.read();
    article.verifyStatus = reader.read();
    article.auditStatus = reader.read();
    article.markContent = reader.read();
    article.userName = reader.read();
    article.userInteract = reader.read();

    article.org = reader.read();
    article.reqId = reader.read();
    article.pushStatus = reader.read();
    article.tagId = reader.read();
    return article;
  }

  @override
  void write(BinaryWriter writer, BWDatabaseArticle obj) {
    writer.write(obj.articleId);
    writer.write(obj.userId);
    writer.write(obj.categoryId);
    writer.write(obj.tagIds);
    writer.write(obj.visibleLevel);
    writer.write(obj.linkUrl);
    writer.write(obj.coverImage);
    writer.write(obj.isGfw);
    writer.write(obj.title);
    writer.write(obj.briefContent);
    writer.write(obj.isEnglish);
    writer.write(obj.isOriginal);
    writer.write(obj.userIndex);
    writer.write(obj.originalType);
    writer.write(obj.originalAuthor);
    writer.write(obj.content);
    writer.write(obj.ctime);
    writer.write(obj.mtime);
    writer.write(obj.rtime);
    writer.write(obj.draftId);
    writer.write(obj.viewCount);
    writer.write(obj.collectCount);
    writer.write(obj.diggCount);
    writer.write(obj.commentCount);
    writer.write(obj.hotIndex);

    writer.write(obj.isHot);
    writer.write(obj.rankIndex);
    writer.write(obj.status);
    writer.write(obj.verifyStatus);
    writer.write(obj.auditStatus);
    writer.write(obj.markContent);
    writer.write(obj.userName);
    writer.write(obj.userInteract);

    writer.write(obj.org);
    writer.write(obj.reqId);
    writer.write(obj.pushStatus);
    writer.write(obj.tagId);
  }
}