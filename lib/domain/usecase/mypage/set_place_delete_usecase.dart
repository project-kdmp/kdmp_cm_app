import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_delete_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetPlaceDeleteUseCase {
  final MyPageRepository _myPageRepository;

  SetPlaceDeleteUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required PlaceDeleteRequest placeDeleteRequest}) async {
    return await _myPageRepository.deletePlace(placeDeleteRequest: placeDeleteRequest);
  }
}
