import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/term/my_term_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_detail_request.dart';
import 'package:kdmp_cm_app/data/model/term/term_list_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/term/term_repository.dart';

class SetMyTermUseCase {
  final TermRepository _termRepository;

  SetMyTermUseCase({required TermRepository termRepository}) : _termRepository = termRepository;

  Future<StateAPI> execute({required MyTermRequest myTermRequest}) async {
    return await _termRepository.setMyTerm(myTermRequest: myTermRequest);
  }
}