import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_delete_response.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_detail_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_list_request.dart';
import 'package:kdmp_cm_app/data/model/inquiry/inquiry_write_request.dart';

abstract class InquiryRepository {
  Future<StateAPI> getInquiryList({required InquiryListRequest inquiryListRequest});

  Future<StateAPI> getInquiryDetail({required InquiryDetailRequest inquiryDetailRequest});

  Future<StateAPI> writeInquiry({required InquiryWriteRequest inquiryWriteRequest});

  Future<StateAPI> deleteInquiry({required InquiryDeleteRequest inquiryDeleteRequest});
}
