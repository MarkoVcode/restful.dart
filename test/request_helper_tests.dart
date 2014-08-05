library restfulplus.tests.request;

import 'package:unittest/unittest.dart';
import 'package:restfulplus/src/request_helper.dart';
import 'package:restfulplus/src/formats.dart';
import 'package:mock/mock.dart';
import 'request_mock.dart';

void testRequests() {
  group("Request", () {
    HttpRequestMock httpRequest;

    setUp(() {
      httpRequest = new HttpRequestMock();
      httpRequestFactory = () => httpRequest;
    });

    test("should set header's Content-Type on POST requests", () {
      var request = new RequestHelper.post('url', JSON_FORMAT);
      request.send().then(expectAsync((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      }));
    });

    test("should set header's Content-Type on PUT requests", () {
      new RequestHelper.put('url', JSON_FORMAT).send().then(expectAsync((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      }));
    });

    test("should not set header's Content-Type on GET requests", () {
      new RequestHelper.get('url', JSON_FORMAT).send().then(expectAsync((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(neverHappened);
      }));
    });

    group("with an error status", () {
      setUp(() {
        httpRequest.status = 500;
      });

      test("should't fail", () {
        new RequestHelper.get('url', JSON_FORMAT).send().then(expectAsync((responseDecorator) {
          expect(responseDecorator.request.status, equals(500));
        }));
      });
    });
  });
}
