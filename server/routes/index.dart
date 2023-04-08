// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response.json(body: {'message': 'Hello World!'});
}
