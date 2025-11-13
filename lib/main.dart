// classpath 'com.google.gms:google-services:4.4.4'

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Phone Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PhoneAuthPage(),
    );
  }
}

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;
  String? _status;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    setState(() => _status = message);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendCode() async {
    final raw = _phoneController.text.trim();

    // You must use E.164 format. For UAE: +9715XXXXXXXX
    if (raw.isEmpty || !raw.startsWith('+')) {
      _showMessage('Enter phone number with country code, e.g. +9715XXXXXXXX');
      return;
    }

    setState(() {
      _loading = true;
      _status = 'Sending code...';
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: raw,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _showMessage('Auto verification success, you are signed in.');
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('verificationFailed code: ${e.code}');
          debugPrint('verificationFailed message: ${e.message}');
          _showMessage('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
          });
          _showMessage('Code sent. Check your SMS.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          debugPrint('timeout: $verificationId');
        },
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) {
      _showMessage('No verificationId. Send code first.');
      return;
    }

    final code = _otpController.text.trim();
    if (code.length < 6) {
      _showMessage('Enter 6-digit code.');
      return;
    }

    setState(() {
      _loading = true;
      _status = 'Verifying code...';
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential);

      final user = _auth.currentUser;
      _showMessage('Login success. UID: ${user?.uid}');
    } on FirebaseAuthException catch (e) {
      _showMessage('Code invalid: ${e.message}');
      debugPrint('verifyCode error code: ${e.code}');
      debugPrint('verifyCode error message: ${e.message}');
    } catch (e, st) {
      debugPrint('verifyCode unknown error: $e');
      debugPrint('$st');
      _showMessage('Unknown error while verifying code.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Phone login',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone number',
            hintText: '+9715XXXXXXXX',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : _sendCode,
          child: Text(_loading ? 'Please wait...' : 'Send OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    if (!_codeSent) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Enter SMS code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'OTP',
            hintText: '6-digit code',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : _verifyCode,
          child: Text(_loading ? 'Please wait...' : 'Verify OTP'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Phone Auth'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
                _showMessage('Signed out');
                setState(() {});
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (user != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logged in. UID: ${user.uid}'),
                  const SizedBox(height: 12),
                ],
              ),
            _buildPhoneForm(),
            _buildOtpForm(),
            const SizedBox(height: 24),
            if (_status != null)
              Text('Status: $_status', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
