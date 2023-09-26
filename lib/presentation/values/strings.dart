abstract class StringCommon {
  StringCommon._();

  static const String cancel = "취소";
  static const String confirm = "확인";
  static const String next = "다음";
  static const String selectPicture = "+ 사진첨부";
  static const String selectDate = "날짜 선택";
  static const String change = "변경";
  static const String reSubmit = "다시 제출";
  static const String issue = "발급";
  static const String fix = "확정";

  static const String httpBad = "통신 에러";
  static const String httpFail = "통신 실패";

  static const String confirmSuccess = "등록이 완료되었습니다.";
  static const String modifySuccess = "변경이 완료되었습니다.";
  static const String issueSuccess = "신청이 완료되었습니다.";

  static const String driver = "기사님";
  static const String km = "km";
  static const String m = "m";
  static const String won = "원";
}

abstract class StringPermission {
  StringPermission._();

  static const String title = "접근 권한 안내";
  static const String content = "OOOO는 아래 접근 권한을 사용합니다.";
  static const String permissionTitle1 = "위치";
  static const String permissionContent1 = "출발지 위치를 안내하기 위해 필요한 권한";
  static const String permissionTitle2 = "전화";
  static const String permissionContent2 = "전화를 걸기위해 필요한 권한";
  static const String permissionTitle3 = "저장공간 (선택)";
  static const String permissionContent3 = "(미정)";
  static const String permissionTitle4 = "알림 (선택)";
  static const String permissionContent4 = "기사님 호출 및 배정 결과 등 대리 서비스 이용 상태 안내를 위해 필요한 권한";
  static const String permissionGuide = "선택 권한은 서비스 사용 중 필요한 시점에 동의를 받고 있습니다. 허용하지 않아도 해당 기능 외 서비스를 이용할 수 있습니다.\n\n접근 권한 변경 휴대폰 설정 > 앱(애플리케이션) > OOOO";
  static const String bottomButton = "확인";

  static const String alertTitle = "접근 권한이 없어\nOOOO을 사용할 수 없습니다.";
  static const String alertContent1 = "아래 확인 버튼을 눌러\n필요한 권한을 허용해주세요.";
  static const String alertContent2 = "필요권한 : 위치, 전화";
}

abstract class StringTerm {
  StringTerm._();

  static const String title = "이용약관";
  static const String allAgree = "전체 이용약관을 동의합니다.";
  static const String detail = "보기";
  static const String bottomButton = "동의";
  static const String content = "OOOO 서비스를 이용하기 위해\n변경된 필수 약관에 대한 동의가 필요합니다.";
}

abstract class StringLogin {
  StringLogin._();

  static const String loginSuccess = "로그인 성공";
  static const String loginFail = "로그인 실패";

  static const String mbrPrivilegeTpCMMB = "고객사용자입니다. 고객용 앱을 이용해주세요.";
  static const String mbrPrivilegeTpDMMB = "대리기사회원입니다. 기사용 앱을 이용해주세요.";
  static const String mbrPrivilegeTpADMN = "관리자입니다.";

  static const String mbrStD = "휴면회원입니다.";
  static const String mbrStW = "탈퇴회원입니다.";
}

abstract class StringHome {
  StringHome._();

  static const String title = "타이틀";
  static const String reservationButton = "예약하기";
  static const String callButton = "호출하기";
  static const String startPlaceHint = "출발지 검색";
  static const String endPlaceHint = "도착지 검색";
  static const String stopoverButton = "경유";
  static const String basicPrice = "일반요금";
  static const String basicPriceSub = "혼잡 시 긴 대기시간";
  static const String inputPrice = "요금 직접 입력";
  static const String inputPriceSub = "빠른 귀가를 위해 직접 입력";
  static const String payment1 = "결제수단";
  static const String payment2 = "결제";
  static const String empty = "없음";
  static const String selectButton = "선택";
  static const String changeButton = "변경";
}

abstract class StringSetup {
  StringSetup._();

  static const String themeMode = "테마";
  static const String themeLightMode = "라이트 모드";
  static const String themeDarkMode = "다크 모드";
}

abstract class StringRegister {
  StringRegister._();

  static const String phoneVerify = "본인확인";
  static const String registerSuccess = "회원가입 성공";
  static const String registerFail = "회원가입 실패";
  static const String registerCarTitle = "차량정보 등록";
  static const String registerCarContent1 = "입력하신 차량정보는";
  static const String registerCarContent2 = "대리 서비스에 이용됩니다.";
  static const String registerBottomButton = "차량정보 입력";
  static const String driverTerm = "운행불가 차종안내";

  static const String noPermission = "정지 회원 안내";
  static const String noPermissionContent = "사용이 정지되었습니다.";
}

abstract class StringOnBoarding {
  StringOnBoarding._();

  static const String start = "시작하기";
}

abstract class StringMenu {
  StringMenu._();

  static const String title = "메뉴";
  static const String myPage = "내 정보";
  static const String called = "이용내역";
  static const String place = "자주 가는 장소";
  static const String payment = "결제 관리";
  static const String carInfo = "차량 정보";
  static const String cs = "고객센터";
  static const String setup = "환경설정";
}

abstract class StringCarAdd {
  StringCarAdd._();

  static const String title = "차량 번호 입력";
  static const String carNumber = "차량번호";
  static const String inputGuide1 = "차량번호를 네 자리를 입력해주세요.";
  static const String carAddSuccess = "차량정보 등록이 완료되었습니다.";
}

abstract class StringMyPage {
  StringMyPage._();

  static const String name = "이름";
  static const String phone = "휴대폰번호";
  static const String email = "이메일";
  static const String logout = "로그아웃";
  static const String withdraw = "탈퇴하기";

  static const String logoutConfirm = "정말 로그아웃 하시겠습니까?";
}

abstract class StringWithdraw {
  StringWithdraw._();

  static const String title = "탈퇴하기";
  static const String content1 = "OOOO를 탈퇴하시겠습니까?";
  static const String content2 = "(탈퇴 시 개인정보처리 정책 내용)";
  static const String bottomButton = "탈퇴하기";

  static const String withdrawalConfirm = "정말 탈퇴하시겠습니까?";
}
