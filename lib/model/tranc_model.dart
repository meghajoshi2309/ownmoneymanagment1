class TranModel {
  String? uid;
  String? tid;
  String? name;

  TranModel(
      {this.uid,
      this.tid,
      this.name});

  //Taking data from server using map
  factory TranModel.fromMap(map) {
    return TranModel(
        uid: map['uid'],
        tid: map['tid'],
        name: map['name']);
  }

  //sending data to server using map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tid': tid,
      'name': name,
    };
  }
}
