import 'dart:math';

// random returns a random integer between m and n.
int random(int m, int n) {
  Random random = Random();
  int randomNumber = m + random.nextInt(n - m + 1);
  return randomNumber;
}

bool isEmail(String s) {
  RegExp regExp = RegExp(
    r"^\S+@[a-zA-Z0-9_-]+\.[a-zA-Z]{2,7}$",
    caseSensitive: false,
    multiLine: false,
  );
  return regExp.hasMatch(s);
}

Map<String, String> dynamicToStringMap(Map<String, dynamic>? dynamicMap) {
  if (dynamicMap == null) {
    return {};
  }
  Map<String, String> stringMap = dynamicMap
      .map((key, value) => MapEntry(key, value ? value.toString() : ""));
  return stringMap;
}
