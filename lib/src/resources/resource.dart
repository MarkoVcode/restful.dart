library restfulplus.resource_abstract;

import 'dart:async';
import 'package:restfulplus/src/request_helper.dart';
import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/uri_helper.dart';
import 'package:restfulplus/src/response_decorator.dart';

abstract class Resource {

  String url;
  Format format;

  UriHelper uri;

  Resource(this.url, this.format) {
    uri = new UriHelper.from(url);
  }

  Future<RestRequest> request(String method, String url, [Object data]) {
    RequestHelper request = new RequestHelper(method, url, format);
    return (data != null ? request.send(data) : request.send()).then(_deserialize);
  }

  RestRequest _deserialize(RestRequest rrequest) {
    rrequest.setDataObject(format.deserialize(rrequest.request.responseText));
    return rrequest;
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
