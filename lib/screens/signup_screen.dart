import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../models/custom_error.dart';
import '../providers/signup/signup_provider.dart';
import '../providers/signup/signup_state.dart';
import '../utils/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _name, _email, _password;
  final _passwordCtrl = TextEditingController();

  void _submit() async {
    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    debugPrint('name: $_name, email: $_email, password: $_password');

    try {
      await context
          .read<SignUpProvider>()
          .signUp(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final signUpState = context.watch<SignUpProvider>().state;
    final signUpState = context.watch<SignUpState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'assets/images/flutter_logo.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters long';
                      }
                      debugPrint('Name: $value');
                      return null;
                    },
                    onSaved: (String? value) {
                      _name = value;
                      debugPrint('onSaved >> email: $value, $_name');
                    },
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
                      _email = value;
                      debugPrint('onSaved >> email: $value, $_email');
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordCtrl,
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
                      _password = value;
                      debugPrint('onSaved >> password: $value, $_password');
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (_passwordCtrl.text != value) {
                        return 'Passwords not match';
                      }
                      debugPrint('confirm password: $value');
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        signUpState.signUpStatus == SignUpStatus.submitting
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
                        signUpState.signUpStatus == SignUpStatus.submitting
                            ? 'Loading...'
                            : 'Sign Up'),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    onPressed:
                        signUpState.signUpStatus == SignUpStatus.submitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                      fontSize: 20.0,
                      decoration: TextDecoration.underline,
                    )),
                    child: const Text('Already a member Sign in!'),
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
