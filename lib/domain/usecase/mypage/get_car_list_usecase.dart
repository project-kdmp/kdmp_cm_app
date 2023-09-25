import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetCarListUseCase {
  final MyPageRepository _myPageRepository;

  GetCarListUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required DefaultRequest carListRequest}) async {
    return await _myPageRepository.getCarList(getCarListRequest: carListRequest);
  }
}
