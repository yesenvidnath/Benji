import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@email.com"),
            ),
            ListTile(
              title: const Text('Transactions'),
              onTap: () => Get.toNamed('/transactions'),
            ),
            ListTile(
              title: const Text('Budget'),
              onTap: () => Get.toNamed('/budget'),
            ),
            ListTile(
              title: const Text('Investments'),
              onTap: () => Get.toNamed('/investments'),
            ),
            ListTile(
              title: const Text('AI Insights'),
              onTap: () => Get.toNamed('/ai-insights'),
            ),
            ListTile(
              title: const Text('Financial Advice'),
              onTap: () => Get.toNamed('/financial-advice'),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () => Get.toNamed('/profile'),
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildDashboardCard('Total Balance', '\$5,000'),
          _buildDashboardCard('Monthly Savings', '\$1,200'),
          _buildDashboardCard('Total Expenses', '\$3,800'),
          _buildDashboardCard('Investments', '\$10,000'),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}