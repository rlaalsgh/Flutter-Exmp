import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataTable, DataRow, DataCell, DataColumn;
import 'package:flutter_erp_ui/core/notification_service.dart'; // ✅ 알림 서비스 추가

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Random _rnd = Random();
  late Timer _timer;

  List<double> salesData = [8.5, 10.2, 9.1, 12.4, 11.6, 13.8];
  Map<String, double> salesRatio = {'국내 거래': 65.0, '해외 수출': 25.0, '기타': 10.0};
  Map<String, double> topCustomers = {
    '홍길동상사': 3200000,
    '이몽룡무역': 2800000,
    '성춘향상회': 2400000,
    '변학도상사': 2000000,
    '심청상회': 1700000,
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _updateData());
  }

  void _updateData() {
    setState(() {
      salesData = salesData.map((v) => v + _rnd.nextDouble() * 2 - 1).toList();

      double domestic = 60.0 + _rnd.nextInt(20).toInt();
      double export = 100.0 - domestic - _rnd.nextInt(10).toInt();
      salesRatio = {
        '국내 거래': domestic,
        '해외 수출': export,
        '기타': (100.0 - domestic - export).clamp(5, 20).toDouble(),
      };

      // 거래처별 매출 랜덤 변경
      topCustomers = {
        for (var entry in topCustomers.entries)
          entry.key: (entry.value + _rnd.nextInt(500000) - 200000)
              .clamp(1000000, 5000000)
              .toDouble(),
      };
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _showTestNotification() async {
    await NotificationService().showInstantNotification(
      'ERP 시스템 알림',
      '새로운 매출 데이터가 업데이트되었습니다.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('대시보드')),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                _StatCard(title: '총 거래처 수', value: '58'),
                _StatCard(title: '이번 달 매출', value: '₩ 12,480,000'),
                _StatCard(title: '미수금', value: '₩ 2,350,000'),
              ],
            ),
            const SizedBox(height: 30),
            FilledButton(
              child: const Text('테스트 알림 보내기'),
              onPressed: () async {
                await NotificationService().showInstantNotification(
                  'ERP 시스템',
                  '테스트 알림이 도착했습니다!',
                );
              },
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _SalesBarChart(salesData: salesData)),
                  const SizedBox(width: 20),
                  Expanded(child: _SalesPieChart(salesRatio: salesRatio)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _TopCustomerChart(customers: topCustomers)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x11000000))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// 월별 매출 그래프
class _SalesBarChart extends StatelessWidget {
  final List<double> salesData;
  const _SalesBarChart({required this.salesData});

  @override
  Widget build(BuildContext context) {
    final months = ['4월', '5월', '6월', '7월', '8월', '9월'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '월별 매출 추이',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        int i = v.toInt();
                        if (i < 0 || i >= months.length) return Container();
                        return Text(months[i]);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  salesData.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: salesData[i],
                        color: Colors.blue,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}

// 거래 유형 도넛 그래프
class _SalesPieChart extends StatelessWidget {
  final Map<String, double> salesRatio;
  const _SalesPieChart({required this.salesRatio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '거래 유형 비율',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: salesRatio.entries.map((e) {
                  final color = switch (e.key) {
                    '국내 거래' => Colors.blue,
                    '해외 수출' => Colors.teal,
                    _ => Colors.orange,
                  };
                  return PieChartSectionData(
                    value: e.value,
                    title: '${e.value.toStringAsFixed(1)}%',
                    color: color,
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}

// 거래처별 매출 TOP5
class _TopCustomerChart extends StatelessWidget {
  final Map<String, double> customers;
  const _TopCustomerChart({required this.customers});

  @override
  Widget build(BuildContext context) {
    final sorted = customers.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '거래처별 매출 TOP 5',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: List.generate(sorted.length, (i) {
                  final e = sorted[i];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: e.value / 1000000, // 단위: 백만 원
                        color: Colors.purple,
                        width: 25,
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        int i = v.toInt();
                        if (i < 0 || i >= sorted.length) return Container();
                        return Text(
                          sorted[i].key,
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
