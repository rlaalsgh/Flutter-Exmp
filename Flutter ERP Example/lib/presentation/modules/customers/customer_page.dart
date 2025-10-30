import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'customer_model.dart';
import 'customer_form.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final List<Customer> customers = [
    Customer(
        id: 1,
        name: '내회사',
        phone: '010-1111-2222',
        email: 'my@mymy.com',
        address: '배시시 만지면 녹으리'),
    Customer(
        id: 2,
        name: '김민호씨',
        phone: '010-3333-4444',
        email: 'kim@mymym.com',
        address: '의정부시 신곡동'),
  ];

  void addCustomer(Customer c) {
    setState(() {
      customers.add(c);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('거래처 관리')),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Text('신규 등록'),
            onPressed: () async {
              final newCustomer = await showDialog<Customer>(
                context: context,
                builder: (_) => ContentDialog(
                  title: const Text('거래처 등록'),
                  constraints:
                      const BoxConstraints(maxWidth: 450, maxHeight: 500),
                  content: const SizedBox(
                    width: 400,
                    height: 380,
                    child: SingleChildScrollView(child: CustomerForm()),
                  ),
                ),
              );
              if (newCustomer != null) addCustomer(newCustomer);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: m.DataTable(
                columns: const [
                  m.DataColumn(label: Text('ID')),
                  m.DataColumn(label: Text('거래처명')),
                  m.DataColumn(label: Text('연락처')),
                  m.DataColumn(label: Text('이메일')),
                  m.DataColumn(label: Text('주소')),
                ],
                rows: customers.map((c) {
                  return m.DataRow(cells: [
                    m.DataCell(Text(c.id.toString())),
                    m.DataCell(Text(c.name)),
                    m.DataCell(Text(c.phone)),
                    m.DataCell(Text(c.email)),
                    m.DataCell(Text(c.address)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
