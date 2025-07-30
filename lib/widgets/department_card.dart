import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  final String name;
  final String description;
  final String time;
  final Color color;
  final List<String> people;
  final VoidCallback onTap;

  const DepartmentCard({
    Key? key,
    required this.name,
    required this.description,
    required this.time,
    required this.color,
    required this.people,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Chevron icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // // Description
              // Text(
              //   description,
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: Colors.white.withOpacity(0.9),
              //   ),
              // ),
              //
              const SizedBox(height: 12),

              // Buttons with divider
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Handle Action 1
                          print('Action 1 pressed TEST');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.group, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Handle Action 2
                          print('Action 2 pressed TEST');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.beach_access, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // People section (if present)
              if (people.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildPeopleSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeopleSection() {
    return Row(
      children: [
        if (people.length > 1) _buildAvatarStack(),
        if (people.length == 1) _buildSingleAvatar(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _getPeopleText(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleAvatar() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 44,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (people.length > 2)
            Positioned(
              left: 32,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getPeopleText() {
    if (people.isEmpty) {
      return '';
    } else if (people.length == 1) {
      return people[0];
    } else if (people.length == 2) {
      return '${people[0]}, ${people[1]}';
    } else {
      return '${people[0]}, ${people[1]}, +${people.length - 2}';
    }
  }
}
