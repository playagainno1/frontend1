import 'package:drrr/src/model/model.dart';
import 'package:drrr/src/utils/persistent/persistent_storage.dart';
import 'package:drrr/src/utils/request/cookie_jar.dart';

var _persistentStorage = PersistentStorage();

var persistentCookieJar = PersistentCookieJar();

Future<void> setDeviceId(String deviceId) async {
  await _persistentStorage.set("deviceId", deviceId);
}

Future<String> getDeviceId() async {
  return await _persistentStorage.get("deviceId");
}

Future<void> removeDeviceId() async {
  await _persistentStorage.remove("deviceId");
}

Future<void> setUsername(String username) async {
  await _persistentStorage.set("username", username);
}

Future<String> getUsername() async {
  return await _persistentStorage.get("username");
}

Future<void> removeUsername() async {
  await _persistentStorage.remove("username");
}

Future<void> setEmail(String email) async {
  await _persistentStorage.set("email", email);
}

Future<String> getEmail() async {
  return await _persistentStorage.get("email");
}

Future<void> removeEmail() async {
  await _persistentStorage.remove("email");
}

Future<User> getUser() async {
  var username = await getUsername();
  var email = await getEmail();
  var deviceId = await getDeviceId();
  return User(
    username: username,
    email: email,
    deviceId: deviceId,
  );
}

Future<String> getSessionId() async {
  await persistentCookieJar.getCookie();
  var sessionId =
      persistentCookieJar.memoryCookieJar.cookies["SESSIONID"] ?? "";
  return sessionId;
}

Future<void> removeSessionId() async {
  persistentCookieJar.memoryCookieJar.cookies.remove("SESSIONID");
  await persistentCookieJar.clearCookie();
}
