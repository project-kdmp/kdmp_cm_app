import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_delete_response.dart';
import 'package:kdmp_cm_app/domain/repository/inquiry/inquiry_repository.dart';

class SetInquiryDeleteUseCase {
  final InquiryRepository _inquiryRepository;

  SetInquiryDeleteUseCase({required InquiryRepository inquiryRepository}) : _inquiryRepository = inquiryRepository;

  Future<StateAPI> execute({required InquiryDeleteRequest inquiryDeleteRequest}) async {
    return await _inquiryRepository.deleteInquiry(inquiryDeleteRequest: inquiryDeleteRequest);
  }
}
