import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_modify_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_modify_request.dart';

abstract class MyPageRepository {
  Future<StateAPI> getProfileDetail({required DefaultRequest getProfileRequest});

  Future<StateAPI> withdrawalMember({required DefaultRequest withdrawalMemberRequest});

  Future<StateAPI> deletePlace({required PlaceDeleteRequest placeDeleteRequest});

  Future<StateAPI> deleteCar({required CarDeleteRequest carDeleteRequest});

  Future<StateAPI> deleteCalled({required DrvRequest calledDeleteRequest});

  Future<StateAPI> addPlace({required PlaceAddRequest placeAddRequest});

  Future<StateAPI> addCar({required CarAddRequest carAddRequest});

  Future<StateAPI> modifyPlace({required PlaceModifyRequest placeModifyRequest});

  Future<StateAPI> modifyCar({required CarModifyRequest carModifyRequest});

  Future<StateAPI> getCallDetail({required DrvRequest callDetailRequest});

  Future<StateAPI> getCallList({required CallListRequest callListRequest});

  Future<StateAPI> getCalledDetail({required DrvRequest calledDetailRequest});

  Future<StateAPI> getCalledList({required CalledListRequest calledListRequest});

  Future<StateAPI> getPlaceList({required DefaultRequest getPlaceListRequest});

  Future<StateAPI> getCarList({required DefaultRequest getCarListRequest});
}
