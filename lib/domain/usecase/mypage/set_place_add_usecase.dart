import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_add_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetPlaceAddUseCase {
  final MyPageRepository _myPageRepository;

  SetPlaceAddUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required PlaceAddRequest placeAddRequest}) async {
    return await _myPageRepository.addPlace(placeAddRequest: placeAddRequest);
  }
}
