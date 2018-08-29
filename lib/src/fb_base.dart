@JS('window')
library facebook;

import 'package:js/js.dart';

@JS('fbAsyncInit')
external set fbAsyncInit(Function function);

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

@JS('FB.getLoginStatus')
external void getLoginStatus(Function f);

@JS()
@anonymous
class JsScope {
  external String get scope;

  external factory JsScope({String scope});
}

@JS('FB.login')
external void login(Function f, JsScope scope);

@JS('FB.logout')
external void logout(Function f);

abstract class UiParams {
  String get method;
}

@JS()
@anonymous
class ShareDialogParams implements UiParams {
  external String get method;
  external String get href;
  external String get hashtag;
  external String get quote;
  external bool get mobile_iframe;

  external factory ShareDialogParams({
    String method = 'share',
    String href,
    String hashtag,
    String quote,
    bool mobile_iframe = false,
  });
}

@JS()
@anonymous
class UiResponseData {
  external String get errorMessage;
}

@JS('FB.ui')
external void ui(params, Function f);
