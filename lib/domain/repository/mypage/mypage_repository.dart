import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_info_request.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';

abstract class MyPageRepository {
  Future<StateAPI> addCar({required CarInfoRequest carInfoRequest});
}
