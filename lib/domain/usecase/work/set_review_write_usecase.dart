import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/review_write_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetReviewWriteUseCase {
  final WorkRepository _workRepository;

  SetReviewWriteUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required ReviewWriteRequest reviewWriteRequest}) async {
    return await _workRepository.writeReview(reviewWriteRequest: reviewWriteRequest);
  }
}
