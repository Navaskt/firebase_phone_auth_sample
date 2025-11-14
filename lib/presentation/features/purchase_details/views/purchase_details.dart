import 'package:flutter/material.dart';
import '../../../../constants/colors.dart'; // Add this import if you have AppColors

class PurchaseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> purchaseDetails;

  const PurchaseDetailsPage({Key? key, required this.purchaseDetails})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = purchaseDetails['items'] as List<Map<String, dynamic>>? ?? [];
    final total = purchaseDetails['total'] ?? 0.0;
    final date = purchaseDetails['date'] ?? '';
    final billNumber = purchaseDetails['billNumber'] ?? '';
    final vendor = purchaseDetails['vendor'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.secondaryLite.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bill Number:',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              billNumber,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date:',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(date, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vendor:',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(vendor, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Items:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...items.map(
                          (item) => Card(
                            color: AppColors.primary.withOpacity(0.07),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                item['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Qty: ${item['quantity']}  Rate: ${item['rate']}',
                                style: TextStyle(color: AppColors.primary),
                              ),
                              trailing: Text(
                                '₹${item['amount']}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 32),
                        ListTile(
                          title: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            '₹$total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.secondaryLite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Purchase',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addPurchase');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
