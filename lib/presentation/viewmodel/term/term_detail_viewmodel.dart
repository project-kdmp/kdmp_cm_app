import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_request.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';

class TermDetailViewModel {
  final GetTermUseCase getTermUseCase;

  TermDetailViewModel({required this.getTermUseCase});

  /// 이용약관 제목
  final ValueNotifier<String> _termTitle = ValueNotifier<String>("");

  ValueNotifier<String> get termTitleNotifier => _termTitle;

  String get termTitle => _termTitle.value;

  set termTitle(String value) => _termTitle.value = value;

  /// 이용약관 내용
  final ValueNotifier<String> _termContent = ValueNotifier<String>("");

  ValueNotifier<String> get termContentNotifier => _termContent;

  String get termContent => _termContent.value;

  set termContent(String value) => _termContent.value = value;

  /// 이용약관 내용 조회 API
  Future<StateAPI> getTermDetail({required int trmSq}) async {
    state = Loading();

    final request = TermDetailRequest(trmSq: trmSq);
    final result = await getTermUseCase.getTermDetail(termDetailRequest: request);
    state = result;

    if (result is Success) {
      termTitle = result.termDetailResponse.trmTitle ?? "";
      termContent = result.termDetailResponse.trmHtml ?? "";
    }

    return result;
  }

  /// 상태
  StateAPI state = Loading();
}
