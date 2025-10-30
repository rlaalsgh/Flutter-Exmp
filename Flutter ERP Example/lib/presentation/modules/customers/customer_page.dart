import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart'
    show Material, DataTable, DataRow, DataCell, DataColumn, Colors;
import 'dart:math';
import 'customer_model.dart';
import 'customer_form.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final List<Customer> _customers = List.generate(
    23,
    (i) => Customer(
      id: i + 1,
      name: '거래처 ${i + 1}',
      phone: '010-${1000 + i}-000${i % 10}',
      email: 'contact${i + 1}@corp.com',
      address: '서울특별시 ${i + 1}번지',
    ),
  );

  String _searchText = '';
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // ✅ 페이지 관련 상태
  int _currentPage = 0;
  final int _rowsPerPage = 8;

  List<Customer> get _filteredCustomers {
    var list = _customers;
    if (_searchText.isNotEmpty) {
      list = list
          .where((c) =>
              c.name.contains(_searchText) ||
              c.phone.contains(_searchText) ||
              c.address.contains(_searchText))
          .toList();
    }
    list.sort((a, b) {
      int compare;
      switch (_sortColumnIndex) {
        case 1:
          compare = a.name.compareTo(b.name);
          break;
        case 2:
          compare = a.phone.compareTo(b.phone);
          break;
        case 3:
          compare = a.email.compareTo(b.email);
          break;
        default:
          compare = a.id.compareTo(b.id);
      }
      return _sortAscending ? compare : -compare;
    });
    return list;
  }

  // ✅ 현재 페이지에 표시할 데이터
  List<Customer> get _pagedCustomers {
    final start = _currentPage * _rowsPerPage;
    final end = min(start + _rowsPerPage, _filteredCustomers.length);
    return _filteredCustomers.sublist(start, end);
  }

  // 📊 통계 데이터
  int get _newCustomersThisMonth => 1;
  int get _avgTransaction => 1350000 + Random().nextInt(500000);
  String get _lastOrderDate => "2025-10-23";

  void _showCustomerForm({Customer? customer}) async {
    final formKey = GlobalKey<CustomerFormState>();
    final result = await showDialog<Customer>(
      context: context,
      builder: (_) => ContentDialog(
        title: Text(customer == null ? '거래처 등록' : '거래처 수정'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: CustomerForm(key: formKey, customer: customer),
        ),
        actions: [
          Button(
              child: const Text('취소'), onPressed: () => Navigator.pop(context)),
          FilledButton(
            child: const Text('저장'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, formKey.currentState!.toCustomer());
              }
            },
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        if (customer == null) {
          final newId = _customers.isEmpty ? 1 : _customers.last.id + 1;
          _customers.add(result.copyWith(id: newId));
        } else {
          final index = _customers.indexWhere((c) => c.id == customer.id);
          if (index != -1) _customers[index] = result;
        }
      });
    }
  }

  void _showCustomerDetail(Customer c) {
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: Text('${c.name} 상세 정보'),
        content: SizedBox(
            width: 500, height: 400, child: _CustomerDetailView(customer: c)),
        actions: [
          FilledButton(
              child: const Text('닫기'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  // ✅ 정렬 토글 함수
  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('거래처 관리'),
        commandBar: Row(children: [
          FilledButton(
              child: const Text('+ 신규 등록'),
              onPressed: () => _showCustomerForm())
        ]),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 요약 카드
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('총 거래처', '${_customers.length}곳',
                  FluentTheme.of(context).accentColor),
              _buildStatCard(
                  '신규 거래처', '$_newCustomersThisMonth곳', Colors.green),
              _buildStatCard('평균 거래액', '₩${_avgTransaction.toStringAsFixed(0)}',
                  Colors.blue),
              _buildStatCard('최근 거래일', _lastOrderDate, Colors.orange),
            ],
          ),
          const SizedBox(height: 20),

          // 검색
          TextBox(
            placeholder: '거래처명 / 연락처 / 주소 검색',
            onChanged: (v) => setState(() => _searchText = v),
          ),
          const SizedBox(height: 15),

          // ✅ DataTable
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('ID'),
                      onSort: (i, asc) => _onSort(i, asc),
                    ),
                    DataColumn(
                      label: const Text('거래처명'),
                      onSort: (i, asc) => _onSort(i, asc),
                    ),
                    DataColumn(
                      label: const Text('연락처'),
                      onSort: (i, asc) => _onSort(i, asc),
                    ),
                    DataColumn(
                      label: const Text('이메일'),
                      onSort: (i, asc) => _onSort(i, asc),
                    ),
                    const DataColumn(label: Text('주소')),
                    const DataColumn(label: Text('관리')),
                  ],
                  rows: _pagedCustomers.map((c) {
                    return DataRow(cells: [
                      DataCell(Text(c.id.toString())),
                      DataCell(Text(c.name)),
                      DataCell(Text(c.phone)),
                      DataCell(Text(c.email)),
                      DataCell(Text(c.address)),
                      DataCell(Row(
                        children: [
                          Button(
                              child: const Text('보기'),
                              onPressed: () => _showCustomerDetail(c)),
                          const SizedBox(width: 8),
                          FilledButton(
                              child: const Text('수정'),
                              onPressed: () => _showCustomerForm(customer: c)),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),

          // ✅ 페이지네이션
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chevron_left_small),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              Text(
                  '${_currentPage + 1} / ${(_filteredCustomers.length / _rowsPerPage).ceil()}'),
              IconButton(
                icon: const Icon(FluentIcons.chevron_right_small),
                onPressed: (_currentPage + 1) * _rowsPerPage <
                        _filteredCustomers.length
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📊 카드 위젯
  Widget _buildStatCard(String title, String value, dynamic color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// ✅ 상세보기 그대로 유지
class _CustomerDetailView extends StatelessWidget {
  final Customer customer;
  const _CustomerDetailView({required this.customer});

  @override
  Widget build(BuildContext context) {
    final recentOrders = [
      {'date': '2025-10-01', 'item': '부품A', 'amount': 1250000},
      {'date': '2025-10-15', 'item': '부품B', 'amount': 940000},
      {'date': '2025-10-23', 'item': '자재C', 'amount': 2100000},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoLabel(label: '거래처명', child: Text(customer.name)),
        InfoLabel(label: '연락처', child: Text(customer.phone)),
        InfoLabel(label: '이메일', child: Text(customer.email)),
        InfoLabel(label: '주소', child: Text(customer.address)),
        const SizedBox(height: 15),
        const Text('최근 거래내역', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: recentOrders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final o = recentOrders[i];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(o['date'] as String),
                  Text(o['item'] as String),
                  Text('₩ ${(o['amount'] as int).toString()}'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
