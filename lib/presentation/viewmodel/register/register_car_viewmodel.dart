import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_add_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class RegisterCarViewModel {
  RegisterCarViewModel({
    required this.getMbrSqUseCase,
    required this.setCarAddUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetCarAddUseCase setCarAddUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 초기 차량정보 등록 API
  Future<StateAPI> addCarInfo(String carNumId) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CarAddRequest(
      mbrSq: mbrSq,
      carNumId: carNumId,
    );
    final result = await setCarAddUseCase.execute(carAddRequest: request);
    state = result;

    return result;
  }
}
