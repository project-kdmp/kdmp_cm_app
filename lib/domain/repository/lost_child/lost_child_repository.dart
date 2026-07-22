import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_request.dart';

abstract class LostChildRepository {
  Future<StateAPI> getLostChildList({required LostChildListRequest lostChildListRequest});
}
