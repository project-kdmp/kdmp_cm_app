import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';

class TermListViewModel {
  final GetTermUseCase getTermUseCase;

  TermListViewModel({required this.getTermUseCase});

  /// 이용약관 목록
  final ValueNotifier<List<Term>> _termList = ValueNotifier<List<Term>>([]);

  ValueNotifier<List<Term>> get termListNotifier => _termList;

  List<Term> get termList => _termList.value;

  set termList(List<Term> value) => _termList.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 이용약관 목록 조회 API
  Future<StateAPI> getTermList({String trmTp = ""}) async {
    state = Loading();

    final request = TermListRequest(trmTp: trmTp);
    final result = await getTermUseCase.getTermList(termListRequest: request);
    state = result;

    if (result is Success) {
      termList = result.termListResponse.resultList;
    }

    return result;
  }
}
