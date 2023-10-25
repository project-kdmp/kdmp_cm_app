class BadResponse {
  int bizErrCode;
  String message;
  String detailMessage;
  String path;
  String messageKey;

  BadResponse({
    required this.bizErrCode,
    this.message = "",
    this.detailMessage = "",
    this.path = "",
    this.messageKey = "",
  });

  factory BadResponse.fromJson(Map<String, dynamic> json) {
    return BadResponse(
      bizErrCode: json["bizErrCode"],
      message: json["message"] ?? "",
      detailMessage: json["detailMessage"] ?? "",
      path: json["path"] ?? "",
      messageKey: json["messageKey"] ?? "",
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
