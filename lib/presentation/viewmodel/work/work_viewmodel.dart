import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class WorkViewModel {
  WorkViewModel({
    required this.getMbrSqUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;

  /// 기사명
  final ValueNotifier<String> _name = ValueNotifier<String>("");

  ValueNotifier<String> get nameNotifier => _name;

  String get name => _name.value;

  set name(String value) => _name.value = value;

  /// 프로필 사진
  final ValueNotifier<String> _imagePath = ValueNotifier<String>("");

  ValueNotifier<String> get imagePathNotifier => _imagePath;

  String get imagePath => _imagePath.value;

  set imagePath(String value) => _imagePath.value = value;

  /// 상태
  StateAPI state = Loading();
}
