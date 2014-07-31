library restful.request_helper;

import 'dart:html';
import 'package:logging/logging.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/response_decorator.dart';

typedef HttpRequest RequestFactory();

/// Allows for mocking an HTTP request for testing.
RequestFactory httpRequestFactory = () => new HttpRequest();

class RequestHelper {

  final String url;
  final String method;
  final Format format;

  RequestHelper(this.method, this.url, this.format);

  RequestHelper.get(this.url, this.format) : method = 'get';

  RequestHelper.post(this.url, this.format) : method = 'post';

  RequestHelper.put(this.url, this.format) : method = 'put';

  RequestHelper.delete(this.url, this.format) : method = 'delete';

  RequestDecorator send([Object data]) {
    RequestDecorator requestDecorator = null;
    var request = httpRequestFactory();
    var serializedData = data != null ? format.serialize(data) : null;
    request.open(method, url);

    if (method != 'get') {
      request.setRequestHeader('Content-Type', format.contentType);
    }
    request.setRequestHeader('Accept', format.contentType);
    request.onLoad.listen((event) {
      requestDecorator = new RequestDecorator(method, url, serializedData, request);
    });
    request.onError.listen((event) {
      requestDecorator = new RequestDecorator(method, url, serializedData, request);
    });
    
    if (serializedData != null) {
      request.send(serializedData);
    } else {
      request.send();
    }
    return requestDecorator;
  }
}

Logger _logger = new Logger("restful.request_helper");