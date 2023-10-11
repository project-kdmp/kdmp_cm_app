import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_request.dart';
import 'package:kdmp_cm_app/domain/repository/inquiry/inquiry_repository.dart';

class GetInquiryDetailUseCase {
  final InquiryRepository _inquiryRepository;

  GetInquiryDetailUseCase({required InquiryRepository inquiryRepository}) : _inquiryRepository = inquiryRepository;

  Future<StateAPI> execute({required InquiryDetailRequest inquiryDetailRequest}) async {
    return await _inquiryRepository.getInquiryDetail(inquiryDetailRequest: inquiryDetailRequest);
  }
}
