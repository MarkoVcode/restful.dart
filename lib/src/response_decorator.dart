library restful.response_decorator;
import 'dart:html';

class RequestDecorator {
  final String url;
  final String method;
  int cacheTimestamp = 0;
  final Object data;
  final HttpRequest request;

  RequestDecorator(this.method, this.url, this.data, this.request);
}