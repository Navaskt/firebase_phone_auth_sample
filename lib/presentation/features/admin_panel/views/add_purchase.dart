import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../services/firebase/purchases.dart';
import '../../../../services/firebase/users.dart';

class AddPurchasePage extends StatefulWidget {
  String name;
  String id;
  AddPurchasePage({super.key, required this.id, required this.name});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController billNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  String billType = 'Retail';
  int creditCount = 3;
  int percentage = 3;
  UserModel? user;
  double userTotalPoints = 0;

  @override
  void initState() {
    nameController.text = widget.name;
    getUserPoints();
    billType = 'Retail';
    creditCount = billType == 'Wholesale' ? 2 : 3;
    percentage = 3;
    super.initState();
  }

  @override
  void dispose() {
    billNoController.dispose();
    dateController.dispose();
    nameController.dispose();
    amountController.dispose();
    pointsController.dispose();
    super.dispose();
  }

  void _submitPurchase() {
    try {
      if (formKey.currentState?.validate() ?? false) {
        addPurchase(
          userId: widget.id,
          billNo: billNoController.text,
          date: dateController.text,
          name: nameController.text,
          amount: amountController.text,
          points: pointsController.text,
        );
        double totalPoints =
            userTotalPoints + (double.tryParse(pointsController.text) ?? 0);
        updateUserPoints(widget.id, totalPoints.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase added successfully!')),
        );
        // Clear fields after submission
        billNoController.clear();
        dateController.clear();
        nameController.text = widget.name;
        amountController.clear();
        pointsController.clear();
      }
    } catch (e) {
      log("❌ Error adding purchase: $e");
    }
  }

  getUserPoints() async {
    user = await getUser(widget.id);
    setState(() {
      userTotalPoints = (double.tryParse(user?.points ?? '0') ?? 0).toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Purchase'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondaryLite,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: billNoController,
                decoration: const InputDecoration(
                  labelText: 'Bill Number',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(Icons.receipt, color: AppColors.primary),
                ),
                style: const TextStyle(color: AppColors.primary),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter bill number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                  ),
                ),
                style: const TextStyle(color: AppColors.primary),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Format as day month year
                    dateController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')} "
                        "${_monthName(pickedDate.month)} "
                        "${pickedDate.year}";
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                ),
                style: const TextStyle(color: AppColors.primary),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Bill Type',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.receipt_long,
                    color: AppColors.primary,
                  ),
                ),
                style: const TextStyle(color: AppColors.primary),
                items: const [
                  DropdownMenuItem(
                    value: 'Wholesale',
                    child: Text('Wholesale'),
                  ),
                  DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                ],
                onChanged: (value) {
                  setState(() {
                    billType = value ?? 'Retail';
                    creditCount = billType == 'Wholesale'
                        ? 2
                        : 3; // <-- changed here
                    percentage = 3;
                    _updatePoints();
                  });
                },
                value: billType,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select bill type' : null,
              ),
              const SizedBox(height: 16),
              // Credits and Percentage fields above Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Headings to start
                      children: [
                        const Text(
                          'Credits',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(36, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (creditCount > 1) creditCount--;
                                    _updatePoints();
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  creditCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(36, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    creditCount++;
                                    _updatePoints();
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Headings to start
                      children: [
                        const Text(
                          'Percentage',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(36, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (percentage > 1) percentage--;
                                    _updatePoints();
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  percentage.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(36, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    percentage++;
                                    _updatePoints();
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: AppColors.primary,
                  ),
                ),
                style: const TextStyle(color: AppColors.primary),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter amount' : null,
                onChanged: (value) {
                  setState(() {
                    _updatePoints();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: pointsController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Points',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(Icons.star, color: AppColors.primary),
                ),
                style: const TextStyle(color: AppColors.primary),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter points' : null,
              ),
              const SizedBox(height: 28),
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
                  onPressed: _submitPurchase,
                  child: const Text(
                    'Add Purchase',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePoints() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final calculatedPoints = (amount * percentage / 100 * creditCount)
        .toStringAsFixed(2);
    pointsController.text = calculatedPoints;
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
