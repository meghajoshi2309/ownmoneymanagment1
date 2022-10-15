class UserModel {
  String? uid;
  String? email;
  String? username;

  UserModel({this.uid, this.email, this.username});

  //Taking data from server using map
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
    );
  }

  //sending data to server using map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }
}
