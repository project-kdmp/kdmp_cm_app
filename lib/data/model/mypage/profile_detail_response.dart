class ProfileDetailResponse {
  String serverVersion;
  String serverId;
  String mbrNm;
  String mbrMobilePhone;

  ProfileDetailResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrNm,
    required this.mbrMobilePhone,
  });

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) => ProfileDetailResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        mbrNm: json["mbrNm"],
        mbrMobilePhone: json["mbrMobilePhone"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrNm": mbrNm,
        "mbrMobilePhone": mbrMobilePhone,
      };
}
