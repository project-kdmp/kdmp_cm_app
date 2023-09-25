import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_modify_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetPlaceModifyUseCase {
  final MyPageRepository _myPageRepository;

  SetPlaceModifyUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required PlaceModifyRequest placeModifyRequest}) async {
    return await _myPageRepository.modifyPlace(placeModifyRequest: placeModifyRequest);
  }
}
