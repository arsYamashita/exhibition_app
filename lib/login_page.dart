import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("start ui"),
                onPressed: () async {
                  final providers = [
                    AuthUiProvider.anonymous,
                    AuthUiProvider.email,
                    AuthUiProvider.phone,
                    AuthUiProvider.apple,
                    AuthUiProvider.github,
                    AuthUiProvider.google,
                    AuthUiProvider.microsoft,
                    AuthUiProvider.yahoo,
                  ];

                  final result = await FlutterAuthUi.startUi(
                    items: providers,
                    tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                      tosUrl: "https://www.google.com",
                      privacyPolicyUrl: "https://www.google.com",
                    ),
                    androidOption: AndroidOption(
                      enableSmartLock: false, // default true
                      showLogo: true, // default false
                      overrideTheme: true, // default false
                    ),
                    emailAuthOption: EmailAuthOption(
                      requireDisplayName: true, // default true
                      enableMailLink: false, // default false
                      handleURL: '',
                      androidPackageName: '',
                      androidMinimumVersion: '',
                    ),
                  );
                  print(result);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await FlutterAuthUi.signOut();
                  print('Signed out !');
                },
                child: Text('sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}