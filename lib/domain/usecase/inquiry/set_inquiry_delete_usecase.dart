import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_request.dart';
import 'package:kdmp_cm_app/domain/repository/inquiry/inquiry_repository.dart';

class SetInquiryWriteUseCase {
  final InquiryRepository _inquiryRepository;

  SetInquiryWriteUseCase({required InquiryRepository inquiryRepository}) : _inquiryRepository = inquiryRepository;

  Future<StateAPI> execute({required InquiryWriteRequest inquiryWriteRequest}) async {
    return await _inquiryRepository.writeInquiry(inquiryWriteRequest: inquiryWriteRequest);
  }
}
