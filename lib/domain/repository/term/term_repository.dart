import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';

abstract class TermRepository {
  Future<StateAPI> getCMTermList({required DefaultRequest getCMTermListRequest});

  Future<StateAPI> getTermList({required TermListRequest termListRequest});

  Future<StateAPI> getTermDetail({required TermDetailRequest termDetailRequest});

  Future<StateAPI> getDriverTerm({required DefaultRequest driverTermRequest});
}
