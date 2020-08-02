import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  // We'll create a local server that will be listening for requests at port 8082
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest req in server) {
    // All requests will be logged into a local 'logs.tmp' file
    final File file = File('./logs.tmp');

    // Parse the requests and write them in the File
    String content = await utf8.decoder.bind(req).join();
    var data = "\n${content.replaceAll("\"", "")}";
    file.writeAsStringSync(data, mode: FileMode.writeOnlyAppend);

    // Answer back 200OK
    req.response..statusCode = HttpStatus.ok;
    await req.response.close();
  }
}
