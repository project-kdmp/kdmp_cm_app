import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/term/term_repository.dart';

class GetTermUseCase {
  final TermRepository _termRepository;

  GetTermUseCase({required TermRepository termRepository}) : _termRepository = termRepository;

  Future<StateAPI> getCMTermList({required DefaultRequest getCMTermListRequest}) async {
    return await _termRepository.getCMTermList(getCMTermListRequest: getCMTermListRequest);
  }

  Future<StateAPI> getTermList({required TermListRequest termListRequest}) async {
    return await _termRepository.getTermList(termListRequest: termListRequest);
  }

  Future<StateAPI> getTermDetail({required TermDetailRequest termDetailRequest}) async {
    return await _termRepository.getTermDetail(termDetailRequest: termDetailRequest);
  }

  Future<StateAPI> getDriverTerm({required DefaultRequest driverTermRequest}) async {
    return await _termRepository.getDriverTerm(driverTermRequest: driverTermRequest);
  }
}
