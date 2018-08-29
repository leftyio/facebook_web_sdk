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

/// The method [init] is used to initialize and setup the SDK.
/// If you have followed our SDK quickstart guide,
/// you won't need to re-use this method,
/// but you may want to customize the parameters used.
///
/// https://developers.facebook.com/docs/javascript/reference/FB.init/v3.1
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
  authorizationExpired,
  unknown,
}

LoginStatus _stringToLoginStatus(String status) {
  switch (status) {
    case 'connected':
      return LoginStatus.connected;
    case 'not_authorized':
      return LoginStatus.notAuthorized;
    case 'authorization_expired':
      return LoginStatus.authorizationExpired;
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

/// [getLoginStatus] allows you to determine if a user is logged in to Facebook and has authenticated your app.
/// There are four possible states for a user:

/// The user is logged into Facebook and has authorized your application. [LoginStatus.connected]
/// The user has previously logged into your application but your authorization to access their data has expired. [LoginStatus.authorizationExpired]
/// The user is logged into Facebook but has not authorized your application. [LoginStatus.notAuthorized]
/// The user is either not logged into Facebook or explicitly logged out of your application so it doesn't attempt to connect to Facebook and thus, we don't know if they've authenticated your application or not. [LoginStatus.unknown]
/// Knowing which of the these three states the user is in is one of the first things your application needs to know on page load.
///
/// https://developers.facebook.com/docs/reference/javascript/FB.getLoginStatus/
Future<LoginStatusResponse> getLoginStatus() {
  final completer = new Completer<LoginStatusResponse>();
  base.getLoginStatus(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }));
  return completer.future;
}

/// The method [getAuthResponse] is a synchronous accessor for the current authResponse.
/// The synchronous nature of this method is what sets it apart from the other login methods.
///
/// This method is similar in nature to [getLoginStatus], but it returns just the authResponse object.
/// Many parts of your application already assume the user is connected with your application.
/// In such cases, you may want to avoid the overhead of making asynchronous calls.
///
/// https://developers.facebook.com/docs/reference/javascript/FB.getAuthResponse/
base.JsLoginStatusResponse getAuthResponse() => base.getAuthResponse();

/// Prompts a user to login to your app using the Login dialog in a popup.
/// This method can also be used with an already logged-in user to request additional permissions from them.
///
/// https://developers.facebook.com/docs/reference/javascript/FB.login/v3.1
Future<LoginStatusResponse> login([List<String> scopes]) {
  scopes ??= ['public_profile'];
  final completer = new Completer<LoginStatusResponse>();
  base.login(allowInterop((base.JsLoginStatusResponse response) {
    completer.complete(new LoginStatusResponse.fromJsObject(response));
  }), new base.JsScope(scope: scopes.join(",")));
  return completer.future;
}

/// The method [ogout] logs the user out of your site and, in some cases, Facebook.
///
/// Consider the 3 scenarios below:
///
/// - A person logs into Facebook, then logs into your app. Upon logging out from your app, the person is still logged into Facebook.
/// - A person logs into your app and into Facebook as part of your app's login flow. Upon logging out from your app, the user is also logged out of Facebook.
/// - A person logs into another app and into Facebook as part of the other app's login flow, then logs into your app. Upon logging out from either app, the user is logged out of Facebook.
///
/// https://developers.facebook.com/docs/reference/javascript/FB.logout/
Future<void> logout() {
  final completer = new Completer();
  base.logout(allowInterop(completer.complete));
  return completer.future;
}

/// The Share dialog gives people the ability to publish an individual story to their timeline, a friend's timeline, a group, or in a private message on Messenger.
/// This does not require Facebook Login or any extended permissions, so it is the easiest way to enable sharing on the web.
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
