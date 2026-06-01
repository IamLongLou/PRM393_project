import 'package:flutter/material.dart';

import '../models/customer.dart';

class CustomerCard extends StatelessWidget {

  final Customer customer;

  const CustomerCard({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(customer.id.toString()),
        ),

        title: Text(customer.name),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.code),
            Text(customer.address),
          ],
        ),

        trailing: Text(
          customer.oldReading.toString(),
        ),
      ),
    );
  }
}