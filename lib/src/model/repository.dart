import 'dart:convert';

import 'package:drrr/src/components/base/base.dart' as base;
import 'package:drrr/src/model/model.dart';
import 'package:drrr/src/router/auth.dart';
import 'package:drrr/src/utils/request/request.dart';
import 'package:drrr/src/utils/persistent.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

var globalRequestOption = RequestOption(
  baseUrl: "http://192.168.2.3:8000",
  timeout: 5,
  cookieJar: persistentCookieJar,
);

var globalRepositoryOption = RepositoryOption(
  requestOption: globalRequestOption,
  onError: (context, error) {
    base.Toast(context, error.message);
    var shouldLogin = error.code == ErrorCode.unauthorized.value;
    if (shouldLogin) {
      AuthState.of(context).removeSignedIn();
      Future.delayed(const Duration(seconds: 3), () {
        context.goNamed("login");
      });
    }
  },
);

class RepositoryOption {
  final RequestOption? requestOption;
  final BuildContext? context;
  final Function(BuildContext context, RequestError error)? onError;

  RepositoryOption({
    this.requestOption,
    this.context,
    this.onError,
  });

  RepositoryOption merge(RepositoryOption? other) {
    if (other == null) {
      return this;
    }
    return RepositoryOption(
      requestOption: other.requestOption ?? requestOption,
      context: other.context ?? context,
      onError: other.onError ?? onError,
    );
  }

  void handleError(RequestError error) {
    if (onError != null && context != null) {
      onError!(context!, error);
    }
  }
}

enum ErrorCode {
  badRequest(10400),
  notFound(10404),
  internalError(10500),
  unauthorized(10401),
  forbidden(10403),
  networkError(10444),
  usernameTooLong(20001),
  emailFormat(20002),
  userShouldVerify(20003),
  verifyCode(20004),
  emailNotMatch(20005);

  const ErrorCode(this.value);
  final int value;
}

class RequestError implements Exception {
  final int code;
  final String message;
  RequestError({
    this.code = 0,
    this.message = "",
  });

  factory RequestError.fromJson(Map<String, dynamic> json) => RequestError(
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
      );

  RequestError.fromException(Object e)
      : code = 10444,
        message = e.toString();

  @override
  String toString() {
    return "RequestError($code, $message)";
  }
}

typedef DoRequestFunc = Future<Response> Function();

class BaseRepository {
  RepositoryOption getOption([RepositoryOption? option]) {
    return option != null
        ? globalRepositoryOption.merge(option)
        : globalRepositoryOption;
  }

  Request getRequest([RepositoryOption? option]) {
    var requestOption = option != null
        ? globalRequestOption.merge(option.requestOption)
        : globalRequestOption;
    return Request(option: requestOption);
  }

  Future<Response> doRequest(DoRequestFunc fn,
      [RepositoryOption? option]) async {
    try {
      final response = await fn();
      if (!response.ok) {
        var requestError = RequestError.fromJson(jsonDecode(response.body));
        getOption(option).handleError(requestError);
        return Future.error(requestError);
      }
      return response;
    } catch (e) {
      var requestError = RequestError.fromException(e);
      getOption(option).handleError(requestError);
      return Future.error(requestError);
    }
  }
}

class ProfileResponse {
  Profile profile;
  ProfileResponse({
    required this.profile,
  });
  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        profile: Profile.fromJson(json["profile"] ?? {}),
      );
}

class UserMockRepository extends BaseRepository {
  UserMockRepository();

  Future<ProfileResponse> profile([RepositoryOption? option]) async {
    await Future.delayed(const Duration(seconds: 1));
    return ProfileResponse(
      profile: Profile(
        id: "1",
        username: "test",
        nickname: "test",
        deviceId: "test",
        email: "",
        avatar: "",
        diamond: 0,
        isPro: false,
        proType: 0,
        proIsAutoRenew: false,
        proStart: 0,
        proEnd: 0,
      ),
    );
  }
}

class UserRemoteRepository extends BaseRepository {
  UserRemoteRepository();

  Future<ProfileResponse> profile([RepositoryOption? option]) async {
    var response = await doRequest(
        () => getRequest(option).get(
              "/api/profile",
            ),
        option);
    return ProfileResponse.fromJson(jsonDecode(response.body));
  }
}

class UserRepository extends UserMockRepository {
  UserRepository();
}
