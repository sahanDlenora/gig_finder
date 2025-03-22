// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/utils/constants/colors.dart';
import 'package:gig_finder/utils/functions/functions.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:gig_finder/widgets/reusable/custom_input.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  // Sign in with Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Sign in with Google
      await AuthService().signInWithGoogle();

      UtilFunctions().showSnackBar(context, "User sign in Successfully..");

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing in with Google: $e');
      UtilFunctions().showSnackBar(context, "Error signing in with Google: $e");
    }
  }

  // Sign in with email and password
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign in with email and password
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      UtilFunctions().showSnackBar(context, "User sign in Successfully..");

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing in with email and password: $e');

      UtilFunctions().showSnackBar(
          context, "Error signing in with email and password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/Logo.png'),
                height: 70,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableInput(
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ReusableInput(
                      controller: _passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ReusableButton(
                      text: 'Log in',
                      width: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await _signInWithEmailAndPassword(context);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Sign in with Google to access the app's features",
                      style: TextStyle(
                        fontSize: 13,
                        color: mainWhiteColor.withOpacity(0.6),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Google Sign-In Button
                    ReusableButton(
                      text: 'Sign in with Google',
                      width: MediaQuery.of(context).size.width,
                      onPressed: () => _signInWithGoogle(context),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to signup screen
                        GoRouter.of(context).go('/register');
                      },
                      child: const Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: mainWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
