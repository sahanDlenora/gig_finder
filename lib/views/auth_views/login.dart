// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/utils/constants/colors.dart';
import 'package:gig_finder/utils/functions/functions.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:gig_finder/widgets/reusable/custom_input.dart';
import 'package:gig_finder/widgets/reusable/mediaIcon.dart';
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

      UtilFunctions().showSnackBar(
          context: context, message: "User sign in Successfully..");

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing in with Google: $e');
      UtilFunctions().showSnackBar(
          context: context, message: "Error signing in with Google: $e");
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

      UtilFunctions().showSnackBar(
          context: context, message: "User sign in Successfully..");

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing in with email and password: $e');

      UtilFunctions().showSnackBar(
          context: context,
          message: "Error signing in with email and password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fill your details or continue\nwith social media',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInput(
                      controller: _emailController,
                      labelText: 'Email Address',
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
                    const SizedBox(height: 20),
                    CustomInput(
                      controller: _passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      suffixIcon: Icon(
                        Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password ?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _signInWithEmailAndPassword(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            //fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or continue with'),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: MediaIcon(socialImg: "assets/google.png"),
                            onTap: () => _signInWithGoogle(context),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          MediaIcon(socialImg: "assets/facebook.png"),
                          SizedBox(
                            width: 12,
                          ),
                          MediaIcon(socialImg: "assets/instegram.png"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/register');
                          },
                          child: const Text(
                            ' Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
