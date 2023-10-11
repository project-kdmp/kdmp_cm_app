import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';

/// 리뷰 작성 팝업
class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({
    Key? key,
    this.star = 0,
    this.review = "",
    required this.onPressed,
  }) : super(key: key);

  final int star;
  final String review;
  final Function(int star, String review) onPressed;

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  /// 리뷰 점수
  final ValueNotifier<int> _star = ValueNotifier<int>(0);

  ValueNotifier<int> get starNotifier => _star;

  int get star => _star.value;

  set star(int value) {
    _star.value = value;
    _checkIsValid();
  }

  /// 리뷰 메세지
  final ValueNotifier<String> _review = ValueNotifier<String>("");

  ValueNotifier<String> get reviewNotifier => _review;

  String get review => _review.value;

  set review(String value) => _review.value = value;

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid;
    if (star > 0) {
      valid = true;
    } else {
      valid = false;
    }
    _setIsValid(value: valid);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    star = widget.star;
    review = widget.review;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            /// 상단 타이틀
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 타이틀
                  Text(
                    widget.star == 0 ? StringReview.title : StringReview.titleChange,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 내용
            Text(StringReview.content1, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(StringReview.content2),

            /// 별점 선택
            Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                valueListenable: starNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.star, color: value > 0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 36),
                        onTap: () => star = 1,
                      ),
                      GestureDetector(
                        child: Icon(Icons.star, color: value > 1 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 36),
                        onTap: () => star = 2,
                      ),
                      GestureDetector(
                        child: Icon(Icons.star, color: value > 2 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 36),
                        onTap: () => star = 3,
                      ),
                      GestureDetector(
                        child: Icon(Icons.star, color: value > 3 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 36),
                        onTap: () => star = 4,
                      ),
                      GestureDetector(
                        child: Icon(Icons.star, color: value > 4 ? Theme.of(context).colorScheme.secondary : Theme.of(context).dividerColor, size: 36),
                        onTap: () => star = 5,
                      ),
                    ],
                  );
                },
              ),
            ),

            /// 리뷰 입력
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ValueListenableBuilder<String>(
                valueListenable: reviewNotifier,
                builder: (context, value, child) {
                  return CustomTextField(
                    text: value,
                    hint: StringReview.messageHint,
                    onChanged: (value) {
                      review = value;
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  /// 나중에 평가 버튼
                  Expanded(
                    child: CustomRadiusButton(
                      text: StringReview.cancelButton,
                      onPressed: () {
                        context.pop(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// 확인 버튼
                  ValueListenableBuilder<bool>(
                    valueListenable: isValidNotifier,
                    builder: (context, value, child) {
                      return Expanded(
                        child: CustomElevatedButton(
                          isEnabled: value,
                          text: StringReview.confirmButton,
                          onPressed: () {
                            widget.onPressed(star, review);
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
}
