import 'dart:convert';

import 'package:blast_caller_app/models/enums/enums.dart';
import 'package:blast_caller_app/models/notification.dart';
import 'package:blast_caller_app/screens/active_calls.dart';
import 'package:blast_caller_app/services/notification_service.dart';
import 'package:blast_caller_app/widgets/rocket_launch_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/department_card.dart';
import 'call_statistics_screen.dart';
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
  int _currentIndex = 0;
  List<Map<String, dynamic>> _departments = [];
  dynamic notificationFiles = [];
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    loadAudioFiles();
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
        List<dynamic> quickLaunchDepartments = departmentsData
            .where((department) => department['isQuickLaunch'] == true)
            .toList();
        List<dynamic> departmentIDs = quickLaunchDepartments
            .map((department) => department['departmentID'])
            .toList();

        final departmentEmpCount = await ApiService.postData(
            "department/departmentpeoplecount", departmentIDs);

        setState(() {
          _departments = quickLaunchDepartments.map((department) {
            final departmentID = department['departmentID'];

            // Find matching department count from the response
            final departmentCount =
                (departmentEmpCount as List<dynamic>).firstWhere(
              (d) => d['departmentId'] == departmentID,
              orElse: () => {}, // fallback if not found
            );
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
              'totalPeople': departmentCount['totalPeople'] ?? 0,
              'onVacationCount': departmentCount['onVacationCount'] ?? 0,
            };
          }).toList()
            ..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
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

  Future<void> loadAudioFiles() async {
    final validSoundFileTypes =
        SoundFileType.values.map((e) => e.value).toSet();

    try {
      final notificationService = NotificationService();
      final files = await notificationService.getAllFiles();

      List<int> resultFileIDs = [];

      if (files != null) {
        files.forEach((key, value) {
          final type = int.tryParse(key);
          if (type == null) return;

          if (!validSoundFileTypes.contains(type)) return;

          final fileArray = value as List<dynamic>;

          // Match your JS code using `find`-like behavior with firstWhere + try/catch:
          Map<String, dynamic>? defaultFile;
          try {
            defaultFile = fileArray.firstWhere(
              (f) => (f['isDefault'] ?? false) == true,
            ) as Map<String, dynamic>?;
          } catch (e) {
            defaultFile = null;
          }
          if (defaultFile != null && defaultFile['fileID'] != null) {
            resultFileIDs.add(defaultFile['fileID'] as int);
          }
        });
      }

      notificationFiles = resultFileIDs; // Your class variable
    } catch (e, stacktrace) {
      print('Error loading audio files: $e');
      print(stacktrace);
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
      body: _currentIndex == 0
          ? _buildQuickLaunchContent(context)
          : ActiveCallsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Quick Launch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLaunchContent(BuildContext context) {
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
                                    description: '',
                                    time: '',
                                    totalPeople:
                                        department['totalPeople'].toString(),
                                    onVacationCount:
                                        department['onVacationCount']
                                            .toString(),
                                    // color: Color(int.parse(department['color']
                                    //     .replaceAll('#', '0xff'))),
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

  void _handleDepartmentTap(int index) async {
    final key = _cardKeys[index];
    if (key?.currentContext == null) return;
//department['departmentID']\

    // var notificationID = await handleDepartmentTap(
    //     _departments[index]['name'], _departments[index]['departmentID']);

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
        // color: Color(
        //     int.parse(_departments[index]['color'].replaceAll('#', '0xff'))),
        color: _departments[index]['color'],
        position: Offset(centerX, centerY),
        onAnimationComplete: () async {
          // overlayEntry?.remove();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CallStatisticsScreen(initialStats: {
          //       'Succeeded': 0,
          //       'No Answer': 0,
          //       'Busy / Refused': 0,
          //       'Wrong Pincode': 0,
          //       'Not Confirmed': 0,
          //       'Hanged Up': 0,
          //       'Failed': 0,
          //     }, notificationID: notificationID),
          //   ),
          // );
        },
      ),
    );
    overlay.insert(overlayEntry);
  }

  Future<int?> handleDepartmentTap(String departmentName, int departmentID,
      {bool inVacation = false}
      // <String, dynamic> department, {bool inVacation = false}
      ) async {
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    try {
      final notificationService = NotificationService();
      final rolesJson = await storage.read(key: 'roles') ?? '[]';

      // Decode JSON string into a List<dynamic>
      final roles = jsonDecode(rolesJson);

      // Now check if the user is an Officer
      final bool isLoggedInUserAnOfficer =
          roles.any((r) => r['role']['name'] == 'Officer');

      if (!isLoggedInUserAnOfficer) return null;
      var notification = NotificationModel();

      notification
        ..officerID = roles[0]['bcUserID']
        ..savingStep = 1
        ..status = NotificationStatus.draft
            .value // 'status' in your model is int?, so 'Draft' string will cause a problem
        ..name = "$departmentName $formattedDate"
        ..expirationPeriod = 6
        ..scheduledLaunchDate =
            '' // null is String? in model, so use empty string or adapt model
        ..delayAmplifier = 0;

      final savedNotification =
          await notificationService.saveNotification(notification);

      if (savedNotification != null &&
          savedNotification['notificationID'] != null) {
        final filter = {
          'rank': MilRankHelper.allRanks,
          'gender': 1,
          'departmentIDs': [departmentID],
          'inVacation': inVacation,
        };
        final recipients =
            await notificationService.addNotificationRecipientsByFilter(
          savedNotification['notificationID'],
          filter,
        );
        final notificationConfig = {
          'notificationID': savedNotification['notificationID'],
          'savingStep': 4,
          'priorities': [
            {
              'notification': null,
              'notificationID': savedNotification['notificationID'],
              'priority': 0,
              'type': 10,
            },
          ],
          'cycleBaseDelay': savedNotification['cycleBaseDelay'],
          'delayAmplifier': savedNotification['delayAmplifier'],
          'limitAttempts': savedNotification['limitAttempts'],
          'vipPriority': savedNotification['vipPriority'],
        };

        await notificationService.updateNotification(notificationConfig, 4);
        await notificationService.addNotificationFiles(
            savedNotification['notificationID'],
            notificationFiles); // Define _notificationFiles
        await notificationService.updateNotificationStatus(
            savedNotification['notificationID'],
            NotificationStatus.readyToLaunch.value);
        return savedNotification['notificationID'];
        //
        //     setState(() {
        //       _isLoading = false;
        //     });
        //
        //     Navigator.pushNamed(
        //       context,
        //       '/call/${savedNotification['notificationID']}',
        //       arguments: {'success': true},
        //     );
      }
    } catch (e) {
      return null;
      // setState(() {
      //   _isLoading = false;
      // });
      // utilityService.showErrorToast(); // Implement this in your app
    }
    return null;
  }
}
