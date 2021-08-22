class Contact{
  final String uid;
  final String username;

  Contact({required this.uid, required this.username});

  Contact.fromJson(Map<String, Object?> json) : this(
    uid: json['uid']! as String,
    username: json['username']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'uid' : uid,
      'username' : username
    };
  }
}