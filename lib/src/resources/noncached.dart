library restfulplus.resource_non_cached;

import 'dart:async';
import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/response_decorator.dart';
import 'package:restfulplus/src/resources/resource.dart';

class NonCachedResource extends Resource {

  NonCachedResource(String uri, Format format) : super(uri, format);

  Resource nest(Object id, String resource) {
    //var uri = this.uri.appendEach([id, resource]).toString();
    var path = ouri.pathSegments.toList()..add(id.toString());
    var uri = ouri.replace(pathSegments: path, port: ouri.port).toString();
    return new NonCachedResource(uri, this.format);
  }

  Future<RestRequest> find(Object id) {
    //var uri = this.uri.append(id.toString()).toString();
    var path = ouri.pathSegments.toList()..add(id.toString());
    var uri = ouri.replace(pathSegments: path, port: ouri.port).toString();
    return request('get', uri);
  }

  Future<RestRequest> findAll() {
    return request('get', url);
  }

  Future<RestRequest> query(Map<String, Object> params) {
    //var uri = this.uri.replaceParams(params).toString();
    var path = ouri.pathSegments.toList()..add(id.toString());
    var uri = ouri.replace(pathSegments: path, port: ouri.port).toString();
    return request('get', uri);
  }

}
