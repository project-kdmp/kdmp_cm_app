/// 공통코드
abstract class MbrUseTp {
  static const String customer = "CM"; // 고객
  static const String driver = "DM"; // 기사
}

/// 회원 유형
abstract class MbrPrivilegeTp {
  MbrPrivilegeTp._();

  static const String customer = "CMMB"; // 고객사용자
  static const String driver = "DMMB"; // 대리기사회원
  static const String admin = "ADMN"; // 관리자
}

/// 가입계정 유형
abstract class MbrRegisterTp {
  static const String kakao = "KAKO"; // 카카오계정
  static const String naver = "NAVR"; // 네이버계정
  static const String apple = "APPL"; // 애플계정
  static const String phone = "HNPN"; // 핸드폰 본인인증
}

/// 기사 등록 상태
abstract class MbrRegprogressSt {
  MbrRegprogressSt._();

  // static const String dm10 = "DM10"; // 기사이용약관동의
  // static const String dm20 = "DM20"; // 기사본인확인
  // static const String dm30 = "DM30"; // 운전면허증사진제출
  // static const String dm40 = "DM40"; // 본인확인사진제출
  // static const String dm50 = "DM50"; // 프로필사진제출
  // static const String dm60 = "DM60"; // 보험 등록
  // static const String dm70 = "DM70"; // 주소 등록
  // static const String dm80 = "DM80"; // 가입신청
  // static const String dm90 = "DM90"; // 가입승인완료
  static const String cm10 = "CM10"; // 고객가입중
  static const String cm20 = "CM20"; // 고객가입완료
}

/// 회원 가입 상태
abstract class MbrSt {
  MbrSt._();

  static const String temp = "I"; // 임시저장
  static const String reject = "R"; // 가입거절
  static const String registerComplete = "M"; // 가입완료
  static const String registerDormant = "D"; // 휴면계정
  static const String withdrawal = "W"; // 탈퇴
}

/// 약관종류
abstract class TrmTp {
  TrmTp._();

  static const String service = "SUSE"; // 서비스이용약관
  static const String location = "LOCA"; // 위치정보
  static const String community = "COMU"; // 커뮤니티
  static const String noCar = "NCAR"; // 운행불가차량
}

/// 파일유형
abstract class MbrDmPictp {
  MbrDmPictp._();

  static const String driverLicense = "DRIV"; // 운전면허사진
  static const String prove = "SELF"; // 본인확인 사진
  static const String profile = "PRFI"; // 프로필사진
}

/// 기사 출근/퇴근 상태
abstract class DMWorkSt {
  DMWorkSt._();

  static const String work = "ATTN";
  static const String home = "LEAV";
}

/// 콜 운행 상태
abstract class DrvReqSt {
  DrvReqSt._();

  static const String res = "RES"; // 예약
  // static const String rco = "RCO"; // 예약 확정 / 기사
  // static const String rwt = "RWT"; // 예약출발지도착 - 대기중
  // static const String rst = "RST"; // 예약-운행시작
  // static const String rcd = "RCD"; // 예약-카드결제완료
  // static const String ren = "REN"; // 예약-운행종료
  static const String rdl = "RDL"; // 예약-취소
  static const String cal = "CAL"; // 호출중 / 고객
  static const String cco = "CCO"; // 호출 확정 /기사 확정
  static const String wat = "WAT"; // 출발지 도착 - 대기중 / 기사 배정후 대기중
  static const String sta = "STA"; // 운행시작
  static const String del = "DEL"; // 취소
  static const String dcd = "DCD"; // 카드결제완료 /카드결제인데, 운행종료시 확인
  static const String end = "END"; // 운행종료
}

/// 콜 취소사유 유형
abstract class DrvCancelTp {
  DrvCancelTp._();

  static const String oths = "OTHS"; // 다른 서비스 이용
  static const String drvc = "DRVC"; // 기사님 연락 후 취소
}

/// 종합소득세 신청 용도
abstract class IncomReqUseTp {
  IncomReqUseTp._();

  static const String tax = "TAX"; // 신고용
}


/// 상담문의 답변여부
abstract class InqRtnSt {
  InqRtnSt._();

  static const String wait = "WAIT"; // 답변 대기
  static const String comp = "COMP"; // 답변 완료
}
