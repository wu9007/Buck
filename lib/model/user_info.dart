class UserInfo {
  final String uuid;
  final String avatar;
  final String name;
  final String departmentUuid;
  final String departmentName;
  final List authIds;
  final List menuIds;

  UserInfo.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        avatar = map['avatar'],
        name = map['name'],
        departmentUuid = map['departmentUuid'],
        departmentName = map['departmentName'],
        authIds = map['authIds'],
        menuIds = map['menuIds'];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uuid': this.uuid,
        'avatar': this.avatar,
        'name': this.name,
        'departmentUuid': this.departmentUuid,
        'demaprtmentName': this.departmentName,
        'authIds': this.authIds,
        'menuIds': this.menuIds
      };

  String getAvatar() {
    return avatar;
  }
}
