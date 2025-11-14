// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../../constants/colors.dart';
import '../../../../services/firebase/auth.dart';
import '../../../components/custom_button.dart';
import '../../dashboard/dashboard_page.dart';
import '../otp/otp_screen.dart';

class RegisterPage extends StatefulWidget {
  bool isAddUser;
  RegisterPage({super.key, required this.isAddUser});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _image;
  AuthService authService = AuthService();
  String _countryCode = '+91';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: _pickImage,
                //   child: CircleAvatar(
                //     radius: 50,
                //     backgroundColor: AppColors.secondary.withOpacity(0.1),
                //     backgroundImage: _image != null ? FileImage(_image!) : null,
                //     child: _image == null
                //         ? const Icon(
                //             Icons.camera_alt,
                //             size: 40,
                //             color: Colors.blue,
                //           )
                //         : null,
                //   ),
                // ),
                SizedBox(
                  width: 316,
                  height: 116,
                  child: Image.asset("assets/logo.png"),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: AppColors.secondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    isDense: true, // Reduce height
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ), // Adjust as needed
                  ),
                  style: const TextStyle(color: AppColors.secondary),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(color: AppColors.secondary),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    isDense: true, // Reduce height
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 12,
                    ), // Adjust as needed
                    prefixIcon: Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: CountryCodePicker(
                        showFlag: false,
                        onChanged: (country) {
                          setState(() {
                            _countryCode = country.dialCode ?? '+91';
                          });
                        },
                        initialSelection: 'IN',
                        pickerStyle: PickerStyle.fullScreen,
                        favorite: const ['+91', 'IN'],
                        textStyle: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: AppColors.secondary),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.secondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.home,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    isDense: true, // Reduce height
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ), // Adjust as needed
                  ),
                  style: const TextStyle(color: AppColors.secondary),
                  keyboardType: TextInputType.streetAddress,
                ),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      try {
                        if (formKey.currentState!.validate()) {
                          final fullPhone =
                              '$_countryCode${_phoneController.text}';
                          authService.sendOTP(fullPhone);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                phoneNumber: _phoneController.text,
                                onSubmit: (otp) async {
                                  User? user = await authService.verifyOTP(
                                    otp,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                  );
                                  if (user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login successful!'),
                                      ),
                                    );

                                    final doc = await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .get();

                                    if (widget.isAddUser) {
                                      Navigator.pop(context);
                                    } else {
                                      if (doc.exists &&
                                          (doc.data()?['is_admin'] == true)) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const DashboardPage(
                                              isAdmin: true,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const DashboardPage(
                                              isAdmin: false,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    // ❌ Invalid OTP
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Invalid OTP. Please try again.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
                    child: CustomButton(
                      name: "Register",
                      textColor: AppColors.primary,
                      bgColor: AppColors.secondary,
                    ),
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
