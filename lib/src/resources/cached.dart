library restful.resource_cached;

import 'package:restful/src/formats.dart';
import 'package:restful/src/response_decorator.dart';
import 'package:restful/src/resources/resource.dart';

class CachedResource extends Resource {
  
  Map<String, RequestDecorator> cacheQuery = new Map<String, RequestDecorator>();
  Map<String, RequestDecorator> cacheFindAll = new Map<String, RequestDecorator>();
  Map<String, RequestDecorator> cacheFind = new Map<String, RequestDecorator>();
  
  //seconds
  int autoCacheInvalidate = 60;
  
  CachedResource(String uri, Format format) : super(uri, format);
  
  Resource nest(Object id, String resource) {
    var uri = this.uri.appendEach([id, resource]).toString();
    return new CachedResource(uri, this.format);
  }
   
  RequestDecorator find(Object id, [bool invalidate = false]) {
    var uri = this.uri.append(id.toString()).toString();
    if(hasCache(cacheFind, uri) && !invalidate) {
      return getCache(cacheFind, uri);
    }
    return request('get', uri);
  }
  
  RequestDecorator findAll([bool invalidate = false]) {
    if(hasCache(cacheFindAll, url) && !invalidate) {
      return getCache(cacheFindAll, url);
    }
    return request('get', url);
  }
  
  RequestDecorator query(Map<String, Object> params, [bool invalidate = false]) {
    var uri = this.uri.replaceParams(params).toString();
    if(hasCache(cacheQuery, uri) && !invalidate) {
      return getCache(cacheQuery, uri);
    } else {
      RequestDecorator req = request('get', uri);
      setCache(cacheQuery, uri, req);
      return req;
    }
  }
  
  bool hasCache(Map<String, RequestDecorator> cache, String name) {
    return cache.containsKey(name);
  }
  
  RequestDecorator getCache(Map<String, RequestDecorator> cache, String name) {
    RequestDecorator rd = cache.remove(name);
    cache.putIfAbsent(name, () => rd);
    return rd;
  }
  
  void setCache(Map<String, RequestDecorator> cache, String name, RequestDecorator req) {
    req.cacheTimestamp = new DateTime.now().millisecondsSinceEpoch;
    cache.putIfAbsent(name, () => req);
  }
  
}