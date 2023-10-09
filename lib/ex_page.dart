import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('GitHub OAuth Example'),
//         ),
//         body: GitHubOAuth(),
//       ),
//     );
//   }
// }

class GitHubOAuth extends StatefulWidget {
  @override
  _GitHubOAuthState createState() => _GitHubOAuthState();
}

class _GitHubOAuthState extends State<GitHubOAuth> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.startsWith('YOUR_CALLBACK_URL')) {
        // Extract the 'code' parameter from the URL
        Uri uri = Uri.parse(url);
        String? code = uri.queryParameters['code'];
        if (code != null) {
          // Use the 'code' to obtain an access token
          exchangeCodeForAccessToken(code);
        }
      }
    });
  }

  void exchangeCodeForAccessToken(String code) {
    // Perform the POST request to exchange the code for an access token
    // Replace 'YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET', and 'YOUR_CALLBACK_URL'
    String clientId = '12f1258572700bf3b984';
    String clientSecret = 'ceb86dd1069eef225170ff44b36aa8d6d9a73a9b';
    String callbackUrl = 'http://localhost:3000/callback';

    // String tokenUrl = 'https://github.com/login/oauth/access_token';
    // String requestBody = 'client_id=$clientId&client_secret=$clientSecret&code=$code&redirect_uri=$callbackUrl';

    // Make a POST request to exchange the code for an access token
    // Handle the response to obtain the access token
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to GitHub's OAuth authorization page
          // Replace 'YOUR_CLIENT_ID' and 'YOUR_CALLBACK_URL'
          String clientId = '12f1258572700bf3b984';
          String callbackUrl = 'http://localhost:3000/callback';
          String authorizationUrl = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$callbackUrl';

          flutterWebviewPlugin.launch(
            authorizationUrl,
            rect: Rect.fromPoints(
              Offset(0, 0),
              Offset(300, 500),
            ),
          );
        },
        child: Text('Log in with GitHub'),
      ),
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}
