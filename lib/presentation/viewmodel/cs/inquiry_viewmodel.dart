import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/get_inquiry_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class InquiryViewModel {
  InquiryViewModel({
    required this.getMbrSqUseCase,
    required this.getInquiryListUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetInquiryListUseCase getInquiryListUseCase;

  /// 현재 페이지
  final ValueNotifier<int> _page = ValueNotifier<int>(0);

  ValueNotifier<int> get pageNotifier => _page;

  int get page => _page.value;

  set page(int value) => _page.value = value;

  /// 다음 페이지 유무
  final ValueNotifier<bool> _isNextPage = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isNextPageNotifier => _isNextPage;

  bool get isNextPage => _isNextPage.value;

  set isNextPage(bool value) => _isNextPage.value = value;

  /// 상담문의 리스트
  final ValueNotifier<List<Inquiry>> _inquiryList = ValueNotifier<List<Inquiry>>(List.empty());

  ValueNotifier<List<Inquiry>> get inquiryListNotifier => _inquiryList;

  List<Inquiry> get inquiryList => _inquiryList.value;

  set inquiryList(List<Inquiry> value) => _inquiryList.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 상담문의 리스트 조회 API
  void getInquiryList() async {
    if (!isNextPage) {
      return;
    }

    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = InquiryListRequest(cmMbrSq: mbrSq, page: page + 1, pageSize: 10);
    final result = await getInquiryListUseCase.execute(inquiryListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.inquiryListResponse;

      List<Inquiry> copyList = List.from(inquiryList);
      copyList.addAll(response.resultList);
      inquiryList = copyList;

      page = response.pagination.page;
      isNextPage = response.pagination.existNextPage;
    }
  }
}
