import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../constants/colors.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final void Function(String otp)? onSubmit;

  const OtpScreen({Key? key, required this.phoneNumber, this.onSubmit})
    : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String _otpCode = '';
  bool otpLoading = false;

  @override
  void codeUpdated() {
    setState(() {
      _otpCode = code ?? '';
    });
    if (_otpCode.length == 6 && widget.onSubmit != null) {
      widget.onSubmit!(_otpCode);
    }
  }

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  void _submitOtp() {
    otpLoading = true;
    setState(() {});
    if (_otpCode.length == 6 && widget.onSubmit != null) {
      widget.onSubmit!(_otpCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        title: const Text('OTP Verification'),
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: AppColors.primary, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Enter the 6-digit OTP sent to',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.phoneNumber,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                PinFieldAutoFill(
                  codeLength: 6,
                  currentCode: _otpCode,
                  onCodeChanged: (code) {
                    setState(() {
                      _otpCode = code ?? '';
                    });
                  },
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(
                      fontSize: 24,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    colorBuilder: FixedColorBuilder(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.secondaryLite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _otpCode.length == 6 ? _submitOtp : null,
                    child: otpLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // TextButton(
                //   onPressed: () {
                //     // Add resend OTP logic here
                //   },
                //   child: Text(
                //     'Resend OTP',
                //     style: TextStyle(
                //       color: AppColors.primary,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
