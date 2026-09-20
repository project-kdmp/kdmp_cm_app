import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';

/// 요금 입력 팝업
class CallPriceBottomSheet extends StatefulWidget {
  const CallPriceBottomSheet({
    Key? key,
    required this.minPrice,
    this.initPrice,
  }) : super(key: key);

  final int minPrice;
  final int? initPrice;

  @override
  State<CallPriceBottomSheet> createState() => _CallPriceBottomSheetState();
}

class _CallPriceBottomSheetState extends State<CallPriceBottomSheet> {
  /// 요금을 움직이는 단위. 버튼도 휠도 이 폭으로 움직인다
  static const int _step = 1000;

  /// 휠이 한 번에 담는 폭. 대리운전 요금이 이 범위를 넘는 일은 드물다
  static const int _spread = 200000;

  static const double _itemExtent = 44;

  /// 고를 수 있는 가장 낮은 금액. 눈금을 다시 잡아도 이 아래로는 내려가지 않는다
  late final int _minAllowed;

  /// 휠의 첫 항목. 직접 친 금액이 1,000원 눈금에서 벗어나면 그 금액에 맞춰 다시 잡는다
  late int _floor;

  late int _itemCount;

  late final FixedExtentScrollController _wheelController;

  /// 휠로 고르는 중인가, 금액을 직접 치는 중인가.
  /// 휠은 1,000원 눈금만 짚을 수 있어서, 그 사이 금액은 직접 쳐야 한다
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  /// 요금
  final ValueNotifier<int> _price = ValueNotifier<int>(0);

  ValueNotifier<int> get priceNotifier => _price;

  int get price => _price.value;

  set price(int value) {
    _price.value = value;
    _checkErrorMessage();
    _checkIsValid();
  }

  /// 에러 메세지
  final ValueNotifier<String> _errorMessage = ValueNotifier<String>(StringCallPrice.inputGuide1);

  ValueNotifier<String> get errorMessageNotifier => _errorMessage;

  String get errorMessage => _errorMessage.value;

  _setErrorMessage({required String value}) {
    _errorMessage.value = value;
  }

  _checkErrorMessage() {
    String errorMessage;
    if (price == 0) {
      errorMessage = StringCallPrice.inputGuide1;
    } else if (price < widget.minPrice) {
      errorMessage = "${getPrice(widget.minPrice)} ${StringCallPrice.inputGuide2}";
    } else {
      errorMessage = " ";
    }
    _setErrorMessage(value: errorMessage);
  }

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    bool valid;
    if (price > 0 && price >= widget.minPrice) {
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
    /// 휠은 늘 무언가를 가리킨다. 그래서 가장 낮은 항목이 곧 최소 허용 요금이어야 한다.
    /// 운행 중 요금 올리기는 minPrice 가 "현재 요금 + 1,000" 이라, 휠을 열자마자
    /// 올릴 수 있는 가장 낮은 금액이 잡힌다 — 전처럼 + 를 한 번 눌러야 하지 않는다
    _minAllowed = max(_step, _ceilToStep(widget.minPrice));

    final initPrice = max(_minAllowed, widget.initPrice ?? 0);
    _wheelController = FixedExtentScrollController(initialItem: _rebase(initPrice));
    price = initPrice;

    /// 키보드가 내려가면 그대로 휠로 돌아온다. 완료를 누르든, 바깥을 누르든,
    /// 뒤로가기로 키보드를 닫든 빠져나오는 길이 하나로 모인다
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _stopTyping();
    });
  }

  /// [value] 가 휠의 항목이 되도록 눈금을 다시 잡고, 그 항목의 위치를 돌려준다.
  ///
  /// 직접 친 금액은 1,000원 배수가 아닐 수 있다. 가까운 눈금으로 끌어다 붙이면
  /// 23,500 을 치고 빠져나왔을 뿐인데 24,000 이 되어 있다. 대신 눈금 자체를
  /// 그 금액에 맞춰 옮긴다 — 친 금액은 그대로 두고 휠이 따라간다
  int _rebase(int value) {
    final below = (value - _minAllowed) ~/ _step;
    _floor = value - below * _step;
    _itemCount = below + 1 + _spread ~/ _step;
    return below;
  }

  /// _step 의 배수로 올린다. 휠 항목이 어중간한 금액에서 시작하지 않게 한다
  int _ceilToStep(int value) => ((value + _step - 1) ~/ _step) * _step;

  int _priceAt(int index) => _floor + index * _step;

  /// 버튼으로 눌러도 휠이 따라 움직여야 한다. 값만 바꾸면 둘이 어긋난다
  void _moveBy(int stepCount) {
    /// 직접 입력 중에는 휠이 아니라 친 금액을 기준으로 움직인다.
    /// 23,500 에서 + 를 눌렀는데 24,000 이 아니라 엉뚱한 눈금으로 뛰면 안 된다
    if (_isTyping.value) {
      final next = max(_minAllowed, price + stepCount * _step);
      price = next;
      _textController.text = "$next";
      _textController.selection =
          TextSelection.collapsed(offset: _textController.text.length);
      return;
    }

    final next =
        (_wheelController.selectedItem + stepCount).clamp(0, _itemCount - 1);
    if (next == _wheelController.selectedItem) return;

    _wheelController.animateToItem(
      next,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  void _startTyping() {
    _textController.text = price > 0 ? "$price" : "";

    /// 전체 선택해 둔다. 바로 새 금액을 칠 수 있어야지, 지우는 일부터 시킬 이유가 없다
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );
    _isTyping.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _stopTyping() {
    if (!_isTyping.value) return;

    /// 최소 금액을 못 채우거나 비워둔 채 빠져나오면 최소 금액으로 되돌린다.
    /// 휠에는 "고르지 않음" 이라는 칸이 없다
    final settled = max(_minAllowed, price);
    final index = _rebase(settled);
    price = settled;

    _isTyping.value = false;
    _focusNode.unfocus();

    /// 눈금이 다시 잡혔으니 휠이 새 자리로 옮겨 앉아야 한다.
    /// 이번 프레임에는 아직 옛 항목 수로 그려져 있어 다음 프레임에 옮긴다
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_wheelController.hasClients) return;
      _wheelController.jumpToItem(index);
    });
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _isTyping.dispose();
    super.dispose();
  }

  Widget _stepButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          disabledBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ),
    );
  }

  /// 휠과 입력칸을 함께 띄워 둔다. IndexedStack 이라 안 보이는 쪽도 살아 있는데,
  /// 휠을 트리에서 빼면 스크롤 위치를 잃어 입력칸을 닫을 때 처음 금액으로 돌아간다
  Widget _priceInput() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isTyping,
      builder: (context, typing, child) {
        return IndexedStack(
          index: typing ? 1 : 0,
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: _startTyping,
              child: _priceWheel(),
            ),
            _priceField(),
          ],
        );
      },
    );
  }

  Widget _priceField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomTextField(
        controller: _textController,
        focusNode: _focusNode,
        hint: StringCallPrice.inputHint,
        inputType: TextInputType.number,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        suffixText: StringCommon.won,

        /// 일곱 자리면 999만 원이다. 대리운전 요금이 여기를 넘을 일은 없다
        maxLength: 7,
        onChanged: (value) {
          price = value.isEmpty ? 0 : int.parse(value);
        },
        onSubmitted: (_) => _stopTyping(),
      ),
    );
  }

  /// 가운데 칸이 고른 값이다. 위아래로 이웃 금액이 보여야 굴릴 수 있다는 것이 읽힌다
  Widget _priceWheel() {
    final theme = Theme.of(context);

    return SizedBox(
      height: _itemExtent * 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 가운데 칸을 띠로 표시해 어느 값이 선택된 것인지 분명히 한다
          Container(
            height: _itemExtent,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: priceNotifier,
            builder: (context, selected, child) {
              return ListWheelScrollView.useDelegate(
                controller: _wheelController,
                itemExtent: _itemExtent,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1.6,
                overAndUnderCenterOpacity: 0.35,
                onSelectedItemChanged: (index) {
                  price = _priceAt(index);

                  /// 눈금이 넘어갈 때 손끝에 걸리는 느낌이 있어야 단위로 움직인다는 것이 전해진다
                  HapticFeedback.selectionClick();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _itemCount,
                  builder: (context, index) {
                    final value = _priceAt(index);
                    final isSelected = value == selected;

                    return Center(
                      child: Text(
                        getPrice(value),
                        style: isSelected
                            ? theme.textTheme.bodyLarge
                            : theme.textTheme.bodyMedium?.copyWith(
                                color: theme.disabledColor,
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// 입력칸 바깥을 누르면 키보드가 내려간다. 내려가면 포커스가 풀리고,
      /// 포커스가 풀리면 휠로 돌아온다 — 빠져나오는 길을 따로 만들지 않는다
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScrollConfiguration(
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
                      widget.initPrice == null ? StringCallPrice.title : StringCallPrice.titleChange,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                  ],
                ),
              ),

              /// 요금
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(width: 80, child: Text(StringCallPrice.amount)),

                        /// - 버튼
                        _stepButton(label: "-", onPressed: () => _moveBy(-1)),
                        const SizedBox(width: 8),

                        /// 요금 (휠을 굴려 1,000원 단위로 고르거나, 눌러서 직접 친다)
                        Expanded(child: _priceInput()),
                        const SizedBox(width: 8),

                        /// + 버튼
                        _stepButton(label: "+", onPressed: () => _moveBy(1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(width: 80),

                        /// 입력값 에러 표시
                        ValueListenableBuilder(
                          valueListenable: errorMessageNotifier,
                          builder: (context, value, child) {
                            return Text(
                              value,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //   child: Row(
              //     children: [
              //       const SizedBox(width: 10),
              //       const Text(StringCallPrice.amount),
              //       const SizedBox(width: 24),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             /// 요금 입력
              //             CustomTextField(
              //               text: "$price",
              //               inputType: TextInputType.number,
              //               suffixText: StringCommon.won,
              //               textAlign: TextAlign.right,
              //               onChanged: (value) {
              //                 price = value.isEmpty ? 0 : int.parse(value);
              //               },
              //             ),
              //             const SizedBox(height: 8),
              //
              //             /// 입력값 에러 표시
              //             ValueListenableBuilder(
              //               valueListenable: errorMessageNotifier,
              //               builder: (context, value, child) {
              //                 return Text(
              //                   value,
              //                   style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
              //                 );
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              /// 신청 버튼
              ValueListenableBuilder<bool>(
                valueListenable: isValidNotifier,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      isEnabled: value,
                      text: StringCallPrice.bottomButton,
                      onPressed: () {
                        context.pop(price);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
