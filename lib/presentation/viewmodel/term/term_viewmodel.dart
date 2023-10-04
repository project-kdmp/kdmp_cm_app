import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';

/// 이용약관 관련 뷰모델
///
/// 상태는 기본적으로 모두 뷰모델 내부에 위치합니다
/// 뷰모델 외부에선 뷰모델의 Getter/Setter 를 통해서 뷰모델의 상태에 접근합니다
class TermViewModel {
  final GetTermUseCase getTermUseCase;

  TermViewModel({required this.getTermUseCase});

  /// 전체 이용약관
  final ValueNotifier<bool> _isAllCheck = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isAllCheckNotifier => _isAllCheck;

  bool get isAllCheck => _isAllCheck.value;

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    var valid = true;
    for (var item in agreeTermList) {
      if (item.trmMandatoryYn == "Y" && item.agreeYn == "N") valid = false;
    }
    _setIsValid(value: valid);
  }

  _setAllCheck({required bool value}) {
    _isAllCheck.value = value;
  }

  checkAllCheck() {
    var valid = true;
    for (var item in agreeTermList) {
      if (item.agreeYn == "N") valid = false;
    }
    _setAllCheck(value: valid);
  }

  /// 이용약관 목록
  final ValueNotifier<List<Term>> _termList = ValueNotifier<List<Term>>([]);

  ValueNotifier<List<Term>> get termListNotifier => _termList;

  List<Term> get termList => _termList.value;

  set termList(List<Term> value) {
    _termList.value = value;
    setAgreeTermList(value: value);
    checkAllCheck();
    _checkIsValid();
  }

  /// 이용약관 동의여부 목록
  final ValueNotifier<List<TempAgreeTerm>> _agreeTermList = ValueNotifier<List<TempAgreeTerm>>([]);

  ValueNotifier<List<TempAgreeTerm>> get agreeTermListNotifier => _agreeTermList;

  List<TempAgreeTerm> get agreeTermList => _agreeTermList.value;

  setAgreeTermList({required List<Term> value}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    for (var item in termList) {
      newAgreeTermList.add(TempAgreeTerm(trmSq: item.trmSq, trmMandatoryYn: item.trmMandatoryYn ?? "N"));
    }
    _agreeTermList.value = newAgreeTermList;
  }

  setAgreeTermToIndex({required int index, required bool isAgreeYn}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    newAgreeTermList.addAll(agreeTermList);
    newAgreeTermList[index].agreeYn = isAgreeYn ? "Y" : "N";
    _agreeTermList.value = newAgreeTermList;
    checkAllCheck();
    _checkIsValid();
  }

  setAgreeTermToAll({required bool isAgreeYn}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    newAgreeTermList.addAll(agreeTermList);
    for (var item in newAgreeTermList) {
      item.agreeYn = isAgreeYn ? "Y" : "N";
    }
    _agreeTermList.value = newAgreeTermList;
    checkAllCheck();
    _checkIsValid();
  }

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
