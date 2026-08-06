import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';

/// 취소사유 항목 (cancelReason으로 보낼 상세사유 코드/문구와, drvCancelTp로 보낼 대분류 코드)
class _CancelReason {
  const _CancelReason({required this.code, required this.label, required this.drvCancelTp});

  final String code;
  final String label;
  final String drvCancelTp;
}

/// 호출취소 사유선택 팝업
class CallCancelDialog extends StatefulWidget {
  const CallCancelDialog({
    Key? key,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  final Function(String drvCancelTp, String cancelReason) onConfirm;
  final Function()? onCancel;

  @override
  State<CallCancelDialog> createState() => _CallCancelDialogState();
}

class _CallCancelDialogState extends State<CallCancelDialog> {
  /// 취소사유 목록 (자주 바뀌지 않는 값이라 서버 조회 없이 로컬 고정)
  static const List<_CancelReason> _reasons = [
    _CancelReason(code: '001', label: '콜이 안 잡혀요', drvCancelTp: DrvCancelTp.etcd),
    _CancelReason(code: '002', label: '다른 교통수단 이용', drvCancelTp: DrvCancelTp.etcd),
    _CancelReason(code: '003', label: '다른 대리운전업체 이용', drvCancelTp: DrvCancelTp.oths),
    _CancelReason(code: '999', label: '직접 입력', drvCancelTp: DrvCancelTp.etcd),
  ];

  _CancelReason _selected = _reasons.first;

  bool get _isDirectInputSelected => _selected.code == '999';

  /// 직접입력 사유
  final TextEditingController _cancelReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      actionsPadding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 24),

          /// 제목
          const Text(StringCallCancel.title, textAlign: TextAlign.center),
          const SizedBox(height: 4),

          /// 내용
          Text(StringCallCancel.content, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          /// 취소사유 목록
          ..._reasons.map(
            (reason) => RadioListTile(
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              title: Text(
                reason.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              value: reason.code,
              groupValue: _selected.code,
              onChanged: (radioValue) {
                setState(() {
                  _selected = _reasons.firstWhere((r) => r.code == radioValue);
                });
              },
            ),
          ),

          /// 직접입력 텍스트 필드
          if (_isDirectInputSelected)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: TextField(
                controller: _cancelReasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: StringCallCancel.etcHint,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: StringCommon.cancel,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).disabledColor,
                onPressed: widget.onCancel != null ? () => widget.onCancel!() : () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                text: StringCommon.confirm,
                onPressed: () => widget.onConfirm(
                  _selected.drvCancelTp,
                  _isDirectInputSelected ? _cancelReasonController.text.trim() : _selected.code,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
