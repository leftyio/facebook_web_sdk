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

/// Used to initialize and setup the SDK.
/// All other SDK methods must be called after this one.
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

/// Returns the Facebook Login status of a user, with an [LoginStatusResponse] object if they are logged in.
Future<LoginStatusResponse> getLoginStatus() {
  final completer = new Completer<LoginStatusResponse>();
  base.getLoginStatus(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }));
  return completer.future;
}

/// Prompts a user to login to your app using the Login dialog in a popup.
/// This method can also be used with an already logged-in user to request additional permissions from them.
Future<LoginStatusResponse> login([List<String> scopes]) {
  scopes ??= ['public_profile'];
  final completer = new Completer<LoginStatusResponse>();
  base.login(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }), new base.JsScope(scope: scopes.join(",")));
  return completer.future;
}

/// Used to logout the current user both from your site or app and from Facebook.com.
Future<void> logout() {
  final completer = new Completer();
  base.logout(allowInterop(completer.complete));
  return completer.future;
}

/// The Share dialog gives people the ability to publish an individual story to their timeline,
/// a friend's timeline, a group, or in a private message on Messenger.
/// This does not require Facebook Login or any extended permissions,
/// so it is the easiest way to enable sharing on the web.
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
