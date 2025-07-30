// enums.dart

// -------------------------
// NotificationStatus Enum
// -------------------------

enum NotificationStatus {
  notSet(-100),
  allDraft(-1),
  draft(0),
  entryCompleted(3),
  pendingApproval(5),
  readyToLaunch(10),
  inProgress(20),
  completed(30),
  terminated(35),
  needCorrection(40),
  rejected(50),
  deleted(60),
  archived(70);

  final int value;

  const NotificationStatus(this.value);

  static NotificationStatus fromValue(int value) {
    return NotificationStatus.values.firstWhere(
          (e) => e.value == value,
      orElse: () => NotificationStatus.notSet,
    );
  }

  static bool isLaunched(int status) {
    return [
      NotificationStatus.inProgress,
      NotificationStatus.completed,
      NotificationStatus.terminated,
      NotificationStatus.archived,
    ].any((s) => s.value == status);
  }
}

// -------------------------
// MilRank Constants
// -------------------------

class MilRank {
  static const int NotSet = 0;
  static const int MajorGeneral = 1;
  static const int Brigadier = 2;
  static const int Colonel = 3;
  static const int LtColonel = 4;
  static const int Major = 5;
  static const int Captain = 6;
  static const int FirstLieutenant = 7;
  static const int Lieutenant = 8;
  static const int OfficerCadet = 9;
  static const int StaffWarrantOfficer = 10;
  static const int WarrantOfficer = 11;
  static const int SergeantStaff = 12;
  static const int Sergeant = 13;
  static const int Corporal = 14;
  static const int LanceCorporal = 15;
  static const int Private = 16;
  static const int Civilian = 18;
  static const int Labor = 21;

  static List<int> get all => [
    MajorGeneral,
    Brigadier,
    Colonel,
    LtColonel,
    Major,
    Captain,
    FirstLieutenant,
    Lieutenant,
    OfficerCadet,
    StaffWarrantOfficer,
    WarrantOfficer,
    SergeantStaff,
    Sergeant,
    Corporal,
    LanceCorporal,
    Private,
    Civilian,
    Labor,
  ];
}

// -------------------------
// MilRankType Enum + Helper
// -------------------------

enum MilRankType {
  Civilian,
  Military,
}

class MilRankHelper {
  static bool isCivilian(int? rankCode) {
    return rankCode == MilRank.Civilian || rankCode == MilRank.Labor;
  }

  static int compareMilRanksAsc(int? v1, int? v2) {
    if (v1 == null && v2 == null) return 0;
    if (v1 == null) return -1;
    if (v2 == null) return 1;
    if (v1 == v2) return 0;

    final v1IsCivilian = isCivilian(v1);
    final v2IsCivilian = isCivilian(v2);

    if (v1IsCivilian && !v2IsCivilian) return 1;
    if (v2IsCivilian && !v1IsCivilian) return -1;

    return v1 > v2 ? 1 : -1;
  }

  static List<int> get allRanks => MilRank.all;
}

enum SoundFileType {
  WelcomeMessage(10),
  AskForPincode(20),
  WrongPincode(30),
  PincodeErrorExceeded(40),
  MainContent(50),
  Confirmation(60),
  Thanks(70),
  WrongInput(80),
  FinishedAllTries(90);

  final int value;
  const SoundFileType(this.value);
}

// Add extension to get the exact integer values from the original enum
extension SoundFileTypeValue on SoundFileType {
  int get value {
    switch (this) {
      case SoundFileType.WelcomeMessage: return 10;
      case SoundFileType.AskForPincode: return 20;
      case SoundFileType.WrongPincode: return 30;
      case SoundFileType.PincodeErrorExceeded: return 40;
      case SoundFileType.MainContent: return 50;
      case SoundFileType.Confirmation: return 60;
      case SoundFileType.Thanks: return 70;
      case SoundFileType.WrongInput: return 80;
      case SoundFileType.FinishedAllTries: return 90;
    }
  }
}

enum TrackerStatus {
  notSet(0),
  succeeded(10),
  busy(20),
  failed(30),
  hangedUp(40),
  wrongPincode(50),
  notConfirmed(60),
  noAnswer(70),
  attemptDelayed(80),
  smsQueued(90),
  smsFailed(92),
  smsSucceeded(93),
  emailQueued(100),
  emailFailed(101),
  notificationTerminated(401),
  notificationExpired(402),
  recipientInactive(403),
  alreadySucceeded(404);

  final int value;
  const TrackerStatus(this.value);

  static TrackerStatus fromValue(int value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => TrackerStatus.notSet,
    );
  }
}

class StatusCount {
  final TrackerStatus status;
  final int count;

  StatusCount({required this.status, required this.count});

  factory StatusCount.fromJson(Map<String, dynamic> json) {
    // Extract the integer status from JSON (e.g., 40)
    final int statusValue = json['status'] as int;

    // Find the matching TrackerStatus enum value
    final TrackerStatus status = TrackerStatus.values.firstWhere(
          (e) => e.value == statusValue,
      orElse: () => throw Exception('Unknown status: $statusValue'), // or provide a default
    );

    return StatusCount(
      status: status,
      count: json['count'] as int,
    );
  }
}

List<StatusCount> parseStatusCounts(List<dynamic> statusCountsJson) {
  return statusCountsJson
      .map((json) => StatusCount.fromJson(json))
      .toList();
}

int getCountForStatus(List<StatusCount>? statusCounts, TrackerStatus status) {
  if (statusCounts == null || statusCounts.isEmpty) return 0;

  return statusCounts
      .firstWhere(
        (sc) => sc.status == status,
    orElse: () => StatusCount(status: status, count: 0),
  )
      .count;
}
