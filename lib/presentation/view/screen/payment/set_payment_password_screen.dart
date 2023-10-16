import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_payment_password_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/payment/set_payment_password_viewmodel.dart';

/// 결제 비밀번호 설정 화면
class SetPaymentPasswordScreen extends StatefulWidget {
  const SetPaymentPasswordScreen({Key? key}) : super(key: key);

  static const String routeName = "set_payment_password";

  @override
  State<SetPaymentPasswordScreen> createState() => _SetPaymentPasswordScreenState();
}

class _SetPaymentPasswordScreenState extends State<SetPaymentPasswordScreen> {
  late final SetPaymentPasswordViewModel _setPaymentPasswordViewModel;

  late List<int> keys;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _setPaymentPasswordViewModel = SetPaymentPasswordViewModel(
      setPaymentPasswordUseCase: GetIt.instance<SetPaymentPasswordUseCase>(),
    );
  }

  void initData() {
    keys = _getRandomKeyboardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringPaymentPassword.setTitle,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 결제 비밀번호 안내 텍스트
                  ValueListenableBuilder<String>(
                    valueListenable: _setPaymentPasswordViewModel.messageNotifier,
                    builder: (context, value, child) {
                      return Text(
                        value,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  /// 입력된 결제 비밀번호
                  ValueListenableBuilder<String>(
                    valueListenable: _setPaymentPasswordViewModel.inputPasswordNotifier,
                    builder: (context, value, child) {
                      return getInputPasswordList(value.length);
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  /// 첫 번째 줄
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[0].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[0]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[1].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[1]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[2].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[2]);
                          },
                        ),
                      ),
                    ],
                  ),

                  /// 두 번째 줄
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[3].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[3]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[4].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[4]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[5].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[5]);
                          },
                        ),
                      ),
                    ],
                  ),

                  /// 세 번째 줄
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[6].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[6]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[7].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[7]);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[8].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[8]);
                          },
                        ),
                      ),
                    ],
                  ),

                  /// 네 번째 줄
                  Row(
                    children: [
                      const Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              keys[9].toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          onTap: () {
                            _addPasswordChar(keys[9]);
                          },
                        ),
                      ),

                      /// 지우기 버튼
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                          onTap: () {
                            _setPaymentPasswordViewModel.removePasswordLastChar();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 결제 비밀번호 입력
  _addPasswordChar(int value) async {
    final result = await _setPaymentPasswordViewModel.addPasswordChar(value);
    if (result == true) {
      /// 화면 닫기, 비밀번호 설정 여부 전달
      context.pop(result);
    }
  }

  /// 결제 비밀번호 입력 리스트
  Widget getInputPasswordList(int inputLength) {
    return SizedBox(
      height: 20,
      child: ListView.separated(
        itemCount: 6,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Icon(
            Icons.circle,
            size: 20,
            color: index < inputLength ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }

  List<int> _getRandomKeyboardList() {
    List<int> numbers = List<int>.from({});

    // 0부터 9까지 10개의 수
    while (true) {
      // temp 변수에 임시로 저장
      int temp = Random().nextInt(10) + 0;
      if (!numbers.contains(temp)) {
        numbers.add(temp);
      }
      if (numbers.length == 10) {
        break;
      }
    }
    return numbers;
  }
}
