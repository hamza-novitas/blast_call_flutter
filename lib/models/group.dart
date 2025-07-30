import 'person.dart';

class Group {
  int groupID;
  String name;
  List<Person> groupPeople;
  int peopleCount;

  Group({
    required this.groupID,
    this.name = '',
    List<Person>? groupPeople,
    required this.peopleCount,
  }) : groupPeople = groupPeople ?? [];

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'],
      name: json['name'] ?? '',
      groupPeople: json['groupPeople'] != null
          ? (json['groupPeople'] as List)
          .map((e) => Person.fromJson(e))
          .toList()
          : [],
      peopleCount: json['peopleCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'name': name,
      'groupPeople': groupPeople.map((e) => e.toJson()).toList(),
      'peopleCount': peopleCount,
    };
  }
}
