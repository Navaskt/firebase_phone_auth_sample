import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  /// Send OTP to the given phone number
  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto sign-in on Android devices (if SMS is auto-detected)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// Verify OTP and create/update user in Firestore
  Future<User?> verifyOTP(String smsCode, {String? name, String? email}) async {
    if (_verificationId == null) return null;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // ✅ Sign in user with OTP
      UserCredential userCred = await _auth.signInWithCredential(credential);
      User? user = userCred.user;

      if (user != null) {
        final docRef = _firestore.collection("users").doc(user.uid);

        // ✅ Check if user document already exists
        final doc = await _safeGetDoc(docRef);

        if (doc == null || !doc.exists) {
          // ✅ Add user details to Firestore
          await docRef.set({
            "name": name ?? "New User",
            "phone_number": user.phoneNumber,
            "email": email ?? "",
            "points": "0.0",
            "is_admin": false,
            "createdAt": FieldValue.serverTimestamp(),
          });
        } else {
          // ✅ Optionally update name if provided
          if (name != null && name.isNotEmpty) {
            await docRef.update({"name": name});
          }
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      log("OTP verification failed: ${e.message}");
      return null;
    } catch (e) {
      log("Unexpected error: $e");
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Safe Firestore get with retries (handles temporary failures)
  Future<DocumentSnapshot?> _safeGetDoc(DocumentReference docRef) async {
    int retries = 3;
    for (int i = 0; i < retries; i++) {
      try {
        return await docRef.get();
      } catch (e) {
        log("Firestore get failed (try ${i + 1}): $e");
        if (i == retries - 1) rethrow;
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
      }
    }
    return null;
  }

  Future<bool> isPhoneRegistered(String phoneNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('phone_number', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }
}
