library restful.resource_non_cached;

import 'dart:async';
import 'package:restful/src/formats.dart';
import 'package:restful/src/response_decorator.dart';
import 'package:restful/src/resources/resource.dart';

class NonCachedResource extends Resource {
  
  NonCachedResource(String uri, Format format) : super(uri, format);
  
  Resource nest(Object id, String resource) {
    var uri = this.uri.appendEach([id, resource]).toString();
    return new NonCachedResource(uri, this.format);
  }
   
  Future<RestRequest> find(Object id) {
    var uri = this.uri.append(id.toString()).toString();
    return request('get', uri);
  }
  
  Future<RestRequest> findAll() {
    return request('get', url);
  }
  
  Future<RestRequest> query(Map<String, Object> params) {
    var uri = this.uri.replaceParams(params).toString();
    return request('get', uri);
  }
  
}