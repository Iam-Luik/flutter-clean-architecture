import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/datalayer/http/http.dart';
import 'package:test/test.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map>? request(
      {required String url, required String method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('post', () {
    When mockRequest() =>
        when(() => client.post(any(), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });
    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url), headers: any(named: 'headers')));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url), headers: any(named: 'headers')));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 without data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
