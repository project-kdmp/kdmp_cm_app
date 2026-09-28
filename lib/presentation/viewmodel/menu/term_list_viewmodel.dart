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
  /// 조회 상태.
  ///
  /// 평범한 필드면 값을 바꿔도 화면이 다시 그려지지 않는다. 그래서 화면은 목록이
  /// 비었을 때 불러오는 중인지 없는 것인지 실패인지 구분하지 못했다
  final ValueNotifier<StateAPI> _state = ValueNotifier<StateAPI>(Loading());

  ValueNotifier<StateAPI> get stateNotifier => _state;

  StateAPI get state => _state.value;

  set state(StateAPI value) => _state.value = value;

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
