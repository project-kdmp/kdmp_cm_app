import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_request.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_detail_usecase.dart';

class InquiryDetailViewModel {
  InquiryDetailViewModel({
    required this.getInquiryDetailUseCase,
  });

  final GetInquiryDetailUseCase getInquiryDetailUseCase;

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

  /// 상담문의 내용 조회 API
  Future<void> getInquiryDetail({required int inqSq}) async {
    state = Loading();

    final request = InquiryDetailRequest(inqSq: inqSq);
    final result = await getInquiryDetailUseCase.execute(inquiryDetailRequest: request);
    state = result;

    if (result is Success) {
      inquiryTitle = result.inquiryDetailResponse.inqAskTitle ?? "";
      inquiryDate = result.inquiryDetailResponse.createDt ?? "";
      inquiryContent = result.inquiryDetailResponse.inqAskContent ?? "";
    }
  }

  /// 상태
  StateAPI state = Loading();
}
