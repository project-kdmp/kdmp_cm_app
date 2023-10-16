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

  // static const String mbrPrivilegeTpCMMB = "고객사용자입니다.\n고객용 앱을 이용해주세요.";
  static const String mbrPrivilegeTpDMMB = "대리기사회원입니다.\n기사용 앱을 이용해주세요.";
  static const String mbrPrivilegeTpADMN = "관리자입니다.";
  static const String mbrPrivilegeTpUNKNOWN = "알 수 없는 회원정보입니다.";

  static const String mbrStD = "휴면회원입니다.";
  static const String mbrStW = "탈퇴회원입니다.";
}

abstract class StringHome {
  StringHome._();

  static const String onBackPressed = "뒤로가기를 한번 더 누르면 종료됩니다.";

  static const String title = "타이틀";
  static const String reservationButton = "예약하기";
  static const String callButton = "호출하기";
  static const String startPlaceHint = "출발지 검색";
  static const String endPlaceHint = "도착지 검색";
  static const String stopOverButton = "경유";
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
  static const String payment = "결제관리";
  static const String carInfo = "차량정보";
  static const String cs = "고객센터";
  static const String setup = "환경설정";
}

abstract class StringCarAdd {
  StringCarAdd._();

  static const String title = "차량번호 입력";
  static const String carNumber = "차량번호";
  static const String inputGuide1 = "차량번호를 네 자리를 입력해주세요.";
  static const String carAddSuccess = "차량정보 등록이 완료되었습니다.";
}

abstract class StringCarSelect {
  StringCarSelect._();

  static const String title = "차량선택";
  static const String addCar = "차량추가";
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
  static const String withdrawalSuccess = "탈퇴가 완료되었습니다.";
}

abstract class StringCallPrice {
  StringCallPrice._();

  static const String title = "요금 직접 입력";
  static const String titleChange = "요금 변경";
  static const String bottomButton = "확인";
  static const String amount = "요금";
  static const String inputGuide0 = "  ";
  static const String inputGuide1 = "요금을 입력해주세요.";
  static const String inputGuide2 = "이상으로 입력해주세요.";
}

abstract class StringReview {
  StringReview._();

  static const String title = "리뷰 작성";
  static const String titleChange = "리뷰 수정";
  static const String confirmButton = "확인";
  static const String cancelButton = "나중에 평가";
  static const String content1 = "목적지에 도착했습니다.";
  static const String content2 = "리뷰를 남겨주시겠습니까?";
  static const String messageHint = "리뷰를 작성해주세요.";
}

abstract class StringStartSetup {
  StringStartSetup._();

  static const String title = "출발지 설정";
  static const String searchHint = "출발지 검색";
  static const String nowLocation = "현위치";
  static const String selectMap = "지도에서 선택";
  static const String edit = "편집";
  static const String recentKeyword = "최근 검색";
  static const String bottomButton = "출발지 설정";
}

abstract class StringEndSetup {
  StringEndSetup._();

  static const String title = "도착지 설정";
  static const String searchHint = "도착지 검색";
  static const String selectMap = "지도에서 선택";
  static const String edit = "편집";
  static const String recentKeyword = "최근 검색";
  static const String bottomButton = "도착지 설정";
}

abstract class StringStopOverSetup {
  StringStopOverSetup._();

  static const String title = "경유지 설정";
  static const String addButton = "+ 경유지 추가";
  static const String searchHint = "경유지 검색";
  static const String selectMap = "지도에서 선택";
  static const String edit = "편집";
  static const String recentKeyword = "최근 검색";
  static const String bottomButton = "경유지 등록";
}

abstract class StringPlaceSetup {
  StringPlaceSetup._();

  static const String title = "장소 설정";
  static const String searchHint = "장소 검색";
  static const String selectMap = "지도에서 선택";
  static const String edit = "편집";
  static const String recentKeyword = "최근 검색";
  static const String bottomButton = "장소 설정";
}

abstract class StringPlace {
  StringPlace._();

  static const String title = "자주 가는 장소";
  static const String addTitle = "자주 가는 장소 등록";
  static const String modifyTitle = "자주 가는 장소 수정";
  static const String bottomButton = "장소 추가";
  static const String noList = "등록된 정보가 없습니다.";

  static const String delete = "삭제";
  static const String modify = "수정";
  static const String deleteAlert = "자주 가는 장소를 삭제하시겠습니까?";
  static const String deleteSuccess = "자주 가는 장소가 삭제되었습니다.";
  static const String addSuccess = "등록이 완료되었습니다.";
  static const String modifySuccess = "수정이 완료되었습니다.";

  static const String placeNm = "장소 별명";
  static const String placeAddress = "장소 지정";
  static const String placeNmHint = "장소 별명을 입력해주세요.";
  static const String placeAddressHint = "장소를 지정해주세요.";
}

abstract class StringCar {
  StringCar._();

  static const String title = "차량정보";
  static const String bottomButton = "차량추가";
  static const String delete = "삭제";
  static const String modify = "수정";
  static const String deleteAlert = "차량을 삭제하시겠습니까?";
  static const String deleteSuccess = "차량정보가 삭제되었습니다.";
  static const String modifySuccess = "차량정보가 수정되었습니다.";
}

abstract class StringCall {
  StringCall._();

  static const String callContent = "(으)로\n호출하시겠습니까?";
  static const String waitTitle = "대기료 발생 안내";
  static const String waitContent = "대기료 발생 내용";
}

abstract class StringWork {
  StringWork._();

  static const String call = "전화";
  static const String cancel = "호출취소";
  static const String calling = "기사님 호출 진행중";
  static const String start = "출발";
  static const String stopOver = "경유";
  static const String end = "도착";
  static const String payment = "결제";
  static const String price = "요금";
  static const String date = "일시";

  static const String cancelConfirm = "호출을 취소하시겠습니까?";
  static const String cancelSuccess = "호출이 취소되었습니다.";
  static const String callConfirmAlert = "운행이 확정되었습니다.";
  static const String callWaitAlert = "기사님이 출발지에 도착했습니다.";
  static const String callStartAlert = "운행이 시작되었습니다.";
  static const String changeCallFeeAlert = "호출 요금을 변경했습니다.";
}

abstract class StringCallCancel {
  StringCallCancel._();

  static const String title = "호출을 취소하시겠습니까?";
  static const String content = "사유를 선택해주세요.";
  static const String typeOTHS = "다른 서비스 이용";
  static const String typeDRVC = "기사님 사정으로 연락 후 취소";
}

abstract class StringReservation {
  StringReservation._();

  static const String title = "예약 일시";
  static const String date = "일자";
  static const String time = "시간";
  static const String dateHint = "예약 일자를 선택해주세요.";
  static const String timeHint = "예약 시간을 선택해주세요.";
  static const String dateTitle = "예약 일자 선택";
  static const String timeTitle = "예약 시간 선택";
  static const String dateErrorToast = "현재 시간 이후로 선택해주세요.";

  static const String confirmTitle = "예약 정보 확인";
  static const String bottomButton = "예약 호출";

  static const String dateAndTime = "일시";
  static const String amount = "요금";
  static const String payment = "결제";
  static const String startSpot = "출발지";
  static const String endSpot = "도착지";
  static const String stopover = "경유지";

  static const String warningTitle = "유의사항 안내";
  static const String warningContent = "유의사항 내용";

  static const String cancelTitle = "취소 정책 안내";
  static const String cancelContent = "취소 정책 내용";

  static const String waitTitle = "대기료 발생 안내";
  static const String waitContent = "대기료 발생 내용";

  static const String reservationConfirmAlert = "예약이 접수되었습니다.";
}

abstract class StringNotice {
  StringNotice._();

  static const String title = "공지사항";
  static const String noticeDetail = "공지사항 상세";
}

abstract class StringInquiry {
  StringInquiry._();

  static const String title = "상담문의";
  static const String inquiryDetail = "상담문의 상세";
  static const String inquiryWrite = "상담문의 작성";
  static const String writeButton = "등록";
  static const String titleHint = "제목을 입력해주세요.";
  static const String contentHint = "내용을 입력해주세요.";
  static const String inquiryWriteSuccessAlert = "상담문의가 등록되었습니다.";
  static const String inquiryDeleteAlert = "해당 상담문의를 삭제하시겠습니까?";
  static const String inquiryDeleteSuccessAlert = "상담문의가 삭제되었습니다.";
}

abstract class StringOther {
  StringOther._();

  static const String title = "더보기";
  static const String delete = "삭제하기";
}

abstract class StringPush {
  StringPush._();

  static const String title = "대리기사";
  static const String callTitle = "대리기사 콜";
  static const String reservationTitle = "대리기사 예약콜";

  static const String cancelBody = "운행이 취소되었습니다.";
  static const String reviewBody = "리뷰가 등록되었습니다.";
  static const String feeBody1 = "호출 요금이 ";
  static const String feeBody2 = "으로 변경되었습니다.";
}

abstract class StringCalled {
  StringCalled._();

  static const String title = "이용내역";
  static const String noList = "최근 1년 동안 이용내역이 없습니다.";

  static const String callTitle = "이용 정보";
  static const String reservationTitle = "예약 정보";

  static const String infoTitle = "이용 정보";
  static const String paymentTitle = "결제 정보";
  static const String driverTitle = "기사 정보";
  static const String reservationStateTitle = "접수 완료";

  static const String date = "일시";
  static const String callType = "호출";
  static const String driveType = "상태";
  static const String startSpot = "출발지";
  static const String endSpot = "도착지";
  static const String stopover = "경유지";
  static const String payment = "결제";
  static const String amount = "요금";
  static const String delete = "삭제";
  static const String driver = "이름";
  static const String car = "차량";
  static const String review = "리뷰";

  static const String reviewModify = "리뷰 수정";
  static const String reCall = "다시 호출하기";

  static const String reservationState1 = "예약 접수";
  static const String reservationState2 = "기사님 호출중";
  static const String reservationState3 = "운행 준비";
  static const String reservationState4 = "운행중";
  static const String reservationCancel = "예약 취소";
  static const String reservationAdd = "대리 추가 호출";

  static const String reservationCancelConfirm = "예악을 취소하시겠습니까?";
  static const String reservationCancelSuccess = "예약이 취소되었습니다.";
  static const String deleteAlert = "이용 정보를 삭제하시겠습니까?";
  static const String deleteSuccess = "이용 정보가 삭제되었습니다.";
}
