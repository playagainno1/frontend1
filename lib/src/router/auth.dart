import 'package:drrr/src/utils/persistent.dart';
import 'package:flutter/material.dart';

class AuthStateProvider {
  Future<bool> isSignedIn() async {
    var sessionId = await getSessionId();
    return sessionId.isNotEmpty;
  }

  Future<void> removeSignedIn() async {
    await removeSessionId();
    await removeUsername();
  }
}

var _provider = AuthStateProvider();

class AuthState {
  static AuthStateProvider of(BuildContext context) {
    return _provider;
  }
}
