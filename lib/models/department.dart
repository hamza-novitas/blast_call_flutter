class Department {
  final String id;
  final String name;
  final int inProgress;
  final int completed;
  final bool isEnglish;
  
  Department({
    required this.id,
    required this.name,
    required this.inProgress,
    required this.completed,
    this.isEnglish = false,
  });
}

class CallStatistics {
  final int succeeded;
  final int notSucceeded;
  final int notCalled;
  
  CallStatistics({
    required this.succeeded,
    required this.notSucceeded,
    required this.notCalled,
  });
  
  int get total => succeeded + notSucceeded + notCalled;
}