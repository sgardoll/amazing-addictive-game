import 'package:flutter/material.dart';
import 'package:order_panic/core/models/customer.dart';

class CustomerView extends StatelessWidget {
  final Customer customer;

  const CustomerView({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final double patienceRatio = customer.maxPatience > 0
        ? (customer.currentPatience / customer.maxPatience).clamp(0.0, 1.0)
        : 0.0;
    final color = patienceRatio > 0.5
        ? Colors.green
        : (patienceRatio > 0.25 ? Colors.orange : Colors.red);

    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF37474F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              customer.order.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: LinearProgressIndicator(
              value: patienceRatio,
              color: color,
              backgroundColor: Colors.black26,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
