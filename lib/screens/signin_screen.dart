import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../models/custom_error.dart';
import '../providers/signin/signin_provider.dart';
import '../providers/signin/signin_state.dart';
import '../utils/error_dialog.dart';
import 'signup_screen.dart';
// import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    debugPrint('email: $_email, password: $_password');

    try {
      await context
          .read<SignInProvider>()
          .signIn(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInState = context.watch<SignInProvider>().state;

    return WillPopScope(
      // splash screen 으로 돌아가지 못하게 처리.
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      'assets/images/flutter_logo.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email required';
                        }
                        if (!isEmail(value.trim())) {
                          return 'Enter a valid email';
                        }
                        debugPrint('email: $value');
                        return null;
                      },
                      onSaved: (String? value) {
                        debugPrint('onSaved >> email: $value, $_email');
                        _email = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password required';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        debugPrint('password: $value');
                        return null;
                      },
                      onSaved: (String? value) {
                        debugPrint('onSaved >> password: $value, $_password');
                        _password = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          signInState.signInStatus == SignInStatus.submitting
                              ? null
                              : _submit,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(
                          signInState.signInStatus == SignInStatus.submitting
                              ? 'Loading...'
                              : 'Sign In'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed:
                          signInState.signInStatus == SignInStatus.submitting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SignUpScreen.routeName);
                                },
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                        fontSize: 20.0,
                        decoration: TextDecoration.underline,
                      )),
                      child: const Text('Not a member? Sign up!'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
