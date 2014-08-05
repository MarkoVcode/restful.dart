library restfulplus.response_decorator;

import 'dart:html';

class RestRequest {
  final String url;
  final String method;
  int cacheTimestamp = 0;
  final Object data;
  final HttpRequest request;
  Object unserialized;
  final bool error;

  RestRequest(this.method, this.url, this.data, this.request, [bool this.error = false]);
 
  Object getData() {
    return unserialized;
  }

  void setDataObject(Object obj) {
    unserialized = obj;
  }

  void setCacheTimestamp(int ts) {
    cacheTimestamp = ts;
  }

  int getCacheTimestamp() {
    return cacheTimestamp;
  }

  bool hasError() {
    return error;
  }
}
