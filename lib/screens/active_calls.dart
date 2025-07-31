import 'package:flutter/material.dart';
// Import fl_chart but don't use the problematic features
import 'package:fl_chart/fl_chart.dart';

class ActiveCallsScreen extends StatelessWidget {
  ActiveCallsScreen({super.key});

  // Mock data moved to class level
  final List<Map<String, dynamic>> inProgressCalls = [
    {
      'id': '6140',
      'name': '1 - مجموعة منصصة',
      'launchDate': '2025-07-23 11:15 AM',
      'succeeded': 1,
      'notSucceeded': 1,
      'notCalled': 0
    },
    {
      'id': '6023',
      'name': 'test',
      'launchDate': '2025-04-24 04:23 PM',
      'succeeded': 1,
      'notSucceeded': 0,
      'notCalled': 0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.stacked_line_chart,
                      color: Color(0xFF1A237E), size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Call Statistics',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatusCards(context),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.sync, color: Color(0xFF1A237E), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'In Progress Calls',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              inProgressCalls.isEmpty
                  ? const Center(
                      child: Text('No calls in progress'),
                    )
                  : Column(
                      children: List.generate(
                        inProgressCalls.length,
                        (index) {
                          final call = inProgressCalls[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CallStatisticsDetailScreen(
                                      departmentName: call['name'] as String,
                                      succeeded: call['succeeded'] as int,
                                      notSucceeded: call['notSucceeded'] as int,
                                      notCalled: call['notCalled'] as int,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${call['id']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                call['name'] as String,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Launch Date: ${call['launchDate']}',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: _buildSimplePieChart(
                                            succeeded: call['succeeded'] as int,
                                            notSucceeded:
                                                call['notSucceeded'] as int,
                                            notCalled: call['notCalled'] as int,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCallStatistics(
                                      succeeded: call['succeeded'] as int,
                                      notSucceeded: call['notSucceeded'] as int,
                                      notCalled: call['notCalled'] as int,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            '${(call['succeeded'] as int) + (call['notSucceeded'] as int) + (call['notCalled'] as int)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Person'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    final statusData = [
      {'title': 'Pending', 'count': '2', 'color': Colors.amber},
      {'title': 'Draft', 'count': '94', 'color': Colors.blue},
      {'title': 'Ready To Launch', 'count': '22', 'color': Colors.blue},
      {'title': 'Need Correction', 'count': '0', 'color': Colors.amber},
    ];

    return SizedBox(
      height: 100, // Fixed height for the scrollable area
      child: SingleChildScrollView(
        // Add horizontal scrolling
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          child: Row(
            children: statusData.map((status) {
              return Container(
                width: 140, // Width of each card
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        status['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: status['color'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status['count'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCallStatistics({
    required int succeeded,
    required int notSucceeded,
    required int notCalled,
  }) {
    return Row(
      children: [
        _buildStatItem('Succeeded', succeeded, Colors.greenAccent.shade400),
        const SizedBox(width: 16),
        _buildStatItem(
            'Not Succeeded', notSucceeded, Colors.pinkAccent.shade100),
        const SizedBox(width: 16),
        _buildStatItem('Not Called', notCalled, Colors.grey.shade400),
      ],
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text('$label : $value'),
      ],
    );
  }

  // Simple pie chart implementation that avoids the problematic MediaQuery.boldTextOverride
  Widget _buildSimplePieChart({
    required int succeeded,
    required int notSucceeded,
    required int notCalled,
  }) {
    final total = succeeded + notSucceeded + notCalled;
    if (total == 0) {
      return const Center(child: Text('No data'));
    }

    // Calculate segments
    final double succeededAngle = 360 * (succeeded / total);
    final double notSucceededAngle = 360 * (notSucceeded / total);

    return CustomPaint(
      size: const Size(100, 100),
      painter: SimpleChartPainter(
        succeededPercentage: succeeded / total,
        notSucceededPercentage: notSucceeded / total,
        notCalledPercentage: notCalled / total,
        succeededColor: Colors.greenAccent.shade400,
        notSucceededColor: Colors.pinkAccent.shade100,
        notCalledColor: Colors.grey.shade400,
      ),
    );
  }
}

class SimpleChartPainter extends CustomPainter {
  final double succeededPercentage;
  final double notSucceededPercentage;
  final double notCalledPercentage;
  final Color succeededColor;
  final Color notSucceededColor;
  final Color notCalledColor;

  SimpleChartPainter({
    required this.succeededPercentage,
    required this.notSucceededPercentage,
    required this.notCalledPercentage,
    required this.succeededColor,
    required this.notSucceededColor,
    required this.notCalledColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw segments
    if (succeededPercentage > 0) {
      paint.color = succeededColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * 3.14159 * succeededPercentage,
        true,
        paint,
      );
    }

    if (notSucceededPercentage > 0) {
      paint.color = notSucceededColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        2 * 3.14159 * succeededPercentage,
        2 * 3.14159 * notSucceededPercentage,
        true,
        paint,
      );
    }

    if (notCalledPercentage > 0) {
      paint.color = notCalledColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        2 * 3.14159 * (succeededPercentage + notSucceededPercentage),
        2 * 3.14159 * notCalledPercentage,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CallStatisticsDetailScreen extends StatelessWidget {
  final String departmentName;
  final int succeeded;
  final int notSucceeded;
  final int notCalled;

  const CallStatisticsDetailScreen({
    super.key,
    required this.departmentName,
    required this.succeeded,
    required this.notSucceeded,
    required this.notCalled,
  });

  @override
  Widget build(BuildContext context) {
    final total = succeeded + notSucceeded + notCalled;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Call Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              departmentName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Launch Date: ${DateTime.now().toString().substring(0, 16)}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: SimpleChartPainter(
                    succeededPercentage: succeeded / total,
                    notSucceededPercentage: notSucceeded / total,
                    notCalledPercentage: notCalled / total,
                    succeededColor: Colors.greenAccent.shade400,
                    notSucceededColor: Colors.pinkAccent.shade100,
                    notCalledColor: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildStatisticsList(),
            const Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Person',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsList() {
    return Column(
      children: [
        _buildStatItem('Succeeded', succeeded, Colors.greenAccent.shade400),
        const SizedBox(height: 16),
        _buildStatItem(
            'Not Succeeded', notSucceeded, Colors.pinkAccent.shade100),
        const SizedBox(height: 16),
        _buildStatItem('Not Called', notCalled, Colors.grey.shade400),
      ],
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 12),
        Text(
          '$label : $value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
