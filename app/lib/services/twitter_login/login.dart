import 'dart:async';

import 'package:flutter/services.dart';
import 'package:schedurio/services/twitter_login/services/request_token.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/auth_result.dart';
import 'models/user.dart';
import 'services/access_token.dart';
import 'services/exception.dart';

/// The status after a Twitter login flow has completed.
enum TwitterLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error
  error,
}

///
class TwitterLogin {
  final String apiKey = '';
  final String apiSecretKey = '';
  final String redirectURI = '';

  /// Logs the user
  /// Forces the user to enter their credentials to ensure the correct users account is authorized.
  Future<void> login({bool forceLogin = false}) async {
    RequestToken requestToken;
    try {
      requestToken = await RequestToken.getRequestToken(
        apiKey,
        apiSecretKey,
        redirectURI,
        forceLogin,
      );
    } on Exception {
      throw PlatformException(
        code: "400",
        message: "Failed to generate request token.",
        details: "Please check your APIKey or APISecret.",
      );
    }

    print("requestToken.authorizeURI: ${requestToken.authorizeURI}");
    final uri = Uri.parse(requestToken.authorizeURI);
    launchUrl(uri);
  }

  Future<AuthResult> getAuthResult(resultURI) async {
    // The user closed the browser.
    if (resultURI?.isEmpty ?? true) {
      throw const CanceledByUserException();
    }

    final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
    if (queries['error'] != null) {
      throw Exception('Error Response: ${queries['error']}');
    }

    // The user cancelled the login flow.
    if (queries['denied'] != null) {
      throw const CanceledByUserException();
    }

    final token = await AccessToken.getAccessToken(
      apiKey,
      apiSecretKey,
      queries,
    );
    // http: //localhost:3000/api/auth/callback/twitter?oauth_token=S4BlMwAAAAABgmYjAAABh2ChkiI&oauth_verifier=W8aE57hkPiQECvVColuKWETBuEvANEsa
    print(token.userId);
    if ((token.authToken?.isEmpty ?? true) ||
        (token.authTokenSecret?.isEmpty ?? true)) {
      return AuthResult(
        authToken: token.authToken,
        authTokenSecret: token.authTokenSecret,
        status: TwitterLoginStatus.error,
        errorMessage: 'Failed',
        user: null,
      );
    }

    return AuthResult(
      authToken: token.authToken,
      authTokenSecret: token.authTokenSecret,
      status: TwitterLoginStatus.loggedIn,
      errorMessage: null,
      user: await User.getUserData(
        apiKey,
        apiSecretKey,
        token.authToken!,
        token.authTokenSecret!,
      ),
    );
  }
  // Future<AuthResult> loginV2({bool forceLogin = false}) async {
  //   String? resultURI;
  //   RequestToken requestToken;
  //   try {
  //     requestToken = await RequestToken.getRequestToken(
  //       apiKey,
  //       apiSecretKey,
  //       redirectURI,
  //       forceLogin,
  //     );
  //   } on Exception {
  //     throw PlatformException(
  //       code: "400",
  //       message: "Failed to generate request token.",
  //       details: "Please check your APIKey or APISecret.",
  //     );
  //   }

  //   final uri = Uri.parse(redirectURI);
  //   final completer = Completer<String?>();
  //   late StreamSubscription subscribe;

  //   if (Platform.isAndroid) {
  //     await _channel.invokeMethod('setScheme', uri.scheme);
  //     subscribe = _eventStream.listen((data) async {
  //       if (data['type'] == 'url') {
  //         if (!completer.isCompleted) {
  //           completer.complete(data['url']?.toString());
  //         } else {
  //           throw CanceledByUserException();
  //         }
  //       }
  //     });
  //   }

  //   final authBrowser = AuthBrowser(
  //     onClose: () {
  //       if (!completer.isCompleted) {
  //         completer.complete(null);
  //       }
  //     },
  //   );

  //   try {
  //     if (Platform.isIOS || Platform.isMacOS) {
  //       /// Login to Twitter account with SFAuthenticationSession or ASWebAuthenticationSession.
  //       resultURI =
  //           await authBrowser.doAuth(requestToken.authorizeURI, uri.scheme);
  //     } else if (Platform.isAndroid) {
  //       // Login to Twitter account with chrome_custom_tabs.
  //       final success =
  //           await authBrowser.open(requestToken.authorizeURI, uri.scheme);
  //       if (!success) {
  //         throw PlatformException(
  //           code: '200',
  //           message:
  //               'Could not open browser, probably caused by unavailable custom tabs.',
  //         );
  //       }
  //       resultURI = await completer.future;
  //       subscribe.cancel();
  //     } else {
  //       throw PlatformException(
  //         code: '100',
  //         message: 'Not supported by this os.',
  //       );
  //     }

  //     // The user closed the browser.
  //     if (resultURI?.isEmpty ?? true) {
  //       throw CanceledByUserException();
  //     }

  //     final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
  //     if (queries['error'] != null) {
  //       throw Exception('Error Response: ${queries['error']}');
  //     }

  //     // The user cancelled the login flow.
  //     if (queries['denied'] != null) {
  //       throw CanceledByUserException();
  //     }

  //     final token = await AccessToken.getAccessToken(
  //       apiKey,
  //       apiSecretKey,
  //       queries,
  //     );

  //     if ((token.authToken?.isEmpty ?? true) ||
  //         (token.authTokenSecret?.isEmpty ?? true)) {
  //       return AuthResult(
  //         authToken: token.authToken,
  //         authTokenSecret: token.authTokenSecret,
  //         status: TwitterLoginStatus.error,
  //         errorMessage: 'Failed',
  //         user: null,
  //       );
  //     }

  //     final user = await User.getUserDataV2(
  //       apiKey,
  //       apiSecretKey,
  //       token.authToken!,
  //       token.authTokenSecret!,
  //       token.userId!,
  //     );

  //     return AuthResult(
  //       authToken: token.authToken,
  //       authTokenSecret: token.authTokenSecret,
  //       status: TwitterLoginStatus.loggedIn,
  //       errorMessage: null,
  //       user: user,
  //     );
  //   } on CanceledByUserException {
  //     return AuthResult(
  //       authToken: null,
  //       authTokenSecret: null,
  //       status: TwitterLoginStatus.cancelledByUser,
  //       errorMessage: 'The user cancelled the login flow.',
  //       user: null,
  //     );
  //   } catch (error) {
  //     return AuthResult(
  //       authToken: null,
  //       authTokenSecret: null,
  //       status: TwitterLoginStatus.error,
  //       errorMessage: error.toString(),
  //       user: null,
  //     );
  //   }
  // }
}
