import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

const String videoDirectory =
    '/Users/amitaskof/videos'; // Change this path to your actual video directory

Future<Response> echoRequest(Request request) async {
  switch (request.url.path) {
    case 'joke':
      return Response.ok(
        jsonDecode(
          (await http.get(Uri.parse("https://icanhazdadjoke.com/slack"))).body,
        )["attachments"][0]["text"],
      );
    case 'video':
      final videoName = request.url.queryParameters['name'];
      if (videoName == null) {
        return Response(400, body: 'Missing video name');
      }

      final file = File('$videoDirectory/$videoName');
      if (!await file.exists()) {
        return Response(404, body: 'Video not found');
      }

      final videoStream = file.openRead();
      return Response.ok(
        videoStream,
        headers: {HttpHeaders.contentTypeHeader: 'video/mp4'},
      );
  }
  return Response.ok('Request for "${request.url}"');
}
