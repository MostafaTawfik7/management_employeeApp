class DataUserModel {
  String uID;
  UserModel userModel;
  DataUserModel({
    required this.uID,
    required this.userModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      'userModel': userModel.toMap(),
    };
  }

  factory DataUserModel.fromMap(Map<String, dynamic> map) {
    return DataUserModel(
      uID: map['uID'] ?? '',
      userModel: UserModel.fromMap(map['userModel']),
    );
  }
}

class UserModel {
  String name;
  String email;
  String osUserID;
  bool isManager;
  UserModel({
    required this.name,
    required this.email,
    required this.osUserID,
     this.isManager=false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'osUserID': osUserID,
      'isManager': isManager,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      osUserID: map['osUserID'] ?? '',
      isManager: map['isManager'] ?? false,
    );
  }
}
