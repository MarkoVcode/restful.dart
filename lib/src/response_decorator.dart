library restful.response_decorator;
import 'dart:html';

class RestRequest {
  final String url;
  final String method;
  int cacheTimestamp = 0;
  final Object data;
  final HttpRequest request;
  Object unserialized;

  RestRequest(this.method, this.url, this.data, this.request);
  
  Object getData() {
    return unserialized;
  }
  
  void setDataObject(Object obj) {
    unserialized = obj;
  }
}