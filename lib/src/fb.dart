import 'dart:async';
import 'dart:js';

import 'package:dart_browser_loader/dart_browser_loader.dart';
import 'fb_base.dart' as base;

void addFacebookScript({String lang = 'en_US'}) {
  loadScript('//connect.facebook.net/$lang/sdk.js', id: 'facebook-jssdk');
}

Future<void> fbAsyncInit() {
  final completer = new Completer<void>();
  base.fbAsyncInit = allowInterop(completer.complete);
  return completer.future;
}

void init(base.FbInitOption option) => base.init(option);

class AuthResponse {
  final String accessToken;
  final String expiresIn;
  final String signedRequest;
  final String userID;

  AuthResponse.fromJsObject(base.JsAuthResponse jsObject)
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

  LoginStatusResponse.fromJsObject(base.JsLoginStatusResponse jsObject)
      : status = _stringToLoginStatus(jsObject.status),
        authResponse = jsObject.authResponse != null
            ? new AuthResponse.fromJsObject(jsObject.authResponse)
            : null;
}

Future<LoginStatusResponse> getLoginStatus() {
  final completer = new Completer<LoginStatusResponse>();
  base.getLoginStatus(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }));
  return completer.future;
}

Future<LoginStatusResponse> login([List<String> scopes]) {
  scopes ??= ['public_profile'];
  final completer = new Completer<LoginStatusResponse>();
  base.login(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }), new base.JsScope(scope: scopes.join(",")));
  return completer.future;
}

Future<void> logout() {
  final completer = new Completer();
  base.logout(allowInterop(completer.complete));
  return completer.future;
}

Future<base.UiResponseData> uiShareDialog(
    {String href,
    String hastag,
    String quote,
    bool mobileIframe = false}) async {
  final completer = Completer<base.UiResponseData>();
  base.ui(
    base.ShareDialogParams(
        href: href, hashtag: hastag, quote: quote, mobile_iframe: mobileIframe),
    allowInterop(completer.complete),
  );
  return completer.future;
}
