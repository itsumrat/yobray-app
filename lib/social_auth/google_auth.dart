import 'package:auth_buttons/auth_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({Key? key}) : super(key: key);

  @override
  _GoogleAuthPageState createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  final _google = GoogleSignIn();
  final _facebook = FacebookAuth.instance;

  Map? _userData;

  @override
  Widget build(BuildContext context) {
    print(_userData);
    return Scaffold(
      appBar: AppBar(title: Text('Google Auth')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text(
            _google.currentUser?.photoUrl ?? 'null',
            style: TextStyle(color: Colors.red),
          ),
          CachedNetworkImage(
            imageUrl: _google.currentUser?.photoUrl ?? '',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(_userData?['name'] ?? 'null'),
          Text(_userData?['email'] ?? 'null'),
          Text(_userData?['picture']['data']['url'] ?? 'null'),
          GoogleAuthButton(
            onPressed: () async {
              final result = await signInWithGoogle();
              print(result);
              setState(() {});
            },
            darkMode: false, // if true second example
          ),
          GoogleAuthButton(
            key: UniqueKey(),
            onPressed: signOutGoogle,
            darkMode: false, // if true second example
          ),
          FacebookAuthButton(
            key: UniqueKey(),
            onPressed: () async {
              signInWithFacebook();
            },
            darkMode: false, // if true second example
          ),
          ElevatedButton(
            onPressed: () async {
              await FacebookAuth.instance.logOut();
              _userData = null;
              print(';;;;;');
              setState(() {});
            },
            child: Text('logout'),
          )
        ],
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await _facebook.login();

    if (result.status == LoginStatus.success) {
      _userData = await _facebook.getUserData();
      setState(() {});
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      print(accessToken.token);
      print('................');
    } else {
      print(result.status);
      print(result.message);
    }
  }

  Future<void> signOutGoogle() async {
    await _google.signOut();
    setState(() {});
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _google.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    print(googleAuth);
    print("we are here");
    return null;

    // Create a new credential
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
