import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_response.dart';

/// m를 km로 변환하여 반환
String convertMToKm(int? m) {
  if (m != null) {
    final km = m / 1000;
    return "${km}km";
  } else if (m == 0) {
    return "${m}km";
  }
  return "";
}

/// 결제수단 한글로 반환
String getPaymentKind(String? paymentKind) {
  if (paymentKind != null) {
    switch (paymentKind) {
      case "CARD":
        return "카드";
      case "CASH":
        return "현금";
    }
  }
  return "";
}

/// 운행상태 한글로 반환
String getDriveType(String? drvReqSt) {
  if (drvReqSt != null) {
    switch (drvReqSt) {
      case DrvReqSt.res:
        return "예약 접수";
      case DrvReqSt.rco:
        return "예약 확정";
      case DrvReqSt.rwt:
        return "예약출발지도착 - 대기중";
      case DrvReqSt.rst:
        return "예약-운행시작";
      case DrvReqSt.rcd:
        return "예약-카드결제완료";
      case DrvReqSt.ren:
        return "예약-운행종료";
      case DrvReqSt.rdl:
        return "예약-취소";
      case DrvReqSt.cal:
        return "호출중";
      case DrvReqSt.cco:
        return "호출 확정";
      case DrvReqSt.wat:
        return "출발지 도착 - 대기중";
      case DrvReqSt.sta:
        return "운행시작";
      case DrvReqSt.del:
        return "취소";
      case DrvReqSt.dcd:
        return "카드결제완료";
      case DrvReqSt.end:
        return "운행종료";
    }
  }
  return "";
}

/// 호출유형 한글로 반환
String getCallType(String? drvReqSt) {
  if (drvReqSt != null) {
    switch (drvReqSt) {
      case DrvReqSt.res:
      case DrvReqSt.rco:
      case DrvReqSt.rwt:
      case DrvReqSt.rst:
      case DrvReqSt.rcd:
      case DrvReqSt.ren:
      case DrvReqSt.rdl:
        return "예약";
      case DrvReqSt.cal:
      case DrvReqSt.cco:
      case DrvReqSt.wat:
      case DrvReqSt.sta:
      case DrvReqSt.del:
      case DrvReqSt.dcd:
      case DrvReqSt.end:
        return "일반";
    }
  }
  return "";
}

/// 금액 콤마 처리 후 반환
String getPrice(int? price) {
  if (price != null) {
    return "${NumberFormat("###,###,###,###").format(price)}원";
  }
  return "";
}

/// 금액 콤마 처리 후 반환
String getPhoneNumber(String? phone) {
  if (phone != null) {
    try {
      return "${phone.substring(0, 3)}-${phone.substring(3, 7)}-${phone.substring(7, 11)}";
    } catch (e) {
      return phone;
    }
  }
  return "";
}

/// 날짜형식 포맷 후 반환
String getDateFormat({required String? date, String dateFormat = "yyyy-MM-dd"}) {
  if (date != null) {
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat(dateFormat, 'ko_KR').format(dateTime);
    } catch (e) {
      debugPrint("$e");
      return "";
    }
  }
  return "";
}

/// 날짜형식 포맷 후 반환
String getDateAndTimeFormat({required String? startDate, String? endDate}) {
  if (startDate != null) {
    try {
      const dateFormat = "yyyy년 MM월 dd일 HH:mm";
      final startDateTime = DateFormat(dateFormat, 'ko_KR').format(DateTime.parse(startDate));
      if (endDate != null) {
        final endDateTime = DateFormat(dateFormat, 'ko_KR').format(DateTime.parse(endDate));
        final startSplit = startDateTime.split(" ");
        final endSplit = endDateTime.split(" ");
        if (startSplit[0] == endSplit[0] && startSplit[1] == endSplit[1] && startSplit[2] == endSplit[2]) {
          return "$startDateTime - ${endSplit[3]}"; // 시간
        }
        return "$startDateTime - $endDateTime";
      }
      return startDateTime;
    } catch (e) {
      debugPrint("$e");
      return " ";
    }
  }
  return " ";
}

/// 네이버 장소 검색 주소 반환
String makeAddress({required List<Result> items, bool isRoad = true}) {
  if (items.isEmpty) {
    return "";
  }
  final item = items[0];
  final region = item.region;
  final land = item.land;
  final isRoadAddress = isRoad && item.name == "roadaddr";

  String sido = "";
  String sigugun = "";
  String dongmyun = "";
  String ri = "";
  String rest = "";

  if (region.area1 != null && region.area1!.name.isNotEmpty) {
    sido = region.area1!.name;
  }

  if (region.area2 != null && region.area2!.name.isNotEmpty) {
    sigugun = region.area2!.name;
  }

  if (region.area3 != null && region.area3!.name.isNotEmpty) {
    dongmyun = region.area3!.name;
  }

  if (region.area4 != null && region.area4!.name.isNotEmpty) {
    ri = region.area4!.name;
  }

  if (land != null) {
    if (land.number1 != null && land.number1!.isNotEmpty) {
      if (land.type == "2") {
        rest += "산";
      }

      rest += land.number1!;

      if (land.number2 != null && land.number2!.isNotEmpty) {
        rest += "-${land.number2!}";
      }
    }

    if (isRoadAddress) {
      if (dongmyun.substring(dongmyun.length - 1, dongmyun.length) == "면") {
        ri = land.name ?? "";
      } else {
        dongmyun = land.name ?? "";
        ri = "";
      }

      // if (land.addition0 != null) { // 도로명 주소이고 건물정보가 있는경우 건물명
      //   rest += " " + land.addition0!.value;
      // }
    }
  }
  return [sido, sigugun, dongmyun, ri, rest].join(" ").replaceAll("  ", " ").trim();
}

/// 네이버 장소 검색 장소명 반환
String makePlace(List<Result> items) {
  if (items.isEmpty) {
    return "";
  }
  final item = items[0];
  final land = item.land;
  final isRoadAddress = item.name == "roadaddr";
  String rest = "";

  if (land != null) {
    if (isRoadAddress) {
      if (land.addition0 != null && land.addition0!.value.isNotEmpty) {
        rest += " ${land.addition0?.value}";
      }
    }
  }
  return rest.trim();
}
