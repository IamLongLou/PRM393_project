import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../services/customer_service.dart';
import '../../widgets/customer_card.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() =>
      _CustomerListScreenState();
}

class _CustomerListScreenState
    extends State<CustomerListScreen> {

  List<Customer> customers = [];
  List<Customer> filtered = [];

  @override
  void initState() {
    super.initState();

    customers = CustomerService.getCustomers();
    filtered = customers;
  }

  void search(String keyword) {

    setState(() {

      filtered = customers.where((c) {

        return c.name
            .toLowerCase()
            .contains(keyword.toLowerCase()) ||

            c.code
                .toLowerCase()
                .contains(keyword.toLowerCase());

      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Danh sách khách hàng"),
      ),

      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Tìm khách hàng",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {

                return CustomerCard(
                  customer: filtered[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}