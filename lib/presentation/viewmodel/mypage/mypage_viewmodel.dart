import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/logout/set_logout_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_profile_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class MyPageViewModel {
  MyPageViewModel({
    required this.getMbrSqUseCase,
    required this.setLogoutUseCase,
    required this.getProfileDetailUseCase,
    required this.deleteUserDataUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetLogoutUseCase setLogoutUseCase;
  final GetProfileDetailUseCase getProfileDetailUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  /// 이름
  final ValueNotifier<String> _name = ValueNotifier<String>("");

  ValueNotifier<String> get nameNotifier => _name;

  String get name => _name.value;

  set name(String value) => _name.value = value;

  /// 휴대폰번호
  final ValueNotifier<String> _phone = ValueNotifier<String>("");

  ValueNotifier<String> get phoneNotifier => _phone;

  String get phone => _phone.value;

  set phone(String value) => _phone.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 로그아웃 API
  Future<StateAPI> logout() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await setLogoutUseCase.execute(logoutRequest: request);
    state = result;

    if (result is Success) {
      await deleteUserDataUseCase.logout();
    }

    return result;
  }

  /// 프로필 상세 정보 조회 API
  Future<StateAPI> getProfileDetail() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await getProfileDetailUseCase.execute(getProfileRequest: request);
    state = result;

    if (result is Success) {
      final response = result.profileDetailResponse;
      name = response.mbrNm;
      phone = response.mbrMobilePhone;
    }

    return result;
  }
}
