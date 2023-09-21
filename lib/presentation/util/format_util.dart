/// 이메일 정규표현식 체크
bool checkEmailFormat(String text) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$").hasMatch(text);
}

/// 운전면허번호 정규표현식 체크
bool checkDriverLicenseNumberFormat(String text) {
  return RegExp(r"^(\d{2}-\d{2}-\d{6}-\d{2})$").hasMatch(text);
}

/// 계좌번호 정규표현식 체크
bool checkAccountNumberFormat(String text) {
  return RegExp(r"^[0-9]+$").hasMatch(text);
}
