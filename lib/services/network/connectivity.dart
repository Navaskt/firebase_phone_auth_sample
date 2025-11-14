// ✅ Connectivity check before API calls
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> checkInternetConnection(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Please check your network.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return false;
  }
  return true;
}
