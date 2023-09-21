import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';

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

/// 호출유형 한글로 반환
String getCallType(String? drvReqSt) {
  if (drvReqSt != null) {
    switch (drvReqSt) {
      case "CARD":
        return "카드";
      case "CASH":
        return "현금";
      case DrvReqSt.res:
        return "예약";
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
      return DateFormat(dateFormat).format(dateTime);
    } catch (e) {
      debugPrint("$e");
      return "";
    }
  }
  return "";
}
