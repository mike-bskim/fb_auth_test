import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:fb_auth_test/providers/auth/auth_state.dart';
// import 'package:fb_auth_test/providers/profile/profile_provider.dart';
import 'package:fb_auth_test/providers/providers.dart';
import 'package:fb_auth_test/repositories/profile_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'repositories/auth_repo.dart';

// import 'providers/auth/auth_provider.dart';
// import 'providers/signin/signin_provider.dart';
// import 'providers/signup/signup_provider.dart';
import 'screens/home_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized(); //
  await Firebase.initializeApp(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepo>(
          create: (context) => AuthRepo(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseAuth: fb_auth.FirebaseAuth.instance,
          ),
        ),
        Provider<ProfileRepo>(
          create: (context) => ProfileRepo(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<fb_auth.User?>(
          create: (context) => context.read<AuthRepo>().user,
          initialData: null,
        ),
        StateNotifierProvider<AuthProvider, AuthState>(
          create: (context) => AuthProvider(AuthState.unknown()),
        ),
        // ChangeNotifierProxyProvider<fb_auth.User?, AuthProvider>(
        //   create: (context) => AuthProvider(authRepo: context.read<AuthRepo>()),
        //   update: (
        //     context,
        //     fb_auth.User? userStream,
        //     AuthProvider? authProvider,
        //   ) =>
        //       authProvider!..update(userStream),
        // ),
        StateNotifierProvider<SignInProvider, SignInState>(
          create: (context) => SignInProvider(SignInState.init()),
        ),
        // ChangeNotifierProvider<SignInProvider>(
        //   create: (context) => SignInProvider(
        //     authRepo: context.read<AuthRepo>(),
        //   ),
        // ),
        StateNotifierProvider<SignUpProvider, SignUpState>(
          create: (context) => SignUpProvider(SignUpState.init()),
        ),
        // ChangeNotifierProvider<SignUpProvider>(
        //   create: (context) => SignUpProvider(
        //     authRepo: context.read<AuthRepo>(),
        //   ),
        // ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(ProfileState.init()),
        ),
        // ChangeNotifierProvider<ProfileProvider>(
        //   create: (context) => ProfileProvider(
        //     profileRepo: context.read<ProfileRepo>(),
        //   ),
        // ),
      ],
      child: MaterialApp(
        title: 'Auth Provider',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: {
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          SignInScreen.routeName: (context) => const SignInScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
