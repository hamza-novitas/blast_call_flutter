import 'package:flutter/material.dart';
import '../widgets/department_card.dart';
import 'call_statistics_screen.dart';
import '../widgets/loading_animation.dart';

class QuickLaunchScreen extends StatelessWidget {
  const QuickLaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final departments = [
      {
        'name': 'All Employees',
        'description': 'Total Count: 5360',
        'time': '',
        'color': const Color(0xFF47B5FF),
        'people': ['Andre Torres', 'Edouard Dufils', 'Sophie Wang Yu'],
      },
      {
        'name': 'IT',
        'description': 'Total Count: 347',
        'time': '',
        'color': const Color(0xFFFFA500),
        'people': ['Andre Torres', 'You'],
      },
      {
        'name': 'Communications',
        'description': 'Total Count: 173',
        'time': '',
        'color': const Color(0xFFAA77FF),
        'people': ['Freya Collins', 'You'],
      },
      {
        'name': 'HR',
        'description': 'Total Count: 1473',
        'time': '',
        'color': const Color(0xFFE9A8FF),
        'people': ['You'],
      },
    ];

    return Scaffold(
      body: Row(
        children: [
          // Left sidebar with day letters
          // _buildLeftSidebar(),
          
          // Main content area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      final department = departments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if (index == 0 || index == 2)
                            //   _buildTimeIndicator(department['time'] as String),
                            DepartmentCard(
                              name: department['name'] as String,
                              description: department['description'] as String,
                              time: department['time'] as String,
                              color: department['color'] as Color,
                              people: department['people'] as List<String>,
                              onTap: () => _handleDepartmentTap(context, department),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 48,
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          const SizedBox(height: 80),
          _buildDayButton('M', false),
          _buildDayButton('T', true),
          _buildDayButton('W', false),
          _buildDayButton('T', false),
          _buildDayButton('F', false),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF4A4A4A), height: 1, thickness: 1),
          const SizedBox(height: 12),
          _buildDayButton('S', false),
          _buildDayButton('S', false),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF888888)),
            onPressed: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDayButton(String day, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF888888),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              )
              // IconButton(
              //   icon: const Icon(Icons.grid_view, color: Color(0xFF333333)),
              //   onPressed: () {},
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       'Aug 20',
              //       style: TextStyle(
              //         color: Color(0xFF888888),
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //     Text(
              //       '18',
              //       style: TextStyle(
              //         fontSize: 36,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(width: 0),
              Expanded(
                child: Text(
                  'Quick Launch',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeIndicator(String time) {
    final startTime = time.split(' - ')[0];
    
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        startTime,
        style: const TextStyle(
          color: Color(0xFF888888),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  void _handleDepartmentTap(BuildContext context, Map<String, dynamic> department) {
    // Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingAnimation(),
    );

    // Simulate loading time
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      
      // Navigate to statistics screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallStatisticsDetailScreen(
            departmentName: department['name'] as String,
            succeeded: 1,
            notSucceeded: 0,
            notCalled: 0,
          ),
        ),
      );
    });
  }
}