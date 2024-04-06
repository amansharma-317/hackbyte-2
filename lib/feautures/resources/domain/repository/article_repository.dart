import 'package:hackbyte2/feautures/resources/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<List<ArticleEntity>> getArticles();
}