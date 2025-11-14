import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../../../services/firebase/auth.dart';
import '../../../services/firebase/purchases.dart';
import '../../../services/firebase/redeem.dart';
import '../../../services/firebase/users.dart';
import '../../../services/network/connectivity.dart';
import '../../components/loyality_card.dart';
import '../authentication/login/login_page.dart';
import '../authentication/register/register_page.dart';
import '../user_details/views/user_details.dart';

class DashboardPage extends StatefulWidget {
  final bool isAdmin;
  const DashboardPage({super.key, required this.isAdmin});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService authService = AuthService();

  String userId = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  double points = 0.0;

  List<UserModel> userList = [];
  List<Purchase> purchaseList = [];
  List<Redeem> redeemList = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ No internet connection'),
            backgroundColor: Colors.redAccent,
            duration: Duration(days: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    getUser();
    if (widget.isAdmin) {
      fetchUsers();
    } else {
      fetchUserPurchases();
      fetchUserRedeems();
    }
  }

  // 🔹 Fetch current user info safely
  Future<void> getUser() async {
    if (!await checkInternetConnection(context)) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("No logged-in user");
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        log("✅ User data fetched: $data");

        setState(() {
          userId = user.uid;
          userName = data['name'] ?? 'Guest';
          userEmail = data['email'] ?? '';
          userPhone = data['phone_number']?.toString() ?? '';

          final rawPoints = data['points'];
          if (rawPoints is int) {
            points = rawPoints.toDouble();
          } else if (rawPoints is double) {
            points = rawPoints;
          } else if (rawPoints is String) {
            points = double.tryParse(rawPoints) ?? 0.0;
          } else {
            points = 0.0;
          }
        });
      } else {
        log("⚠️ User document not found in Firestore");
      }
    } catch (e, s) {
      log("❌ Error fetching Firestore user data: $e");
      log(s.toString());
    }
  }

  Future<void> fetchUserPurchases() async {
    if (!await checkInternetConnection(context)) return;
    try {
      final purchases = await getUserPurchases(userId);
      setState(() {
        purchaseList = purchases;
      });
    } catch (e) {
      purchaseList = [];
    }
  }

  Future<void> fetchUserRedeems() async {
    if (!await checkInternetConnection(context)) return;
    try {
      final redeems = await getUserRedeems(userId);
      setState(() {
        redeemList = redeems;
      });
    } catch (e) {
      redeemList = [];
    }
  }

  Future<void> fetchUsers() async {
    if (!await checkInternetConnection(context)) return;
    try {
      final fetchedUsers = await getUsers();
      setState(() {
        userList = fetchedUsers;
      });
    } catch (e) {
      log("❌ Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Text(
                  widget.isAdmin ? 'Admin Menu' : 'User Menu',
                  style: const TextStyle(
                    color: AppColors.secondaryLite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: AppColors.primary),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              if (!widget.isAdmin)
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: AppColors.primary,
                  ),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pop(context),
                ),
              if (widget.isAdmin)
                ListTile(
                  leading: const Icon(
                    Icons.person_add,
                    color: AppColors.primary,
                  ),
                  title: const Text('Add user'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(isAddUser: true),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.primary),
                title: const Text('Logout'),
                onTap: () {
                  authService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.1,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset.zero,
                  blurRadius: 1,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.secondaryLite,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              color: AppColors.secondaryLite,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // const SizedBox(height: 3.0),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              color: AppColors.secondaryLite,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontFamily: "Lobster",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (!await checkInternetConnection(context)) return;
            await getUser();
            if (widget.isAdmin) {
              await fetchUsers();
            } else {
              await fetchUserPurchases();
              await fetchUserRedeems();
            }
            setState(() {});
          },
          child: widget.isAdmin ? buildAdminView() : buildUserView(),
        ),
      ),
    );
  }

  // 🔹 Admin view
  Widget buildAdminView() {
    final filteredUsers = userList
        .where((user) => user.name.toLowerCase().contains(searchQuery))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  setState(() => searchQuery = value.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                        style: const TextStyle(
                          color: AppColors.secondaryLite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${user.phoneNumber}'),
                        Text('Email: ${user.email}'),
                        Text(
                          "🕓 Joined: ${DateFormat('MMM d, yyyy').format(user.createdAt)}",
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Points',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        Text(
                          user.points?.toString() ?? '0',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(
                            id: user.uid,
                            isAdmin: widget.isAdmin,
                          ),
                        ),
                      ).then((value) => fetchUsers());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 User view
  Widget buildUserView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          LoyaltyPointsCard(points: points.toString()),
          const SizedBox(height: 24),
          const Text(
            'Purchase History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          purchaseList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No purchases found.',
                    style: TextStyle(color: AppColors.primary),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: purchaseList.length,
                    itemBuilder: (context, index) {
                      final purchase = purchaseList[index];
                      final totalPoints =
                          (int.tryParse(purchase.amount)! ~/ 10);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${purchase.date}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Points Earned: $totalPoints',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Amount: ₹${purchase.amount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 24),
          const Text(
            'Redeem History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          redeemList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No redeem history found.',
                    style: TextStyle(color: AppColors.primary),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: redeemList.length,
                    itemBuilder: (context, index) {
                      final redeem = redeemList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${redeem.date}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Points Redeemed: ${redeem.points}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'User: ${redeem.userName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
