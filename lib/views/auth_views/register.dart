import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/user_model.dart';
import 'package:gig_finder/service/users/user_service.dart';
import 'package:gig_finder/service/users/user_storage.dart';
import 'package:gig_finder/utils/constants/colors.dart';
import 'package:gig_finder/utils/functions/functions.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:gig_finder/widgets/reusable/custom_input.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile;

  // Pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Sign up with email and password
  Future<void> _createUser(BuildContext context) async {
    try {
      // Store the user image in storage and get the download URL
      String profilePicture =
          ""; // Default empty string if no image is uploaded
      if (_imageFile != null) {
        profilePicture = await UserProfileStorageService().uploadImage(
          profileImage: _imageFile!,
          userEmail: _emailController.text,
        );
      }

      // Save user to Firestore
      UserService().saveUser(
        UserModel(
          userId: "", // You might want to generate a unique ID here
          name: _nameController.text,
          email: _emailController.text,
          contact: _contactNumController
              .text, // Assuming you have a contact controller
          userType: _userTypeController
              .text, // Assuming you have a userType controller
          profilePicture: profilePicture,
          about: _aboutController.text, // Assuming you have an about controller
          rating: 0.0, // Default rating for a new user
          password: _passwordController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Show snackbar
      if (context.mounted) {
        UtilFunctions().showSnackBar(context, "User created Successfully..");
      }
      // Navigate to the main screen
      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing up with email and password: $e');
      // Show snackbar with error message
      if (context.mounted) {
        UtilFunctions().showSnackBar(
            context, "Error signing up with email and password: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Image(
                  image: AssetImage('assets/Logo.png'),
                  height: 70,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(_imageFile!),
                                  backgroundColor: mainPurpleColor,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                  backgroundColor: mainPurpleColor,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        controller: _nameController,
                        labelText: 'Name',
                        icon: Icons.person,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
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
                      CustomInput(
                        controller: _contactNumController,
                        labelText: 'Contact Number',
                        icon: Icons.work,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
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
                      const SizedBox(height: 16),
                      CustomInput(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableButton(
                        text: 'Sign Up',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _createUser(context);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Navigate to login screen
                          GoRouter.of(context).go('/login');
                        },
                        child: const Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: mainWhiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
