// ignore_for_file: avoid_dynamic_calls

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response.json(
    body: {
      'status': 'OK',
    },
  );
}
