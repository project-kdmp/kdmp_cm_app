import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/lost_child/lost_child_repository.dart';

class GetLostChildListUseCase {
  final LostChildRepository _lostChildRepository;

  GetLostChildListUseCase({required LostChildRepository lostChildRepository}) : _lostChildRepository = lostChildRepository;

  Future<StateAPI> execute({required LostChildListRequest lostChildListRequest}) async {
    return await _lostChildRepository.getLostChildList(lostChildListRequest: lostChildListRequest);
  }
}
