import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_info_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetCarInfoUseCase {
  final MyPageRepository _myPageRepository;

  SetCarInfoUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CarInfoRequest carInfoRequest}) async {
    return await _myPageRepository.addCar(carInfoRequest: carInfoRequest);
  }
}
