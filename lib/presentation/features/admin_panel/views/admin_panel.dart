import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../authentication/register/register_page.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondaryLite,
        elevation: 0,
      ),
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person_add,
                  color: AppColors.primary,
                  size: 32,
                ),
                title: const Text(
                  'Add User',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text('Register a new user in the system'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(isAddUser: true),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primary,
                  size: 32,
                ),
                title: const Text(
                  'Add Purchase',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text('Add a purchase for a user'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>  RegisterPage(),
                  //   ),
                  // );
                },
              ),
            ),
            // const SizedBox(height: 24),
            // Card(
            //   elevation: 4,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: ListTile(
            //     leading: Icon(
            //       Icons.list_alt,
            //       color: AppColors.primary,
            //       size: 32,
            //     ),
            //     title: const Text(
            //       'View Users',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            //     ),
            //     subtitle: const Text('See all registered users'),
            //     trailing: Icon(
            //       Icons.arrow_forward_ios,
            //       color: AppColors.primary,
            //     ),
            //     onTap: () {
            //       Navigator.pushNamed(
            //         context,
            //         '/dashboard',
            //         arguments: {'isAdmin': true},
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
