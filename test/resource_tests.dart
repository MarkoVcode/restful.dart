library restfulplus.tests.resource;

import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:restfulplus/src/resources/noncached.dart';
import 'package:restfulplus/src/formats.dart';
import 'package:restfulplus/src/request_helper.dart';
import 'package:mock/mock.dart';
import 'request_mock.dart';

void testResource() {
  group("RestResource", () {

    NonCachedResource resource;
    HttpRequestMock request;

    setUp(() {
      resource = new NonCachedResource("http://www.example.com/users", JSON_FORMAT);

      request = new HttpRequestMock();
      httpRequestFactory = () => request;
    });

    test("should append subresource names", () {
      var subresource = resource.nest(1, 'posts');
      expect(subresource.url, equals("http://www.example.com/users/1/posts"));
    });

    group("clear", () {
      test("should send 'DELETE' to correct URL", () {
        resource.clear().then(expectAsync((json) {
          request.getLogs(callsTo('open', 'delete', 'http://www.example.com/users')).verify(happenedOnce);
        }));
      });

      test("should deserialize response", () {
        var response = true;
        request.responseText = JSON.encode(response);

        resource.clear().then(expectAsync((json) {
          expect(json, equals(response));
        }));
      });
    });

    group("create", () {
      test("should send 'POST' to correct URL", () {
        resource.create({
          'name': 'Jimmy Page'
        }).then(expectAsync((json) {
          request.getLogs(callsTo('open', 'post', 'http://www.example.com/users')).verify(happenedOnce);
        }));
      });

      test("should serialize request data", () {
        var data = {
          'name': 'Jimmy Page'
        };
        resource.create(data).then(expectAsync((json) {
          request.getLogs(callsTo('send', resource.format.serialize(data))).verify(happenedOnce);
        }));
      });

      test("should deserialize response", () {
        var response = {
          'id': 1,
          'name': 'Jimmy Page'
        };
        request.responseText = JSON.encode(response);

        resource.create(new Map.from(response)..remove('id')).then(expectAsync((json) {
          expect(json, equals(response));
        }));
      });
    });

    group("delete", () {
      test("should send 'DELETE' to correct URL", () {
        resource.delete(1).then(expectAsync((json) {
          request.getLogs(callsTo('open', 'delete', 'http://www.example.com/users/1')).verify(happenedOnce);
        }));
      });

      test("should deserialize response", () {
        var response = {
          'success': true
        };
        request.responseText = JSON.encode(response);

        resource.delete(1).then(expectAsync((json) {
          expect(json, equals(response));
        }));
      });
    });   
    
    group("find", () {
      test("should send 'GET' to correct URL", () {
        resource.find(1).then(expectAsync((json) {
          request.getLogs(callsTo('open', 'get', 'http://www.example.com/users/1')).verify(happenedOnce);
        }));
      });

      test("should deserialize response", () {
        var response = {
          'id': 1,
          'name': 'Jimmy Page'
        };
        request.responseText = JSON.encode(response);

        resource.find(1).then(expectAsync((json) {
          expect(json, equals(response));
        }));
      });
    });

    group("findAll", () {
       test("should send 'GET' to correct URL", () {
         resource.findAll().then(expectAsync((json) {
           request.getLogs(callsTo('open', 'get', 'http://www.example.com/users')).verify(happenedOnce);
         }));
       });

       test("should deserialize response", () {
         var response = [{
             'id': 1,
             'name': 'Jimmy Page'
           }, {
             'id': 2,
             'name': 'David Gilmour'
           }];
         request.responseText = JSON.encode(response);

         resource.find(1).then(expectAsync((json) {
           expect(json, equals(response));
         }));
       });
     });

     group("query", () {
       test("should send 'GET' to correct URL", () {
         resource.query({
           'param1': 'value1'
         }).then(expectAsync((json) {
           request.getLogs(callsTo('open', 'get', 'http://www.example.com/users?param1=value1')).verify(happenedOnce);
         }));
       });

       test("should deserialize response", () {
         var response = [{
             'id': 1,
             'name': 'Jimmy Page'
           }, {
             'id': 2,
             'name': 'David Gilmour'
           }];
         request.responseText = JSON.encode(response);

         resource.query({
           'param1': 'value1'
         }).then(expectAsync((json) {
           expect(json, equals(response));
         }));
       });
     });

     group("save", () {
       test("should send 'PUT' to correct URL", () {
         resource.save(1, {
           'name': 'David Gilmour'
         }).then(expectAsync((json) {
           request.getLogs(callsTo('open', 'put', 'http://www.example.com/users/1')).verify(happenedOnce);
         }));
       });

       test("should serialize request data", () {
         var data = {
           'name': 'David Gilmour'
         };
         resource.save(1, data).then(expectAsync((json) {
           request.getLogs(callsTo('send', resource.format.serialize(data))).verify(happenedOnce);
         }));
       });

       test("should deserialize response", () {
         var response = {
           'id': 1,
           'name': 'Jimmy Page'
         };
         request.responseText = JSON.encode(response);

         resource.save(1, {
           'param1': 'value1'
         }).then(expectAsync((json) {
           expect(json, equals(response));
         }));
       });
     });
    
  });
}
