import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_add_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetCarAddUseCase {
  final MyPageRepository _myPageRepository;

  SetCarAddUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CarAddRequest carAddRequest}) async {
    return await _myPageRepository.addCar(carAddRequest: carAddRequest);
  }
}
