import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

const String videoDirectory = 'C:/Users/Robotica';

Future<Response> echoRequest(Request request) async {
  switch (request.url.path) {
    case 'help':
    case '':
      return Response.ok('Available endpoints: /joke, /video?name=videoName, /videos');

    case 'joke':
      final jokeResponse = await http.get(Uri.parse("https://icanhazdadjoke.com/slack"), headers: {'Accept': 'application/json'});
      final joke = jsonDecode(jokeResponse.body)["attachments"][0]["text"];
      return Response.ok(joke);

    case "videos":
      final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
      final files = await Directory(videoDirectory).list().toList();
      final videoFiles =
          files
              .whereType<File>()
              .where((file) => videoExtensions.any((ext) => file.path.toLowerCase().endsWith(ext)))
              .map((file) => file.path.split('\\').last)
              .toList();
      return Response.ok(jsonEncode(videoFiles), headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType});

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
      return Response.ok(videoStream, headers: {HttpHeaders.contentTypeHeader: 'video/mp4'});
  }

  return Response.notFound('Request for "${request.url}" not found');
}
