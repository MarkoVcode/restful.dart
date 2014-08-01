library restfulplus.tests.rest_api;

import 'package:unittest/unittest.dart';
import 'package:restfulplus/src/rest_api.dart';
import 'package:restfulplus/src/formats.dart';

void testRestApi() {
  group("RestApi", () {
    RestApi restApi;

    setUp(() {
      restApi = new RestApi("http://www.example.com", JSON_FORMAT);
    });

    test("should append resource name", () {
      var resource = restApi.nonCachedResource('users');
      expect(resource.url, equals("http://www.example.com/users"));
    });
  });
}
