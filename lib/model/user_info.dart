class UserInfo {
  final String uuid;
  final String avatar;
  final String name;
  final String departmentUuid;
  final String departmentName;
  final String businessDepartmentUuid;
  final String businessDepartmentName;
  final String stationUuid;
  final String stationCode;
  final List authIds;
  final Set bundleIds;
  final Map departmentServiceUserAuthorityViewMap;

  UserInfo.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        avatar = map['avatar'],
        name = map['name'],
        departmentUuid = map['departmentUuid'],
        departmentName = map['departmentName'],
        businessDepartmentUuid = map['businessDepartmentUuid'],
        businessDepartmentName = map['businessDepartmentName'],
        stationUuid = map['stationUuid'],
        stationCode = map['stationCode'],
        authIds = map['authIds'],
        bundleIds = map['bundleIds'],
        departmentServiceUserAuthorityViewMap =
            map['departmentServiceUserAuthorityViewMap'];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uuid': this.uuid,
        'avatar': this.avatar,
        'name': this.name,
        'departmentUuid': this.departmentUuid,
        'departmentName': this.departmentName,
        'businessDepartmentUuid': this.businessDepartmentUuid,
        'businessDepartmentName': this.businessDepartmentName,
        'stationUuid': this.stationUuid,
        'stationCode': this.stationCode,
        'authIds': this.authIds,
        'bundleIds': this.bundleIds,
        'departmentServiceUserAuthorityViewMap':
            this.departmentServiceUserAuthorityViewMap
      };

  String getAvatar() {
    return avatar;
  }
}
