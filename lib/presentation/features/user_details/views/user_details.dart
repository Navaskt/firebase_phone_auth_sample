import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../services/firebase/purchases.dart';
import '../../../../services/firebase/redeem.dart';
import '../../../../services/firebase/users.dart';
import '../../admin_panel/views/add_purchase.dart';

class UserDetailsPage extends StatefulWidget {
  String id;
  bool isAdmin;
  UserDetailsPage({super.key, required this.id, required this.isAdmin});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<Purchase> purchaseList = [];
  List<Redeem> redeemList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  UserModel? user;

  loadData() {
    getUserDetails();
    fetchUserPurchases();
    fetchUserRedeems();
  }

  Future<void> fetchUserPurchases() async {
    try {
      final purchases = await getUserPurchases(widget.id);
      setState(() {
        purchaseList = purchases;
      });
    } catch (e) {
      purchaseList = [];
    }
  }

  Future<void> fetchUserRedeems() async {
    try {
      final redeems = await getUserRedeems(widget.id);
      setState(() {
        redeemList = redeems;
      });
    } catch (e) {
      redeemList = [];
    }
  }

  getUserDetails() async {
    try {
      user = await getUser(widget.id);
      setState(() {});
      isLoading = false;
    } catch (e) {
      isLoading = true;
      log("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondaryLite,
        title: Text(isLoading ? "" : user!.name),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadData();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: 32,
                              child: Text(
                                isLoading ? "U" : (user!.name)[0],
                                style: const TextStyle(
                                  color: AppColors.secondaryLite,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isLoading ? "" : user!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Phone: ${isLoading ? "" : user!.phoneNumber}',
                                  ),
                                  Text(
                                    'Email: ${isLoading ? "" : user!.email}',
                                  ),
                                  Text(
                                    "Joined: ${isLoading ? "" : DateFormat('MMM d, yyyy').format(user!.createdAt)}",
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: isLoading ? false : widget.isAdmin,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.secondaryLite,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text(
                                    'Add Purchase',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPurchasePage(
                                          id: widget.id,
                                          name: isLoading ? "" : user!.name,
                                        ),
                                      ),
                                    ).then((_) {
                                      loadData();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      '✩ ${isLoading ? "" : user!.points.toString()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.secondaryLite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.redeem,
                                    color: Colors.amber,
                                  ),
                                  label: const Text(
                                    'Redeem Points',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        final redeemController =
                                            TextEditingController(
                                              text: user!.points.toString(),
                                            );
                                        return Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Redeem Points',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                TextFormField(
                                                  controller: redeemController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Points to Redeem',
                                                    labelStyle: TextStyle(
                                                      color: AppColors.primary,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                                width: 2,
                                                              ),
                                                        ),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 12,
                                                        ),
                                                    prefixIcon: Icon(
                                                      Icons.star,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                  ),
                                                  validator: (value) {
                                                    double entered =
                                                        double.tryParse(
                                                          value ?? '',
                                                        ) ??
                                                        0;
                                                    double maxPoints =
                                                        double.tryParse(
                                                          user!.points
                                                              .toString(),
                                                        ) ??
                                                        0;
                                                    if (entered > maxPoints) {
                                                      return 'Cannot redeem more than $maxPoints points';
                                                    }
                                                    if (entered < 1) {
                                                      return 'Enter at least 1 point';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 24),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      foregroundColor: AppColors
                                                          .secondaryLite,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 14,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (formKey.currentState
                                                              ?.validate() ??
                                                          false) {
                                                        double balancepoints =
                                                            (double.tryParse(
                                                                  user!.points
                                                                      .toString(),
                                                                ) ??
                                                                0) -
                                                            (double.tryParse(
                                                                  redeemController
                                                                      .text,
                                                                ) ??
                                                                0);
                                                        updateUserPoints(
                                                          widget.id,
                                                          balancepoints
                                                              .toString(),
                                                        );
                                                        addRedeem(
                                                          date:
                                                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                                          points:
                                                              redeemController
                                                                  .text,
                                                          userId: widget.id,
                                                          userName: user!.name
                                                              .toString(),
                                                        );
                                                        loadData();
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Redeemed ${redeemController.text} points!',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Redeem',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Purchase History',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                purchaseList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'No purchases found.',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchaseList.length,
                        itemBuilder: (context, index) {
                          final purchase = purchaseList[index];
                          // Calculate totalPoints for each purchase (example: based on amount)
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
                                      fontSize: 15,
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
                const SizedBox(height: 24),
                Text(
                  'Redeem History',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                redeemList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'No redeem history found.',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      )
                    : ListView.builder(
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
                                      fontSize: 15,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
