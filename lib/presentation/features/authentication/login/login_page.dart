import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_sample/presentation/features/authentication/otp/otp_screen.dart'
    show OtpScreen;
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../services/firebase/auth.dart';
import '../../../components/custom_button.dart';
import '../../dashboard/dashboard_page.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  AuthService authService = AuthService();
  String _countryCode = '+91';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 316,
                height: 116,
                child: Image.asset("assets/logo.png"),
              ),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 25),
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
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      {
                        setState(() => isLoading = true);

                        final fullPhoneNumber =
                            '$_countryCode${_phoneController.text}';
                        final exists = await authService.isPhoneRegistered(
                          fullPhoneNumber,
                        );

                        if (!exists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'This number is not registered. Please register first.',
                              ),
                            ),
                          );
                          setState(() => isLoading = false);
                          return;
                        }
                        await authService.sendOTP(fullPhoneNumber);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              phoneNumber: fullPhoneNumber,
                              onSubmit: (otp) async {
                                User? user = await authService.verifyOTP(otp);
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

                                  if (doc.exists &&
                                      (doc.data()?['is_admin'] == true)) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DashboardPage(isAdmin: true),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DashboardPage(isAdmin: false),
                                      ),
                                    );
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
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error sending OTP: ${e.toString()}'),
                        ),
                      );
                    }
                  },
                  child: CustomButton(
                    name: "Login",
                    bgColor: AppColors.secondaryLite,
                    textColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(isAddUser: false),
                    ),
                  );
                },
                child: const Text(
                  'Don,t have an account ? Register',
                  style: TextStyle(
                    color: AppColors.secondaryLite,
                    fontSize: 10.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
