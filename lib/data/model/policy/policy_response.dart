class PolicyResponse {
  String serverVersion;
  String serverId;
  String policyTitle;
  String policyContent;

  PolicyResponse({
    required this.serverVersion,
    required this.serverId,
    required this.policyTitle,
    required this.policyContent,
  });

  factory PolicyResponse.fromJson(Map<String, dynamic> json) {
    return PolicyResponse(
      serverVersion: json["serverVersion"],
      serverId: json["serverId"],
      policyTitle: json["policyTitle"],
      policyContent: json["policyContent"],
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "policyTitle": policyTitle,
        "policyContent": policyContent,
      };
}
