import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/gif_model.dart';

class GifPickerRepo {
  Future<List<GifModel>> getTrending() async {
    var response = await http.get(
      Uri.parse('https://g.tenor.com/v1/trending?key=LIVDSRZULELA&limit=50'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body)['results'] as List)
          .map((e) => GifModel.fromJson({
                "url": e['media'][0]['gif']['url'],
                "tenor_id": e["id"],
                "content_description": e["content_description"],
                "preview_url": e["media"][0]["tinygif"]["url"],
                "dims": {'data': e['media'][0]["gif"]["dims"]},
              }))
          .toList();
    } else {
      throw Exception("Invalid status code: ${response.statusCode}");
    }
  }

  Future<List<GifModel>> getSerachResult(String text) async {
    var response = await http.get(
      Uri.parse(
          'https://g.tenor.com/v1/search?q=$text&key=LIVDSRZULELA&limit=50'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body)['results'] as List)
          .map((e) => GifModel.fromJson({
                "url": e['media'][0]['gif']['url'],
                "tenor_id": e["id"],
                "content_description": e["content_description"],
                "preview_url": e["media"][0]["tinygif"]["url"],
                "dims": {'data': e['media'][0]["gif"]["dims"]},
              }))
          .toList();
    } else {
      throw Exception("Invalid status code: ${response.statusCode}");
    }
  }
}
