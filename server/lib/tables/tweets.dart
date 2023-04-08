// ignore_for_file: public_member_api_docs, sort_constructors_first

class Tweets {
  static String tableName = 'tweets';
  static String id = 'id';
  static String authorId = 'author_id';
  static String content = 'content';
  static String scrapedAt = 'scraped_at';
  static String postedAt = 'posted_at';
  static String publicMetrics = 'public_metrics';
  static String media = 'media';
  static String polls = 'polls';

  static String createTable = '''
    CREATE IF NOT EXISTS TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $authorId TEXT,
      $content TEXT,
      $media TEXT,
      $publicMetrics TEXT,
      $postedAt TIMESTAMP,
      $scrapedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    );
  ''';

  static String dropTable = '''
    DROP TABLE IF EXISTS $tableName;
  ''';

  static String insert = '''
    INSERT INTO $tableName (
      $id,
      $authorId,
      $content,
      $media,
      $publicMetrics,
      $postedAt,
      $scrapedAt
    ) VALUES (?, ?, ?, ?, ?, ?, ?);
  ''';
}
