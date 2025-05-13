import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void runServer() async {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request) =>
    Response.ok('Request for "${request.url}"');

bool isServerRunning() {
  try {
    ServerSocket.bind('localhost', 8080).then((socket) {
      socket.close();
    });
    return false;
  } catch (_) {
    return true;
  }
}
