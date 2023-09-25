import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_delete_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetCarDeleteUseCase {
  final MyPageRepository _myPageRepository;

  SetCarDeleteUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CarDeleteRequest carDeleteRequest}) async {
    return await _myPageRepository.deleteCar(carDeleteRequest: carDeleteRequest);
  }
}
