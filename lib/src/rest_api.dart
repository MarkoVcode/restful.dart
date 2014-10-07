library restfulplus.rest_api;

import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/resources/ramcached.dart';
import 'package:restfulplus/src/resources/noncached.dart';

class RestApi {

  final String apiUri;
  final Format format;

  RestApi(this.apiUri, this.format);

  RamCachedResource ramCachedResource(String name, [int autoInvalidateTimeout = 9999999999]) {
    var uri = Uri.parse(apiUri);
    var path = uri.pathSegments.toList()..addAll(name.split("/"));
    uri = uri.replace(pathSegments: path, port: uri.port);
    return new RamCachedResource(uri.toString(), format, autoInvalidateTimeout);
  }

  NonCachedResource nonCachedResource(String name) {
    var uri = Uri.parse(apiUri);
    var path = uri.pathSegments.toList()..addAll(name.split("/"));
    uri = uri.replace(pathSegments: path, port: uri.port);
    return new NonCachedResource(uri.toString(), format);
  }

}
