// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:server/supabase.dart';

Future<Response> onRequest(RequestContext context) async {
  final page = context.request.uri.queryParameters['page'] ?? '0';
  final rows = await supabase
      .from('tweets')
      .select('*')
      .limit(10)
      .order('posted_at', ascending: true);

  return Response.json(
    body: rows.data,
  );
}
