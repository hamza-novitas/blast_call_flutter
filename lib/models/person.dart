class Nationality {
  int? nationalityID;
  String? name;

  Nationality({this.nationalityID, this.name});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      nationalityID: json['nationalityID'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nationalityID': nationalityID,
      'name': name,
    };
  }
}

class Person {
  int? personID;
  int? clientID;
  String nameAr;
  String nameEn;
  String domainName;
  String email;
  String pid;
  String nid;
  int? rank;
  int? gender;
  String cellNumber1;
  String cellNumber2;
  String cellNumber3;
  String homeNumber;
  String workNumber;
  String language;
  dynamic inVacation;
  String? nationalityID;
  Nationality? nationality;
  bool isEnabled;
  bool isDeleted;
  bool isVIP;
  String pinCode;

  String? level1;
  String? level2;
  String? level3;
  String? level4;

  Person({
    this.personID,
    this.clientID,
    this.nameAr = '',
    this.nameEn = '',
    this.domainName = '',
    this.email = '',
    this.pid = '',
    this.nid = '',
    this.rank,
    this.gender,
    this.cellNumber1 = '',
    this.cellNumber2 = '',
    this.cellNumber3 = '',
    this.homeNumber = '',
    this.workNumber = '',
    this.language = '',
    this.inVacation,
    this.nationalityID,
    this.nationality,
    this.isEnabled = true,
    this.isDeleted = false,
    this.isVIP = false,
    this.pinCode = '',
    this.level1,
    this.level2,
    this.level3,
    this.level4,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personID: json['personID'],
      clientID: json['clientID'],
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      domainName: json['domainName'] ?? '',
      email: json['email'] ?? '',
      pid: json['pid'] ?? '',
      nid: json['nid'] ?? '',
      rank: json['rank'],
      gender: json['gender'],
      cellNumber1: json['cellNumber1'] ?? '',
      cellNumber2: json['cellNumber2'] ?? '',
      cellNumber3: json['cellNumber3'] ?? '',
      homeNumber: json['homeNumber'] ?? '',
      workNumber: json['workNumber'] ?? '',
      language: json['language'] ?? '',
      inVacation: json['inVacation'],
      nationalityID: json['nationalityID'],
      nationality: json['nationality'] != null
          ? Nationality.fromJson(json['nationality'])
          : null,
      isEnabled: json['isEnabled'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
      isVIP: json['isVIP'] ?? false,
      pinCode: json['pinCode'] ?? '',
      level1: json['level_1'],
      level2: json['level_2'],
      level3: json['level_3'],
      level4: json['level_4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personID': personID,
      'clientID': clientID,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'domainName': domainName,
      'email': email,
      'pid': pid,
      'nid': nid,
      'rank': rank,
      'gender': gender,
      'cellNumber1': cellNumber1,
      'cellNumber2': cellNumber2,
      'cellNumber3': cellNumber3,
      'homeNumber': homeNumber,
      'workNumber': workNumber,
      'language': language,
      'inVacation': inVacation,
      'nationalityID': nationalityID,
      'nationality': nationality?.toJson(),
      'isEnabled': isEnabled,
      'isDeleted': isDeleted,
      'isVIP': isVIP,
      'pinCode': pinCode,
      'level_1': level1,
      'level_2': level2,
      'level_3': level3,
      'level_4': level4,
    };
  }

  String getName({required bool isArabic}) {
    return isArabic ? nameAr : nameEn;
  }
}
