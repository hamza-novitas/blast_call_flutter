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
  List<Map<String, dynamic>> _departments = []; // To store fetched department data

  @override
  void initState() {
    super.initState();
    print("Test");
    _loadUserInfo();
  }

  // Fetch user information and department data
  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Test22");
      final username = await ApiService
          .getCurrentUsername(); // Get the username

      // Fetch department data
      final response = await ApiService.fetchData(
          "department?name=&limit=3000&start=0&includeDisabled=true&includeQuickLaunch=true");

      print("Test adsadsa ${response['departments'].length > 0}");

      if (response['departments'].length > 0) {
        List<dynamic> departmentsData = response['departments']; // Extract the department list
        print("Test ${departmentsData}");

        // Map the department data into your desired structure
        setState(() {
          _departments = departmentsData
              .where((department) => department['isQuickLaunch'] == true)
              .map((department) {
            return {
              'departmentID': department['departmentID'],
              'clientID': department['clientID'],
              'clientType': department['clientType'],
              'name': department['name'],
              'type': department['type'],
              'isEnabled': department['isEnabled'],
              'isDeleted': department['isDeleted'],
              'color': department['color'],
              'isQuickLaunch': department['isQuickLaunch'],
              'order': department['order'],
            };
          }).toList();
          _isLoading = false;
        });
        print("Test13213213 ${_departments}");

      } else {
        print("Test No departments data available in the response.");
      }
      print("Test Fetched departments: $_departments");
    }
    catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (optional: show a message to the user)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  // Logout function
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.logout(); // Your logout logic here
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
                          itemCount: _departments.length, // Use the fetched data
                          itemBuilder: (context, index) {
                            final department = _departments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DepartmentCard(
                                    name: department['name'] as String,
                                    description: 'Total Count: ${department['order']}', // Example description
                                    time: '', // You can replace with actual time if needed
                                    color: Color(int.parse(department['color'].replaceAll('#', '0xff'))),
                                    people: ['John Doe', 'Jane Smith'], // Example people, adjust based on your data
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

  // User info and logout bar
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

  // Header Section
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

  // Handle department tap
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
