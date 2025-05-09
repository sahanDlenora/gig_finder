import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gig_finder/models/user_model.dart';
import 'package:gig_finder/service/auth/auth_services.dart';
import 'package:gig_finder/service/users/user_service.dart';
import 'package:gig_finder/service/users/user_storage.dart';
import 'package:gig_finder/utils/constants/colors.dart';
import 'package:gig_finder/utils/functions/functions.dart';
import 'package:gig_finder/widgets/reusable/custom_button.dart';
import 'package:gig_finder/widgets/reusable/custom_input.dart';
import 'package:gig_finder/widgets/reusable/mediaIcon.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

  File? _imageFile;

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

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dzvl2bdix/image/upload";
    String uploadPreset = "profilepicpreset";

    var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      print("Cloudinary Response: $jsonResponse"); // Debugging
      return jsonResponse['secure_url'];
    } else {
      var errorResponse = await response.stream.bytesToString();
      print("Failed to upload image: $errorResponse"); // Debugging
      return null;
    }
  }

  // Sign up with email and password
  Future<void> _createUser(BuildContext context) async {
    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImageToCloudinary(_imageFile!);
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
          profilePicture: imageUrl ?? "", // Store image URL in Firestore
          about: _aboutController.text, // Assuming you have an about controller
          rating: 0.0, // Default rating for a new user
          password: _passwordController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Show snackbar
      if (context.mounted) {
        UtilFunctions().showSnackBar(
            context: context, message: "User created Successfully..");
      }
      // Navigate to the main screen
      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing up with email and password: $e');
      // Show snackbar with error message
      if (context.mounted) {
        UtilFunctions().showSnackBar(
            context: context,
            message: "Error signing up with email and password: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register Account',
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 45,
                                  backgroundImage: FileImage(_imageFile!),
                                  backgroundColor: Colors.grey,
                                )
                              : const CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                  backgroundColor: Colors.grey,
                                ),
                          Positioned(
                            bottom: -13,
                            left: 50,
                            child: IconButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.add_a_photo),
                              iconSize: 19,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Add Your Profile picture",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
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
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await _createUser(context);
                              if (context.mounted) {
                                GoRouter.of(context)
                                    .go('/login'); // Navigate to login page
                              }
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
                            'Register',
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
                          const Text('Already have an account?'),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/login');
                            },
                            child: const Text(
                              ' Login',
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
      ),
    );
  }
}
