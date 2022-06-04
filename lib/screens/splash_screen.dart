// import 'package:fb_auth_test/providers/auth/auth_provider.dart';
import 'package:fb_auth_test/screens/home_screen.dart';
import 'package:fb_auth_test/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:state_notifier/state_notifier.dart';

import '../providers/auth/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthProvider>().state;
    final authState = context.watch<AuthState>();

    if (authState.authStatus == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, HomeScreen.routeName);
      });
    } else if (authState.authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, SignInScreen.routeName);
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
