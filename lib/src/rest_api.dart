library restful.rest_api;

import 'package:restful/src/formats.dart';
import 'package:restful/src/resources/ramcached.dart';
import 'package:restful/src/resources/noncached.dart';
import 'package:restful/src/uri_helper.dart';

class RestApi {
  final String apiUri;
  final Format format;
  
  RestApi(this.apiUri, this.format);
  
  RamCachedResource cachedResource(String name, [int autoInvalidateTimeout= 60000]) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    return new RamCachedResource(uri, format, autoInvalidateTimeout);
  }
  
  NonCachedResource nonCachedResource(String name) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    return new NonCachedResource(uri, format);
  }

}