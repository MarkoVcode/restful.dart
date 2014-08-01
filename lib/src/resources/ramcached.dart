library restfulplus.resource_ram_cached;

import 'dart:async';
import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/response_decorator.dart';
import 'package:restfulplus/src/resources/resource.dart';

class RamCachedResource extends Resource {

  Map<String, RestRequest> cache = new Map<String, RestRequest>();

  //miliseconds
  int autoCacheInvalidate;

  RamCachedResource(String uri, Format format, int timeout) : super(uri, format) {
    autoCacheInvalidate = timeout;
  }

  Resource nest(Object id, String resource) {
    var uri = this.uri.appendEach([id, resource]).toString();
    return new RamCachedResource(uri, this.format, this.autoCacheInvalidate);
  }

  Future<RestRequest> find(Object id, [bool invalidate = false]) {
    var uri = this.uri.append(id.toString()).toString();
    if (hasCache(uri) && !invalidate) {
      return getCache(uri);
    }
    return request('get', uri).then((rd) => setCache(uri, rd));
  }

  Future<RestRequest> findAll([bool invalidate = false]) {
    if (hasCache(url) && !invalidate) {
      return getCache(url);
    } else {
      return request('get', url).then((rd) => setCache(url, rd));
    }
  }

  Future<RestRequest> query(Map<String, Object> params, [bool invalidate = false]) {
    var uri = this.uri.replaceParams(params).toString();
    if (hasCache(uri) && !invalidate) {
      return getCache(uri);
    } else {
      Future<RestRequest> futureRequest = request('get', uri);
      futureRequest.then((rd) => setCache(uri, rd));
      return futureRequest;
    }
  }

  bool hasCache(String name) {
    if (cache.containsKey(name)) {
      RestRequest rd = cache.remove(name);
      if ((rd.getCacheTimestamp() + autoCacheInvalidate) > new DateTime.now().millisecondsSinceEpoch) {
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

  RestRequest setCache(String name, RestRequest req) {
    req.setCacheTimestamp(new DateTime.now().millisecondsSinceEpoch);
    cache.putIfAbsent(name, () => req);
    return req;
  }

}
