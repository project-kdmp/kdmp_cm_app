import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_request.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/set_inquiry_write_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class InquiryWriteViewModel {
  InquiryWriteViewModel({
    required this.getMbrSqUseCase,
    required this.setInquiryWriteUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetInquiryWriteUseCase setInquiryWriteUseCase;

  /// 상담문의 제목
  final ValueNotifier<String> _inquiryTitle = ValueNotifier<String>("");

  ValueNotifier<String> get inquiryTitleNotifier => _inquiryTitle;

  String get inquiryTitle => _inquiryTitle.value;

  set inquiryTitle(String value) {
    _inquiryTitle.value = value;
    _checkIsValid();
  }

  /// 상담문의 내용
  final ValueNotifier<String> _inquiryContent = ValueNotifier<String>("");

  ValueNotifier<String> get inquiryContentNotifier => _inquiryContent;

  String get inquiryContent => _inquiryContent.value;

  set inquiryContent(String value) {
    _inquiryContent.value = value;
    _checkIsValid();
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid;
    debugPrint("$inquiryTitle, $inquiryContent");
    if (inquiryTitle.trim().isNotEmpty && inquiryContent.trim().isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  /// 상태
  StateAPI state = Loading();

  /// 상담문의 등록 API
  Future<StateAPI> writeInquiry() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final inqRegIp = await IpAddress().getIpAddress();
    debugPrint("=====ip=$inqRegIp");

    final request = InquiryWriteRequest(
      cmMbrSq: mbrSq,
      inqAskTitle: inquiryTitle,
      inqAskContent: inquiryContent,
      inqRegIp: inqRegIp,
    );
    final result = await setInquiryWriteUseCase.execute(inquiryWriteRequest: request);
    state = result;

    return result;
  }
}
