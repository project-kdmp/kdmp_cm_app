import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/inquiry/inquiry_repository.dart';

class GetInquiryListUseCase {
  final InquiryRepository _inquiryRepository;

  GetInquiryListUseCase({required InquiryRepository inquiryRepository}) : _inquiryRepository = inquiryRepository;

  Future<StateAPI> execute({required InquiryListRequest inquiryListRequest}) async {
    return await _inquiryRepository.getInquiryList(inquiryListRequest: inquiryListRequest);
  }
}
