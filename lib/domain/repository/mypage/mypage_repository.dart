import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_info_request.dart';

abstract class MyPageRepository {
  Future<StateAPI> getProfileDetail({required DefaultRequest getProfileRequest});

  Future<StateAPI> addCar({required CarInfoRequest carInfoRequest});
}
