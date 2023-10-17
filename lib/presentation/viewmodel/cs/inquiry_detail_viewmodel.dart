import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_delete_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_request.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/set_inquiry_delete_usecase.dart';

class InquiryDetailViewModel {
  InquiryDetailViewModel({
    required this.getInquiryDetailUseCase,
    required this.setInquiryDeleteUseCase,
  });

  final GetInquiryDetailUseCase getInquiryDetailUseCase;
  final SetInquiryDeleteUseCase setInquiryDeleteUseCase;

  /// 상담문의 제목
  final ValueNotifier<String> _inquiryTitle = ValueNotifier<String>("");

  ValueNotifier<String> get inquiryTitleNotifier => _inquiryTitle;

  String get inquiryTitle => _inquiryTitle.value;

  set inquiryTitle(String value) => _inquiryTitle.value = value;

  /// 상담문의 날짜
  final ValueNotifier<String> _inquiryDate = ValueNotifier<String>("");

  ValueNotifier<String> get inquiryDateNotifier => _inquiryDate;

  String get inquiryDate => _inquiryDate.value;

  set inquiryDate(String value) => _inquiryDate.value = value;

  /// 상담문의 내용
  final ValueNotifier<String> _inquiryContent = ValueNotifier<String>("");

  ValueNotifier<String> get inquiryContentNotifier => _inquiryContent;

  String get inquiryContent => _inquiryContent.value;

  set inquiryContent(String value) => _inquiryContent.value = value;

  /// 상담문의 답변
  final ValueNotifier<String> _answerContent = ValueNotifier<String>("");

  ValueNotifier<String> get answerContentNotifier => _answerContent;

  String get answerContent => _answerContent.value;

  set answerContent(String value) => _answerContent.value = value;

  /// 상담문의 답변
  final ValueNotifier<String> _answerDt = ValueNotifier<String>("");

  ValueNotifier<String> get answerDtNotifier => _answerDt;

  String get answerDt => _answerDt.value;

  set answerDt(String value) => _answerDt.value = value;

  /// 상담문의 답변자
  final ValueNotifier<String> _answerId = ValueNotifier<String>("");

  ValueNotifier<String> get answerIdNotifier => _answerId;

  String get answerId => _answerId.value;

  set answerId(String value) => _answerId.value = value;

  /// 상담문의 답변상태
  final ValueNotifier<bool> _isAnswer = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isAnswerNotifier => _isAnswer;

  bool get isAnswer => _isAnswer.value;

  set isAnswer(bool value) => _isAnswer.value = value;

  /// 상담문의 내용 조회 API
  Future<void> getInquiryDetail({required int inqSq}) async {
    state = Loading();

    final request = InquiryDetailRequest(inqSq: inqSq);
    final result = await getInquiryDetailUseCase.execute(inquiryDetailRequest: request);
    state = result;

    if (result is Success) {
      final response = result.inquiryDetailResponse;
      inquiryTitle = response.inqAskTitle ?? "";
      inquiryDate = response.createDt ?? "";
      inquiryContent = response.inqAskContent ?? "";
      answerId = response.mbrAdmNm ?? "";
      answerContent = response.inqRtnContent ?? "";
      answerDt = response.updateDt ?? "";
      isAnswer = (response.inqRtnSt ?? "") == InqRtnSt.comp;
    }
  }

  /// 상담문의 삭제 API
  Future<StateAPI> deleteInquiry({required int inqSq}) async {
    state = Loading();

    final request = InquiryDeleteRequest(inqSq: inqSq);
    final result = await setInquiryDeleteUseCase.execute(inquiryDeleteRequest: request);
    state = result;

    return result;
  }

  /// 상태
  StateAPI state = Loading();
}
