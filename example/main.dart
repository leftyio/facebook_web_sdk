import 'dart:async';
import 'package:facebook/facebook.dart';

Future<Null> main() async {
  addFacebookScript();

  await fbAsyncInit();
  init(
    new FbInitOption(
      appId: 'YOUR_APP_ID',
      cookies: true,
      xfbml: true,
      version: 'v2.9',
    ),
  );
  var response = await getLoginStatus();
  if (response.status != LoginStatus.connected) {
    print(response.status);
    response = await login();
  }
  print(response.status);
  print(response.authResponse.accessToken);
}
