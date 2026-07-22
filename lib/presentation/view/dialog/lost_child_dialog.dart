import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_response.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';

/// 서버가 MIME 인코더(76자마다 줄바꿈 삽입) 형식으로 base64를 내려줄 수 있어
/// 공백/개행 문자를 제거하고 패딩('=')을 보정한다.
String _normalizeBase64(String value) {
  var sanitized = value.replaceAll(RegExp(r'\s'), '');
  final mod = sanitized.length % 4;
  if (mod != 0) {
    sanitized += '=' * (4 - mod);
  }
  return sanitized;
}

/// 실종아동 찾기 안내 팝업
class LostChildDialog extends StatelessWidget {
  const LostChildDialog({
    Key? key,
    required this.lostChildList,
    required this.lostChildHour,
  }) : super(key: key);

  final List<LostChild> lostChildList;
  final int lostChildHour;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 제목
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  StringLostChild.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              /// 스크롤 영역 (안내문구 + 실종아동 리스트)
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 안내문구
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// 앱 로고 (스플래시 화면과 동일한 로고 사용)
                                  Image.asset(
                                    Theme.of(context).brightness == Brightness.light ? ImageCommon.appLogoLight : ImageCommon.appLogoDark,
                                    width: 28,
                                    height: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      StringLostChild.introText,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                StringLostChild.noticeCycle.replaceFirst('%d', '$lostChildHour'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// 실종아동 리스트 (2열, 아래로 스크롤 시 전체 노출)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const spacing = 10.0;
                            final itemWidth = (constraints.maxWidth - spacing) / 2;
                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: lostChildList.map((child) => _LostChildCard(child: child, width: itemWidth)).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),

              /// 확인 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      StringCommon.confirm,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LostChildCard extends StatelessWidget {
  const _LostChildCard({required this.child, required this.width});

  final LostChild child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final genderText = getSexdstn(child.sexdstnDscd);
    final isMale = isMaleSexdstn(child.sexdstnDscd);
    final occrde = getNonNullText(child.occrde);
    final occrAdres = getNonNullText(child.occrAdres);
    final alldressingDscd = getNonNullText(child.alldressingDscd);
    final etcSpfeatr = getNonNullText(child.etcSpfeatr);

    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 사진
          _LostChildPhoto(tknphotoFile: child.tknphotoFile),
          const SizedBox(height: 8),

          /// 이름, 성별
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: child.nm),
                if (genderText.isNotEmpty)
                  TextSpan(
                    text: " ($genderText)",
                    style: TextStyle(color: isMale ? const Color(0xFF3B5BDB) : const Color(0xFFE64980)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          /// 나이
          Text(
            "${StringLostChild.ageThen.replaceFirst('%d', '${child.age}')}\n${StringLostChild.ageNow.replaceFirst('%d', '${child.ageNow}')}",
            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.65)),
          ),
          const SizedBox(height: 8),

          if (occrde.isNotEmpty) _LostChildField(label: StringLostChild.occurredDt, value: getDateFormat(date: occrde)),
          if (occrAdres.isNotEmpty) _LostChildField(label: StringLostChild.occurredPlace, value: occrAdres),
          if (alldressingDscd.isNotEmpty) _LostChildField(label: StringLostChild.appearance, value: alldressingDscd),
          if (etcSpfeatr.isNotEmpty) _LostChildField(label: StringLostChild.feature, value: etcSpfeatr),
        ],
      ),
    );
  }
}

class _LostChildPhoto extends StatelessWidget {
  const _LostChildPhoto({required this.tknphotoFile});

  final String? tknphotoFile;

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    final photo = getNonNullText(tknphotoFile);
    if (photo.isNotEmpty) {
      try {
        bytes = base64Decode(_normalizeBase64(photo));
      } catch (e) {
        debugPrint("lostChild photo decode failed: $e");
        bytes = null;
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _noPhoto(context),
              )
            : _noPhoto(context),
      ),
    );
  }

  Widget _noPhoto(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 40, color: Theme.of(context).disabledColor),
          const SizedBox(height: 6),
          Text(
            StringLostChild.noPhoto,
            style: TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}

class _LostChildField extends StatelessWidget {
  const _LostChildField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
