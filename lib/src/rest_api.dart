library restful.rest_api;

import 'package:restful/src/formats.dart';
import 'package:restful/src/resources/resource.dart';
import 'package:restful/src/resources/cached.dart';
import 'package:restful/src/resources/noncached.dart';
import 'package:restful/src/uri_helper.dart';

class RestApi {
  final String apiUri;
  final Format format;
  final bool cached;
  
  RestApi(this.apiUri, this.format, this.cached);
  
  Resource resource(String name) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    if(this.cached) {
      return new CachedResource(uri, format);
    } else {
      return new NonCachedResource(uri, format);
    }
  }
}