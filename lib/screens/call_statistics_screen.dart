import 'dart:async';

import 'package:blast_caller_app/models/enums/enums.dart';
import 'package:blast_caller_app/services/notification_service.dart';
import 'package:flutter/material.dart';

class CallStatisticsScreen extends StatefulWidget {
  // Optional: You can keep this if you want to pass initial data
  final Map<String, int>? initialStats;
  final int? notificationID;

  const CallStatisticsScreen({
    super.key,
    this.initialStats,
    this.notificationID
  });

  @override
  State<CallStatisticsScreen> createState() => _CallStatisticsScreenState();
}

class _CallStatisticsScreenState extends State<CallStatisticsScreen> {
  late Map<String, int> stats;
  bool isLoading = true;
  String errorMessage = '';
  late NotificationService notificationService;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
    // Initialize with passed data or defaults
    stats = widget.initialStats ?? {
      'Succeeded': 0,
      'No Answer': 0,
      'Busy / Refused': 0,
      'Wrong Pincode': 0,
      'Not Confirmed': 0,
      'Hanged Up': 0,
      'Failed': 0,
    };
    runNotification();
    // _fetchCallStatistics();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startPolling() {
    // Set up periodic polling (every 5 seconds)
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final statistics = await notificationService.fetchNotificationStatistics(widget.notificationID);
        final rawData = statistics?["statusCounts"] ?? []; // Your raw List<dynamic>
        final statusCounts = rawData
            .map((item) => StatusCount.fromJson(item as Map<String, dynamic>))
            .toList();

        final success = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.succeeded,
          orElse: () => StatusCount(status: TrackerStatus.succeeded, count: 0),
        )
            .count;
        final noAnswer = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.noAnswer,
          orElse: () => StatusCount(status: TrackerStatus.noAnswer, count: 0),
        )
            .count;
        final busy = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.busy,
          orElse: () => StatusCount(status: TrackerStatus.busy, count: 0),
        )
            .count;
        final wrongPincode = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.wrongPincode,
          orElse: () => StatusCount(status: TrackerStatus.wrongPincode, count: 0),
        )
            .count;
        final notConfirmed = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.notConfirmed,
          orElse: () => StatusCount(status: TrackerStatus.notConfirmed, count: 0),
        )
            .count;
        final hangedUp = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.hangedUp,
          orElse: () => StatusCount(status: TrackerStatus.hangedUp, count: 0),
        )
            .count;
        final failed = statusCounts
            .firstWhere(
              (sc) => sc.status == TrackerStatus.failed,
          orElse: () => StatusCount(status: TrackerStatus.failed, count: 0),
        )
            .count;

        if (mounted) {
          setState(() {
            stats = {
              'Succeeded': success,
              'No Answer': noAnswer,
              'Busy / Refused': busy,
              'Wrong Pincode': wrongPincode,
              'Not Confirmed': notConfirmed,
              'Hanged Up': hangedUp,
              'Failed': failed,
            };
          });
        }
      } catch (e) {
        // Optional: show error to user or implement retry logic
        if (e is TimeoutException) {
        } else {
        }
      }
    });
  }

  Future<void> runNotification()async{
    notificationService = NotificationService();
    await notificationService.runNotification(widget.notificationID);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize with default values if empty
    // final defaultStats = {
    //   'Succeeded': 0,
    //   'No Answer': 0,
    //   'Busy / Refused': 0,
    //   'Wrong Pincode': 0,
    //   'Not Confirmed': 0,
    //   'Hanged Up': 0,
    //   'Failed': 0,
    // };

    // Merge with provided stats
    final effectiveStats = {...stats};

    final total = effectiveStats.values.reduce((a, b) => a + b);
    final succeeded = effectiveStats['Succeeded'] ?? 0;
    final notSucceeded = total - succeeded;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Statistics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildKeyMetrics(succeeded, notSucceeded, context),
            const SizedBox(height: 24),
            _buildVisualizationCard(effectiveStats, context),
            const SizedBox(height: 24),
            _buildDataTableCard(effectiveStats, context),
            const SizedBox(height: 24),
            _buildTotalSummary(total, context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Row(
        children: [
          Icon(Icons.analytics_outlined, size: 32, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Call Performance',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(int succeeded, int notSucceeded, BuildContext context) {
    final theme = Theme.of(context);

    // Sample additional metrics
    final additionalMetrics = [/**/
      {
        'title': 'Wrong Pincode',
        'value': stats['Wrong Pincode'] ?? 0,  // Use actual stat value
        'color': Colors.amber,                 // More appropriate color
        'icon': Icons.lock_outline,            // Better matching icon
      },
      {
        'title': 'Not Confirmed',
        'value': stats['Not Confirmed'] ?? 0,
        'color': Colors.purple,
        'icon': Icons.schedule_outlined,       // For pending confirmation
      },
      {
        'title': 'Hanged Up',
        'value': stats['Hanged Up'] ?? 0,
        'color': Colors.redAccent,             // More visible for important status
        'icon': Icons.phone_callback_outlined, // Better call-related icon
      },
      {
        'title': 'Failed',
        'value': stats['Failed'] ?? 0,
        'color': Colors.red,                   // Standard error color
        'icon': Icons.error_outlined,          // Standard error icon
      },
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Original metrics
              _buildMetricCard(
                  'Succeeded',
                  stats['Succeeded']?.toInt() ?? 0,
                  Colors.green,
                  Icons.check_circle_outline,
                  theme
              ),
              const SizedBox(width: 12),
              _buildMetricCard(
                  'No Answer',
                  stats['No Answer']?.toInt() ?? 0,
                  Colors.orange,
                  Icons.warning_amber_outlined,
                  theme
              ),
              const SizedBox(width: 12),
              _buildMetricCard(
                  'Busy / Refused',
                  stats['Busy / Refused']?.toInt() ?? 0,
                  Colors.grey,
                  Icons.phone_disabled_outlined,
                  theme
              ),

              // Additional metrics
              ...additionalMetrics.map((metric) => Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _buildMetricCard(
                    metric['title'] as String,
                    metric['value'] as int,
                    metric['color'] as Color,
                    metric['icon'] as IconData,
                    theme
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title,
      int value,
      Color color,
      IconData icon,
      ThemeData theme
      ) {
    return SizedBox(
      width: 140, // Increased width to accommodate longer text
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon and Title - now in a column to prevent overflow
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2, // Allow text to wrap to second line if needed
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Value - now with more space
              Text(
                value.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualizationCard(Map<String, int> stats, BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Call Distribution',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildCallDistributionChart(stats),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallDistributionChart(Map<String, int> stats) {
    final maxValue = stats.values.reduce((a, b) => a > b ? a : b);
    final items = stats.entries.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: items.map((item) {
              final heightFactor = maxValue == 0 ? 0.0 : item.value / maxValue.toDouble();
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: '${item.key}: ${item.value}',
                      child: Container(
                        height: 160 * heightFactor,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _statusColor(item.key).withOpacity(0.8),
                              _statusColor(item.key),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            item.value > 0 ? '${item.value}' : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusLabel(item.key),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDataTableCard(Map<String, int> stats, BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detailed Statistics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildStatisticsTable(stats, theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsTable(Map<String, int> stats, ThemeData theme) {
    return Table(
      defaultColumnWidth: const FixedColumnWidth(100),
      border: TableBorder(
        horizontalInside: BorderSide(
          color: theme.dividerColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.05),
          ),
          children: [
            _buildTableHeaderCell('#', theme),
            _buildTableHeaderCell('Successful', theme),
            _buildTableHeaderCell('No Answer', theme),
            _buildTableHeaderCell('Busy/Refused', theme),
            _buildTableHeaderCell('Wrong Pin', theme),
            _buildTableHeaderCell('Not Confirmed', theme),
            _buildTableHeaderCell('Hanged Up', theme),
            _buildTableHeaderCell('Failed', theme),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('1', theme),
            _buildTableCell('${stats['Succeeded']}', theme),
            _buildTableCell('${stats['No Answer']}', theme),
            _buildTableCell('${stats['Busy / Refused']}', theme),
            _buildTableCell('${stats['Wrong Pincode']}', theme),
            _buildTableCell('${stats['Not Confirmed']}', theme),
            _buildTableCell('${stats['Hanged Up']}', theme),
            _buildTableCell('${stats['Failed']}', theme),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTotalSummary(int total, BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Calls: ',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$total',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Succeeded': return Colors.green;
      case 'No Answer': return Colors.grey;
      case 'Busy / Refused': return Colors.orange;
      case 'Wrong Pincode': return Colors.amber;
      case 'Not Confirmed': return Colors.brown;
      case 'Hanged Up': return Colors.pink;
      case 'Failed': return Colors.red;
      default: return Colors.blue;
    }
  }

  String _statusLabel(String label) {
    switch (label) {
      case 'Succeeded': return 'Success';
      case 'Busy / Refused': return 'Busy';
      case 'Wrong Pincode': return 'Pin';
      case 'Not Confirmed': return 'Not Conf';
      case 'Hanged Up': return 'Hung';
      default: return label.length > 8 ? label.substring(0, 7) : label;
    }
  }
}