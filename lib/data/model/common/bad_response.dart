class BadResponse {
  int bizErrCode;
  String? message;
  String? detailMessage;
  String? path;
  String? messageKey;

  BadResponse({
    required this.bizErrCode,
    this.message = "",
    this.detailMessage = "",
    this.path = "",
    this.messageKey = "",
  });

  factory BadResponse.fromJson(Map<String, dynamic> json) {
    return BadResponse(
      bizErrCode: json["bizErrCode"] as int,
      message: json["message"] as String,
      detailMessage: json["detailMessage"] as String,
      path: json["path"] as String,
      messageKey: json["messageKey"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "bizErrCode": bizErrCode,
        "message": message,
        "detailMessage": detailMessage,
        "path": path,
        "messageKey": messageKey,
      };
}
