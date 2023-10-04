import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/term/cm_term_list_response.dart';
import 'package:kdmp_cm_app/data/model/term/my_term_request.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/set_my_term_usecase.dart';

/// 이용약관 관련 뷰모델
///
/// 상태는 기본적으로 모두 뷰모델 내부에 위치합니다
/// 뷰모델 외부에선 뷰모델의 Getter/Setter 를 통해서 뷰모델의 상태에 접근합니다
class CMTermViewModel {
  CMTermViewModel({
    required this.getMbrSqUseCase,
    required this.getTermUseCase,
    required this.setMyTermUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetTermUseCase getTermUseCase;
  final SetMyTermUseCase setMyTermUseCase;

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
    for (var item in tempAgreeTermList) {
      if (item.trmMandatoryYn == "Y" && item.agreeYn == "N") valid = false;
    }
    _setIsValid(value: valid);
  }

  _setAllCheck({required bool value}) {
    _isAllCheck.value = value;
  }

  checkAllCheck() {
    var valid = true;
    for (var item in tempAgreeTermList) {
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
  final ValueNotifier<List<TempAgreeTerm>> _tempAgreeTermList = ValueNotifier<List<TempAgreeTerm>>([]);

  ValueNotifier<List<TempAgreeTerm>> get tempAgreeTermListNotifier => _tempAgreeTermList;

  List<TempAgreeTerm> get tempAgreeTermList => _tempAgreeTermList.value;

  setAgreeTermList({required List<Term> value}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    for (var item in termList) {
      newAgreeTermList.add(TempAgreeTerm(trmSq: item.trmSq, trmMandatoryYn: item.trmMandatoryYn ?? "N"));
    }
    _tempAgreeTermList.value = newAgreeTermList;
  }

  setAgreeTermToIndex({required int index, required bool isAgreeYn}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    newAgreeTermList.addAll(tempAgreeTermList);
    newAgreeTermList[index].agreeYn = isAgreeYn ? "Y" : "N";
    _tempAgreeTermList.value = newAgreeTermList;
    checkAllCheck();
    _checkIsValid();
  }

  setAgreeTermToAll({required bool isAgreeYn}) {
    var newAgreeTermList = List<TempAgreeTerm>.from([]);
    newAgreeTermList.addAll(tempAgreeTermList);
    for (var item in newAgreeTermList) {
      item.agreeYn = isAgreeYn ? "Y" : "N";
    }
    _tempAgreeTermList.value = newAgreeTermList;
    checkAllCheck();
    _checkIsValid();
  }

  /// 상태
  StateAPI state = Loading();

  /// 이용약관 목록 조회 API
  Future<StateAPI> getCMTermList() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await getTermUseCase.getCMTermList(getCMTermListRequest: request);
    state = result;

    if (result is Success) {
      List<Term> newTermList = [];
      for (var item in result.cmTermListResponse.resultList) {
        if (item.agreeYn == "N") {
          newTermList.add(item);
        }
      }
      termList = newTermList;
    }

    return result;
  }

  /// 이용약관 동의하기 API
  Future<StateAPI> agreeTerms() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final agreeTermList = List<AgreeTerm>.from({});
    for (int i = 0; i < tempAgreeTermList.length; i++) {
      agreeTermList.add(AgreeTerm(trmSq: tempAgreeTermList[i].trmSq, agreeYn: tempAgreeTermList[i].agreeYn));
    }

    final request = MyTermRequest(
      mbrSq: mbrSq,
      agreeTermList: agreeTermList,
    );
    final result = await setMyTermUseCase.execute(myTermRequest: request);
    state = result;

    return result;
  }
}
