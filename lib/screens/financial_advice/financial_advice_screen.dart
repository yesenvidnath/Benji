import 'package:flutter/material.dart';

class FinancialAdviceScreen extends StatelessWidget {
  const FinancialAdviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Advice')),
      body: const Center(child: Text('Financial Advice Screen')),
    );
  }
}