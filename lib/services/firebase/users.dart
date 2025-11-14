import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String points;
  final bool isAdmin;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.points,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      points: data['points'] ?? 0,
      isAdmin: data['is_admin'] ?? false,
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'points': points,
      'is_admin': isAdmin,
      'createdAt': createdAt,
    };
  }
}

Future<List<UserModel>> getUsers() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    List<UserModel> users = snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();

    log("✅ Fetched ${users.length} users");
    for (var u in users) {
      log("${u.name} (${u.email}) - Points: ${u.points}");
    }

    return users;
  } catch (e) {
    log("❌ Error fetching users: $e");
    return [];
  }
}

Future<UserModel?> getUser(String userId) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      final userModel = UserModel.fromFirestore(userDoc);
      log("✅ User data fetched: $data");
      return userModel;
    } else {
      log("⚠️ User document not found in Firestore");
    }
  } catch (e) {
    log("❌ Error fetching Firestore user data: $e");
  }
  return null;
}

Future<void> updateUserPoints(String userId, String newPoints) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final userRef = firestore.collection('users').doc(userId);

    await userRef.update({'points': newPoints});

    log('✅ User points updated successfully!');
  } catch (e) {
    log('❌ Error updating user points: $e');
  }
}
