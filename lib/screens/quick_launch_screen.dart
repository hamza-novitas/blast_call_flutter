import 'package:blast_caller_app/widgets/rocket_launch_overlay.dart';
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
  final Map<int, GlobalKey> _cardKeys = {}; // Track keys for each card
  String? _username;
  bool _isLoading = true;
  List<Map<String, dynamic>> _departments = [];

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
      final response = await ApiService.fetchData(
          "department?name=&limit=3000&start=0&includeDisabled=true&includeQuickLaunch=true");

      if (response['departments'].length > 0) {
        List<dynamic> departmentsData = response['departments'];
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
      } else {
        print("No departments data available in the response.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data')),
      );
      this.setState(() {
        _departments = [
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
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildUserBar(context),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            Expanded(
                                child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              itemCount: _departments.length,
                              itemBuilder: (context, index) {
                                _cardKeys[index] ??=
                                    GlobalKey(); // Initialize key if null
                                final department = _departments[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: DepartmentCard(
                                    key: _cardKeys[index], // Assign the key
                                    name: department['name'] as String,
                                    description:
                                        'Total Count: ${department['order']}',
                                    time: '',
                                    color: department['color'],
                                    people: ['John Doe', 'Jane Smith'],
                                    onTap: () => _handleDepartmentTap(index),
                                  ),
                                );
                              },
                            )),
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
                _username?.isNotEmpty == true
                    ? _username![0].toUpperCase()
                    : 'U',
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

  void _handleDepartmentTap(int index) {
    final key = _cardKeys[index];
    if (key?.currentContext == null) return;

    final renderBox = key?.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Calculate center position
    final centerX = position.dx + size.width / 2;
    final centerY = position.dy + size.height / 2;

    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => RocketLaunchOverlay(
        color: _departments[index]['color'],
        position: Offset(centerX, centerY),
        onAnimationComplete: () {
          overlayEntry?.remove();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallStatisticsDetailScreen(
                departmentName: _departments[index]['name'],
                succeeded: 1,
                notSucceeded: 0,
                notCalled: 0,
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(overlayEntry);
  }
}
