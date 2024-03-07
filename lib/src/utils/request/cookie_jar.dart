import 'dart:convert';

import 'package:drrr/src/utils/persistent/persistent_storage.dart';
import 'package:http/http.dart' as http;

abstract class CookieJar {
  Future<void> setCookie(http.Response response);
  Future<String> getCookie();
  Future<void> clearCookie();
}

class PersistentCookieJar implements CookieJar {
  final MemoryCookieJar memoryCookieJar = MemoryCookieJar();
  final PersistentStorage persistentStorage = PersistentStorage();
  bool isLoaded = false;

  PersistentCookieJar();

  @override
  Future<void> setCookie(http.Response response) async {
    await memoryCookieJar.setCookie(response);
    await _persistentCookie();
  }

  @override
  Future<String> getCookie() async {
    String cookie = await memoryCookieJar.getCookie();
    if (cookie.isNotEmpty) {
      return cookie;
    }
    if (!isLoaded) {
      await _loadCookie();
      isLoaded = true;
    }
    return memoryCookieJar.getCookie();
  }

  @override
  Future<void> clearCookie() async {
    await memoryCookieJar.clearCookie();
    await persistentStorage.remove("cookie");
  }

  Future<void> _loadCookie() async {
    var s = await persistentStorage.get("cookie");
    try {
      jsonDecode(s).forEach((key, value) {
        memoryCookieJar.cookies[key] = value;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _persistentCookie() async {
    await persistentStorage.set("cookie", jsonEncode(memoryCookieJar.cookies));
  }
}

class MemoryCookieJar implements CookieJar {
  Map<String, String> cookies = {};

  @override
  Future<void> setCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];
    if (allSetCookie == null) {
      return Future.value();
    }

    var setCookies = allSetCookie.split(',');

    for (var setCookie in setCookies) {
      var cookies = setCookie.split(';');

      for (var cookie in cookies) {
        _setCookie(cookie);
      }
    }
    return Future.value();
  }

  @override
  Future<String> getCookie() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += "$key=${cookies[key]!}";
    }

    return Future.value(cookie);
  }

  @override
  Future<void> clearCookie() {
    cookies.clear();
    return Future.value();
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.isEmpty) {
      return;
    }
    var keyValue = splitWithLimit(rawCookie, '=', 2);
    if (keyValue.length == 2) {
      var originalKey = keyValue[0].trim();
      var key = originalKey.toLowerCase();
      var value = keyValue[1].trim();

      var isCookieName = key != 'path' &&
          key != 'domain' &&
          key != 'expires' &&
          key != 'max-age' &&
          key != 'samesite';

      if (isCookieName) {
        cookies[originalKey] = value;
      }
    }
  }
}

List<String> splitWithLimit(String input, String separator, int limit) {
  List<String> result = [];
  List<String> parts = input.split(separator);
  if (parts.length <= limit) {
    result = parts;
  } else {
    result.addAll(parts.getRange(0, limit - 1));
    result.add(parts.getRange(limit - 1, parts.length).join(separator));
  }
  return result;
}
