import 'package:flutter/material.dart';
import '../widgets/department_card.dart';
import 'call_statistics_screen.dart';
import '../widgets/loading_animation.dart';
import '../services/api_service.dart';
import 'auth/login_screen.dart';

class QuickLaunchScreen extends StatefulWidget {
  const QuickLaunchScreen({Key? key}) : super(key: key);

  @override
  State<QuickLaunchScreen> createState() => _QuickLaunchScreenState();
}

class _QuickLaunchScreenState extends State<QuickLaunchScreen> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final username = await ApiService.getCurrentUsername();
      setState(() {
        _username = username;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.logout();
      
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to logout. Please try again.'),
        ),
      );
    }
  }

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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // User info and logout bar
              _buildUserBar(context),
              
              // Main content
              Expanded(
                child: Row(
                  children: [
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
              ),
            ],
          ),
    );
  }

  Widget _buildUserBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _username?.isNotEmpty == true ? _username![0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome, ${_username ?? 'User'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF1E3A8A),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          const SizedBox(height: 8),
          Text(
            'Select a department to make a call',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
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