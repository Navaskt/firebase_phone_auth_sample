import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Purchase {
  final String id;
  final String amount;
  final String billNo;
  final String date;
  final String name;
  final String points;
  final String userId;

  Purchase({
    required this.id,
    required this.amount,
    required this.billNo,
    required this.date,
    required this.name,
    required this.points,
    required this.userId,
  });

  factory Purchase.fromMap(Map<String, dynamic> data, String documentId) {
    return Purchase(
      id: documentId,
      amount: data['amount'] ?? '',
      billNo: data['bill_no'] ?? '',
      date: data['date'] ?? '',
      name: data['name'] ?? '',
      points: data['points'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'bill_no': billNo,
      'date': date,
      'name': name,
      'points': points,
      'user_id': userId,
    };
  }

  void operator [](String other) {}
}

Future<List<Purchase>> getUserPurchases(String uId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('purchases')
        .where('user_id', isEqualTo: uId)
        .get();

    log("✅ Logging purchases for user: $uId");
    log(snapshot.docs.map((doc) => doc.data()).toList().toString());

    // Convert Firestore docs into List<Purchase>
    final purchases = snapshot.docs
        .map((doc) => Purchase.fromMap(doc.data(), doc.id))
        .toList();

    return purchases;
  } catch (e) {
    log("❌ Error fetching purchases: $e");
    return [];
  }
}

Future<void> addPurchase({
  required String userId,
  required String billNo,
  required String date,
  required String name,
  required String amount,
  required String points,
}) async {
  try {
    final purchaseData = {
      "bill_no": billNo,
      "date": date,
      "name": name,
      "amount": amount,
      "points": points,
      "user_id": userId,
      "created_at": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection("purchases").add(purchaseData);

    log("✅ Purchase added successfully!");
  } catch (e) {
    log("❌ Error adding purchase: $e");
  }
}
