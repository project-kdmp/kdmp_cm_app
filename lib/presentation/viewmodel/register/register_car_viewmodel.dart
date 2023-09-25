import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_info_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class RegisterCarViewModel {
  RegisterCarViewModel({
    required this.getMbrSqUseCase,
    required this.setCarInfoUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetCarInfoUseCase setCarInfoUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 초기 차량정보 등록 API
  Future<StateAPI> addCarInfo(String carNumId) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CarInfoRequest(
      mbrSq: mbrSq,
      carNumId: carNumId,
    );
    final result = await setCarInfoUseCase.execute(carInfoRequest: request);
    state = result;

    return result;
  }
}
