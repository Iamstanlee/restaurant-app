class NOTIFICATION {
  String title, desc, type;
  bool status;
  dynamic time;

  NOTIFICATION({this.title, this.desc, this.type, this.status, this.time});

  factory NOTIFICATION.fromJson(Map<String, dynamic> map) => NOTIFICATION(
        type: map['type'],
        time: map['time'],
        status: map['status'],
        title: map['title'],
        desc: map['desc'],
      );

  static Map<String, dynamic> toJson(NOTIFICATION e) => {
        'title': e.title,
        'desc': e.desc,
        'type': e.type,
        'status': e.status,
        'time': e.time
      };
}
