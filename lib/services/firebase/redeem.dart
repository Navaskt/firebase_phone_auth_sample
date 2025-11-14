import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Redeem {
  final String id;
  final String date;
  final String points;
  final String userId;
  final String userName;

  Redeem({
    required this.id,
    required this.date,
    required this.points,
    required this.userId,
    required this.userName,
  });

  // ✩ Convert Firestore data → Redeem model
  factory Redeem.fromMap(Map<String, dynamic> data, String documentId) {
    return Redeem(
      id: documentId,
      date: data['date'] ?? '',
      points: data['points']?.toString() ?? '',
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
    );
  }

  // ✩ Convert model → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'points': points,
      'user_id': userId,
      'user_name': userName,
    };
  }

  void operator [](String other) {}
}

//
// ✩ Fetch all redeems for current user
//
Future<List<Redeem>> getUserRedeems(String uId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('redeems')
        .where('user_id', isEqualTo: uId)
        .get();

    log("✅ Logging redeems for user: ${uId}");
    log(snapshot.docs.map((doc) => doc.data()).toList().toString());

    // ✩ Convert Firestore docs → List<Redeem>
    final redeems = snapshot.docs
        .map((doc) => Redeem.fromMap(doc.data(), doc.id))
        .toList();

    return redeems;
  } catch (e) {
    log("❌ Error fetching redeems: $e");
    return [];
  }
}

//
// ✩ Add new redeem entry
//
Future<void> addRedeem({
  required String date,
  required String points,
  required String userId,
  required String userName,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("❌ No user logged in");
      return;
    }

    final redeemData = {
      "date": date,
      "points": points,
      "user_id": userId,
      "user_name": userName,
      "created_at": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection("redeems").add(redeemData);

    log("✅ Redeem added successfully!");
  } catch (e) {
    log("❌ Error adding redeem: $e");
  }
}
