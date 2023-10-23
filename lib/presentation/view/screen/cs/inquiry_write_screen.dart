import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/inquiry/set_inquiry_write_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/cs/inquiry_write_viewmodel.dart';

/// 상담문의 작성 화면
class InquiryWriteScreen extends StatefulWidget {
  const InquiryWriteScreen({Key? key}) : super(key: key);

  static const String routeName = "inquiry_write";

  @override
  State<InquiryWriteScreen> createState() => _InquiryWriteScreenState();
}

class _InquiryWriteScreenState extends State<InquiryWriteScreen> {
  late final InquiryWriteViewModel _inquiryWriteViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _inquiryWriteViewModel = InquiryWriteViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      setInquiryWriteUseCase: GetIt.instance<SetInquiryWriteUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringInquiry.inquiryWrite,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// 제목 입력
                    ValueListenableBuilder<String>(
                      valueListenable: _inquiryWriteViewModel.inquiryTitleNotifier,
                      builder: (context, value, _) {
                        return CustomTextField(
                          text: value,
                          hint: StringInquiry.titleHint,
                          backgroundColor: Colors.transparent,
                          onChanged: (value) {
                            _inquiryWriteViewModel.inquiryTitle = value;
                          },
                        );
                      },
                    ),

                    const Divider(
                      thickness: 1,
                      height: 36,
                    ),

                    /// 내용 입력
                    ValueListenableBuilder<String>(
                      valueListenable: _inquiryWriteViewModel.inquiryContentNotifier,
                      builder: (context, value, _) {
                        return Expanded(
                          child: CustomTextField(
                            text: value,
                            hint: StringInquiry.contentHint,
                            backgroundColor: Colors.transparent,
                            isExpands: true,
                            onChanged: (value) {
                              _inquiryWriteViewModel.inquiryContent = value;
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// 하단 버튼
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  /// 취소 버튼
                  Expanded(
                    child: CustomRadiusButton(
                      text: StringCommon.cancel,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// 등록 버튼
                  ValueListenableBuilder<bool>(
                    valueListenable: _inquiryWriteViewModel.isValidNotifier,
                    builder: (context, value, child) {
                      return Expanded(
                        child: CustomElevatedButton(
                          isEnabled: value,
                          text: StringInquiry.writeButton,
                          onPressed: () async {
                            /// 상담문의 등록
                            final result = await _inquiryWriteViewModel.writeInquiry();
                            if (result is Success) {
                              /// 상담문의 등록 성공 팝업 띄움
                              await _showAlertDialog(content: StringInquiry.inquiryWriteSuccessAlert, isCanceled: false);

                              /// 등록된 상담문의 번호
                              final inqSq = result.inquiryWriteResponse.inqSq;

                              /// 화면 닫기, 상담문의 리스트 재조회 후 상세 화면으로 이동
                              context.pop(inqSq);
                            } else if (result is Bad) {
                              Fluttertoast.showToast(msg: result.badResponse.detailMessage);
                            } else if (result is Fail) {
                              Fluttertoast.showToast(msg: "${result.errorMessage}");
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          isCanceled: isCanceled,
          isWarning: isWarning,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
