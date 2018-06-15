@JS('window')
library facebook;

import 'dart:async';

import 'package:dart_browser_loader/dart_browser_loader.dart';
import 'package:js/js.dart';

void addFacebookScript() {
  loadScript('//connect.facebook.net/en_US/sdk.js', id: 'facebook-jssdk');
}

@JS('fbAsyncInit')
external set _fbAsyncInit(Function function);

Future<void> fbAsyncInit() {
  final completer = new Completer<void>();
  _fbAsyncInit = allowInterop(completer.complete);
  return completer.future;
}

@JS()
@anonymous
class FbInitOption {
  external String get appId;

  external bool get cookies;

  external bool get xfbml;

  external String get version;

  external factory FbInitOption(
      {String appId,
      bool cookies: false,
      bool xfbml: false,
      String version: 'v2.9'});
}

@JS('FB.init')
external void init(FbInitOption option);

@JS()
@anonymous
class JsAuthResponse {
  external String get accessToken;

  external String get expiresIn;

  external String get signedRequest;

  external String get userID;

  external factory JsAuthResponse(
      {String accessToken,
      String expiresIn,
      String signedRequest,
      String userID});
}

@JS()
@anonymous
class JsLoginStatusResponse {
  external String get status;

  external JsAuthResponse get authResponse;

  external factory JsLoginStatusResponse(
      {String status, JsAuthResponse authResponse});
}

class AuthResponse {
  final String accessToken;
  final String expiresIn;
  final String signedRequest;
  final String userID;

  AuthResponse.fromJsObject(JsAuthResponse jsObject)
      : accessToken = jsObject.accessToken,
        expiresIn = jsObject.expiresIn,
        signedRequest = jsObject.signedRequest,
        userID = jsObject.userID;
}

enum LoginStatus {
  connected,
  notAuthorized,
  unknown,
}

LoginStatus _stringToLoginStatus(String status) {
  switch (status) {
    case 'connected':
      return LoginStatus.connected;
    case 'not_authorized':
      return LoginStatus.notAuthorized;
    case 'unknown':
      return LoginStatus.unknown;
    default:
      return LoginStatus.unknown;
  }
}

class LoginStatusResponse {
  final LoginStatus status;
  final AuthResponse authResponse;

  LoginStatusResponse(String status, this.authResponse)
      : status = _stringToLoginStatus(status);

  LoginStatusResponse.fromJsObject(JsLoginStatusResponse jsObject)
      : status = _stringToLoginStatus(jsObject.status),
        authResponse = jsObject.authResponse != null
            ? new AuthResponse.fromJsObject(jsObject.authResponse)
            : null;
}

@JS('FB.getLoginStatus')
external void _getLoginStatus(Function f);

Future<LoginStatusResponse> getLoginStatus() {
  final completer = new Completer<LoginStatusResponse>();
  _getLoginStatus(allowInterop((JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }));
  return completer.future;
}

@JS()
@anonymous
class JsScope {
  external String get scope;

  external factory JsScope({String scope});
}

@JS('FB.login')
external void _login(Function f, JsScope scope);

Future<LoginStatusResponse> login([List<String> scopes]) {
  scopes ??= ['public_profile'];
  final completer = new Completer<LoginStatusResponse>();
  _login(allowInterop((JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }), new JsScope(scope: scopes.join(",")));
  return completer.future;
}

@JS('FB.logout')
external void _logout(Function f);

Future<void> logout() {
  final completer = new Completer();
  _logout(allowInterop(completer.complete));
  return completer.future;
}
