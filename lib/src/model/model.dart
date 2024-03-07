import 'package:intl/intl.dart';

class User {
  String id;
  String username;
  String email;
  String deviceId;

  User({
    this.id = "",
    this.username = "",
    this.email = "",
    this.deviceId = "",
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        deviceId: json["deviceId"] ?? "",
      );
}

enum ProType {
  none(0),
  weeklyPremium(3),
  monthlyPremium(4);

  const ProType(this.value);
  final int value;
}

class Profile {
  String id;
  String username;
  String nickname;
  String deviceId;
  String email;
  String avatar;
  int diamond;
  bool isPro;
  int proType;
  bool proIsAutoRenew;
  int proStart;
  int proEnd;

  Profile({
    this.id = "",
    this.username = "",
    this.nickname = "",
    this.deviceId = "",
    this.email = "",
    this.avatar = "",
    this.diamond = 0,
    this.isPro = false,
    this.proType = 0,
    this.proIsAutoRenew = false,
    this.proStart = 0,
    this.proEnd = 0,
  });

  String getProDateRange() {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(proStart);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(proEnd);
    return "${DateFormat('yyyy.M.d').format(start)} ~ ${DateFormat('M.d').format(end)}";
  }

  String getProName() {
    if (proType == ProType.weeklyPremium.value) {
      return "Weekly Premium";
    }
    if (proType == ProType.monthlyPremium.value) {
      return "Monthly Premium";
    }
    return "Subscribe";
  }

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] ?? "",
        username: json["username"] ?? "",
        nickname: json["nickname"] ?? "",
        deviceId: json["deviceId"] ?? "",
        email: json["email"] ?? "",
        avatar: json["avatar"] ?? "",
        diamond: json["diamond"] ?? 0,
        isPro: json["isPro"] ?? false,
        proType: json["proType"] ?? 0,
        proIsAutoRenew: json["proIsAutoRenew"] ?? false,
        proStart: json["proStart"] ?? 0,
        proEnd: json["proEnd"] ?? 0,
      );
}
