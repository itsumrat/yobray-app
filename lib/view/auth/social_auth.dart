import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthController {
  final _google = GoogleSignIn();

  final _facebook = FacebookAuth.instance;

  Future<Map?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await _facebook.login();

      if (result.status == LoginStatus.success) {
        final userData = await _facebook.getUserData();

        FacebookAuth.instance.logOut();
        return {
          'name': userData['name'],
          'email': userData['email'],
          'profile_pic': userData['picture']['data']['url'],
        };
      } else {
        print(result.status);
        print(result.message);
      }
    } catch (e) {}
    return null;
  }

  Future<Map?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _google.signIn();
      print("googleUser!.displayName");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // if (googleAuth == null) return null;
      print("we are here" + googleAuth.toString());
      // _google.signOut();
      if (googleAuth == null) return null;
      return {
        'name': _google.currentUser?.displayName,
        'email': _google.currentUser?.email,
        'profile_pic': _google.currentUser?.photoUrl,
      };

      // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

      // Once signed in, return the UserCredential
      // await FirebaseAuth.instance.signInWithCredential(credential);
      // return {
      //   'name': _google.currentUser?.displayName,
      //   'email': _google.currentUser?.email,
      //   'profile_pic': _google.currentUser?.photoUrl,
      // };
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map?> signInWithApple() async {
    try {
      final appleIDCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('........................................');

      print(appleIDCredential.email);
      print(appleIDCredential.familyName);
      print(appleIDCredential.givenName);
      print(appleIDCredential.userIdentifier);

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');

      final credential = oAuthProvider.credential(
        idToken: appleIDCredential.identityToken,
        accessToken: appleIDCredential.authorizationCode,
      );

      final _auth =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('Firebase ${_auth.user!.email}');
      print('Firebase ${_auth.user!.displayName}');

      await FirebaseAuth.instance.signOut();

      if (_auth.user != null) {
        return {
          'name': _auth.user!.displayName ?? 'xyz',
          'email': _auth.user!.email,
          'profile_pic': '',
        };
      } else {
        print('Authorization Failed, User information failed');
        return null;
      }
    } catch (e) {
      print('Exception $e');
    }
    return null;

    // if (!await TheAppleSignIn.isAvailable()) return null;

    // try {
    //   print('........................................');
    //
    //   final result = await TheAppleSignIn.performRequests([
    //     const AppleIdRequest(
    //       requestedScopes: [Scope.email, Scope.fullName],
    //     ),
    //   ]);
    //
    //   print(result.credential!.email);
    //
    //   print('........................................');
    //
    //   switch (result.status) {
    //     case AuthorizationStatus.authorized:
    //       print('===========================================================');
    //       try {
    //         final AppleIdCredential appleIdCredential = result.credential!;
    //
    //         final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    //
    //         final credential = oAuthProvider.credential(
    //           idToken: String.fromCharCodes(appleIdCredential.identityToken!),
    //           accessToken:
    //               String.fromCharCodes(appleIdCredential.authorizationCode!),
    //         );
    //
    //         if (result.credential != null) {
    //           return {
    //             'name': result.credential!.fullName!.givenName ?? 'xyz',
    //             'email': result.credential!.email,
    //             'profile_pic': '',
    //           };
    //         } else {
    //           print('Authorization Failed, User information failed');
    //           return null;
    //         }
    //       } catch (e) {
    //         print('Authorized error $e');
    //         return null;
    //       }
    //     case AuthorizationStatus.error:
    //       print('Auth Error');
    //       return null;
    //     case AuthorizationStatus.cancelled:
    //       print('Auth Cancelled');
    //       return null;
    //   }
    // } catch (e) {
    //   print('Exception $e');
    // }
  }
}
