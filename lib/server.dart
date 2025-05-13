// import 'dart:developer';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void runServer() async {
  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', 11690);

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request) {
  // log(request.url.path);
  // switch (request.url.path) {}
  return Response.ok('Request for "${request.url}"');
}
