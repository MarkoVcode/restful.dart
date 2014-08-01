library restful.resource_cached;

import 'dart:async';
import 'package:restful/src/formats.dart';
import 'package:restful/src/response_decorator.dart';
import 'package:restful/src/resources/resource.dart';

class CachedResource extends Resource {
  
  Map<String, RestRequest> cache = new Map<String, RestRequest>();
  
  //m seconds
  int autoCacheInvalidate = 60000;
  
  void setAutoCacheInvalidate(int autoCacheInvalidate_ms) {
    autoCacheInvalidate = autoCacheInvalidate_ms;
  }
  
  CachedResource(String uri, Format format) : super(uri, format);

  Resource nest(Object id, String resource) {
    var uri = this.uri.appendEach([id, resource]).toString();
    return new CachedResource(uri, this.format);
  }
   
  Future<RestRequest> find(Object id, [bool invalidate = false]) {
    var uri = this.uri.append(id.toString()).toString();
    if(hasCache(uri) && !invalidate) {
      return getCache(uri);
    }
    return request('get', uri);
  }
  
  Future<RestRequest> findAll([bool invalidate = false]) {
    if(hasCache(url) && !invalidate) {
      return getCache(url);
    } else {
      Future<RestRequest> futureRequest = request('get', url);
      futureRequest.then((rd) => setCache(url, rd));
      return futureRequest;
    }
  }
  
  Future<RestRequest> query(Map<String, Object> params, [bool invalidate = false]) {
    var uri = this.uri.replaceParams(params).toString();
    if(hasCache(uri) && !invalidate) {
      return getCache(uri);
    } else {
      Future<RestRequest> futureRequest = request('get', uri);
      futureRequest.then((rd) => setCache(uri, rd));
      return futureRequest;
    }
  }
  
  bool hasCache(String name) {
    if(cache.containsKey(name)) {
      RestRequest rd = cache.remove(name);
      if((rd.cacheTimestamp + autoCacheInvalidate) > new DateTime.now().millisecondsSinceEpoch) {
        cache.putIfAbsent(name, () => rd);
        return true;
      }
    } 
    return false;
  }
  
  Future<RestRequest> getCache(String name) {
    RestRequest rd = cache.remove(name);
    cache.putIfAbsent(name, () => rd);
    return new Future.value(rd);
  }
  
  void setCache(String name, RestRequest req) {
    req.cacheTimestamp = new DateTime.now().millisecondsSinceEpoch;
    cache.putIfAbsent(name, () => req);
  }
  
}