library restful.resource_abstract;

import 'dart:html';
import 'dart:async';
import 'package:restful/src/request_helper.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/uri_helper.dart';
import 'package:restful/src/response_decorator.dart';

abstract class Resource {
  String url;
  Format format;
  
  UriHelper uri;
   
  Resource(this.url, this.format) {
    uri = new UriHelper.from(url);
  }
    
  Future<RestRequest> request(String method, String url, [Object data]) {
    RequestHelper request = new RequestHelper(method, url, format);
    return request.send(data);
  }
  
  Object _deserialize(HttpRequest request) {
    return format.deserialize(request.responseText);
  }
  
  Future<RestRequest> save([Map<String, Object> params]) {
    params = params != null ? params : {};
    return request('post', url, params);
  }
  
  Future<RestRequest> clear() {
    return request('delete', url);
  }
  
  Future<RestRequest> delete(Object id) {
    var uri = this.uri.append(id.toString()).toString();
    return request('delete', uri);
  }
  
  Future<RestRequest> create(Object id, Map<String, Object> params) {
    var uri = this.uri.append(id).toString();
    return request('put', uri, params);
  }
}