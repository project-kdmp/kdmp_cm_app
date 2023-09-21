import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';

class DriverTermViewModel {
  final GetTermUseCase getTermUseCase;

  DriverTermViewModel({required this.getTermUseCase});

  /// 운행불가차량 제목
  final ValueNotifier<String> _termTitle = ValueNotifier<String>("");

  ValueNotifier<String> get termTitleNotifier => _termTitle;

  String get termTitle => _termTitle.value;

  set termTitle(String value) => _termTitle.value = value;

  /// 운행불가차량 내용
  final ValueNotifier<String> _termContent = ValueNotifier<String>("");

  ValueNotifier<String> get termContentNotifier => _termContent;

  String get termContent => _termContent.value;

  set termContent(String value) => _termContent.value = value;

  /// 운행불가차량 내용 조회 API
  Future<StateAPI> getTermDetail() async {
    state = Loading();

    final request = DefaultRequest(mbrSq: 0);
    final result = await getTermUseCase.getDriverTerm(driverTermRequest: request);
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
