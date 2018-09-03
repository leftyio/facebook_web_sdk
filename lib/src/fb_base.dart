@JS('window')
library facebook;

import 'package:js/js.dart';

@JS('fbAsyncInit')
external set fbAsyncInit(Function function);

@JS('FB.getAuthResponse')
external JsLoginStatusResponse getAuthResponse();

@JS('FB.getLoginStatus')
external void getLoginStatus(Function f);

@JS('FB.init')
external void init(FbInitOption option);

@JS('FB.login')
external void login(Function f, JsScope scope);

@JS('FB.logout')
external void logout(Function f);

@JS('FB.ui')
external void ui(params, Function f);

@JS()
@anonymous
class FbInitOption {
  external factory FbInitOption(
      {String appId,
      bool cookies: false,
      bool xfbml: false,
      String version: 'v2.9'});

  external String get appId;

  external bool get cookies;

  external String get version;

  external bool get xfbml;
}

@JS()
@anonymous
class JsAuthResponse {
  external factory JsAuthResponse(
      {String accessToken,
      String expiresIn,
      String signedRequest,
      String userID});

  external String get accessToken;

  external String get expiresIn;

  external String get signedRequest;

  external String get userID;
}

@JS()
@anonymous
class JsLoginStatusResponse {
  external factory JsLoginStatusResponse(
      {String status, JsAuthResponse authResponse});

  external JsAuthResponse get authResponse;

  external String get status;
}

@JS()
@anonymous
class JsScope {
  external factory JsScope({String scope});

  external String get scope;
}

@JS()
@anonymous
class ShareDialogParams implements UiParams {
  external factory ShareDialogParams({
    String method = 'share',
    String href,
    String hashtag,
    String quote,
    //  ignore: non_constant_identifier_names
    bool mobile_iframe = false,
  });
  external String get hashtag;
  external String get href;
  //  ignore: non_constant_identifier_names
  @override
  external String get method;
  external bool get mobile_iframe;
  external String get quote;
}

abstract class UiParams {
  String get method;
}

@JS()
@anonymous
class UiResponseData {
  external String get errorMessage;
}
