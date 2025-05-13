import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

Future<Response> echoRequest(Request request) async {
  switch (request.url.path) {
    case 'joke':
      return Response.ok(
        jsonDecode((await http.get(Uri.parse("https://icanhazdadjoke.com/slack"))).body)["attachments"][0]["text"],
      );
  }
  return Response.ok('Request for "${request.url}"');
}
