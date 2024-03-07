import 'dart:convert';

import 'package:drrr/src/utils/request/cookie_jar.dart';
import 'package:http/http.dart' as http;

class RequestOption {
  final String baseUrl;
  final double timeout;
  final CookieJar? cookieJar;

  RequestOption({
    this.baseUrl = "",
    this.timeout = 30,
    this.cookieJar,
  });

  RequestOption merge(RequestOption? other) {
    if (other == null) {
      return this;
    }
    return RequestOption(
      baseUrl: other.baseUrl != "" ? other.baseUrl : baseUrl,
      timeout: other.timeout != 0 ? other.timeout : timeout,
      cookieJar: other.cookieJar ?? cookieJar,
    );
  }

  Future<void> setCookie(http.Response response) async {
    if (cookieJar != null) {
      await cookieJar!.setCookie(response);
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class Response {
  http.Response response;
  String body;

  Response({
    required this.response,
    this.body = "",
  }) {
    body = utf8.decode(response.bodyBytes);
  }

  bool get ok => response.statusCode >= 200 && response.statusCode < 300;
}

class Request {
  RequestOption option;

  Request({required this.option});

  Future<Map<String, String>?> getHeader() async {
    var header = {
      "User-Agent":
          "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; DRRR-AI/1.0",
      "X-App-Version": "1.0.0",
      "X-Package": "ai.drrr.p",
      "X-Channel": "google",
      "X-Device-Id": "1234567890",
    };

    if (option.cookieJar != null) {
      var cookie = await option.cookieJar!.getCookie();
      if (cookie.isNotEmpty) {
        header["Cookie"] = cookie;
      }
    }
    return header;
  }

  String encodeQuery(Map<String, dynamic>? query) {
    if (query == null) {
      return "";
    }
    var queryString = "";
    query.forEach((key, value) {
      if (queryString.isNotEmpty) {
        queryString += "&";
      }
      queryString += Uri.encodeQueryComponent(key);
      queryString += "=";
      queryString += Uri.encodeQueryComponent(value.toString());
    });
    return queryString;
  }

  Map<String, String> encodeBody(Map<String, dynamic>? body) {
    if (body == null) {
      return {};
    }
    Map<String, String> bodyString = {};
    body.forEach((key, value) {
      bodyString[key] = value.toString();
    });
    return bodyString;
  }

  String getUrl(String path, {Map<String, dynamic>? query}) {
    var queryString = encodeQuery(query);
    var url = option.baseUrl + path;
    if (queryString.isNotEmpty) {
      url += "?$queryString";
    }
    return url;
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      var response = await http
          .get(Uri.parse(getUrl(path, query: query)),
              headers: await getHeader())
          .timeout(Duration(seconds: option.timeout.toInt()), onTimeout: () {
        return Future.error(TimeoutException("Request timeout"));
      });
      await option.setCookie(response);
      return Response(response: response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? body}) async {
    try {
      var response = await http
          .post(Uri.parse(option.baseUrl + path),
              body: encodeBody(body), headers: await getHeader())
          .timeout(Duration(seconds: option.timeout.toInt()), onTimeout: () {
        return Future.error(TimeoutException("Request timeout"));
      });
      await option.setCookie(response);
      return Response(response: response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? body}) async {
    try {
      var response = await http
          .put(Uri.parse(option.baseUrl + path),
              body: encodeBody(body), headers: await getHeader())
          .timeout(Duration(seconds: option.timeout.toInt()), onTimeout: () {
        return Future.error(TimeoutException("Request timeout"));
      });
      await option.setCookie(response);
      return Response(response: response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? query}) async {
    try {
      var response = await http
          .delete(Uri.parse(getUrl(path, query: query)),
              headers: await getHeader())
          .timeout(Duration(seconds: option.timeout.toInt()), onTimeout: () {
        return Future.error(TimeoutException("Request timeout"));
      });
      await option.setCookie(response);
      return Response(response: response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> patch(String path, {Map<String, dynamic>? body}) async {
    try {
      var response = await http
          .patch(Uri.parse(option.baseUrl + path),
              body: encodeBody(body), headers: await getHeader())
          .timeout(Duration(seconds: option.timeout.toInt()), onTimeout: () {
        return Future.error(TimeoutException("Request timeout"));
      });
      await option.setCookie(response);
      return Response(response: response);
    } catch (e) {
      return Future.error(e);
    }
  }
}
