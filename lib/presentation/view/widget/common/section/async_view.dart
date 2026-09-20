import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

/// 조회 상태를 화면에 그대로 드러내는 껍데기.
///
/// 지금까지 화면들은 목록이 비면 무조건 "내역이 없습니다" 를 띄웠다. 그래서 고객은
/// 세 가지를 구분할 수 없었다 — 불러오는 중인가, 기록이 없는가, 조회가 실패했는가.
/// 느린 망에서는 기록이 있는데도 없다고 읽혔고, 실패하면 아무 말도 하지 않았다.
///
/// 상태마다 화면을 따로 준다. 실패에는 다시 시도할 자리를 함께 준다 — 사용자가
/// 할 수 있는 일이 없으면 안내가 안내로 기능하지 않는다.
class AsyncView extends StatelessWidget {
  const AsyncView({
    Key? key,
    required this.state,
    required this.isEmpty,
    required this.onRetry,
    required this.builder,
    this.emptyMessage = StringCommon.emptyDefault,
    this.minHeight = 320,
  }) : super(key: key);

  /// 조회 상태. ValueNotifier 여야 한다 — 평범한 필드는 바뀌어도 화면이 다시 그려지지 않는다
  final ValueListenable<StateAPI> state;

  /// 성공했는데 보여줄 것이 없는지. 목록이 여럿인 화면이 있어 판단을 화면에 맡긴다
  final bool Function() isEmpty;

  final VoidCallback onRetry;

  /// 성공했고 보여줄 것이 있을 때 그릴 본문
  final WidgetBuilder builder;

  final String emptyMessage;

  /// 로딩·빈 상태·실패가 같은 높이를 차지하게 한다. 화면이 들썩이지 않는다
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StateAPI>(
      valueListenable: state,
      builder: (context, value, _) {
        /// 이미 보여줄 것이 있으면 로딩이어도 본문을 유지한다.
        /// 다음 쪽을 불러오는 중에 목록이 통째로 사라지면 안 된다
        if (value is Loading) {
          return isEmpty() ? _box(context, const _Spinner()) : builder(context);
        }

        /// 실패도 마찬가지다. 이미 읽은 것까지 버릴 이유가 없다
        if (value is! Success && !isEmpty()) return builder(context);
        if (value is! Success) return _box(context, _Failure(onRetry: onRetry));
        if (isEmpty()) return _box(context, _Empty(message: emptyMessage));

        return builder(context);
      },
    );
  }

  Widget _box(BuildContext context, Widget child) {
    return SizedBox(
      height: minHeight,
      width: double.infinity,
      child: Center(child: child),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(ImageCommon.imgWarning, width: 72, height: 72),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
        ),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({Key? key, required this.onRetry}) : super(key: key);

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringCommon.loadFail,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          child: Text(
            StringCommon.retry,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
