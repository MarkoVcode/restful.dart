library restfulplus.rest_api;

import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/resources/ramcached.dart';
import 'package:restfulplus/src/resources/noncached.dart';
import 'package:restfulplus/src/uri_helper.dart';

class RestApi {

  final String apiUri;
  final Format format;

  RestApi(this.apiUri, this.format);

  RamCachedResource ramCachedResource(String name, [int autoInvalidateTimeout = 9999999999]) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    return new RamCachedResource(uri, format, autoInvalidateTimeout);
  }

  NonCachedResource nonCachedResource(String name) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    return new NonCachedResource(uri, format);
  }

}
