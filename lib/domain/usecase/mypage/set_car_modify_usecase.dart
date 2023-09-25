import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_modify_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetCarModifyUseCase {
  final MyPageRepository _myPageRepository;

  SetCarModifyUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CarModifyRequest carModifyRequest}) async {
    return await _myPageRepository.modifyCar(carModifyRequest: carModifyRequest);
  }
}
