import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

/// GPS fix 가 실패·지연될 때 쓰는 기본 좌표 (서울시청).
const NLatLng kDefaultLatLng = NLatLng(37.5666103, 126.9783882);

/// 현위치를 가져온다.
///
/// 첫 좌표는 위성 lock 전 셀/네트워크 기반이라 수십~수백 m 거칠 때가 많다. 그래서
/// 짧게 스트림을 열어 **정확도 [desiredAccuracyMeters] m 이내** fix 를 기다렸다 쓰고,
/// [timeLimit] 안에 못 만족하면 그동안 받은 **가장 정확했던 좌표**를, 하나도 못 받으면
/// OS 가 캐시한 마지막 위치를, 그마저 없으면 null 을 돌려준다. 예외는 던지지 않는다 —
/// 호출부의 지도·출발지 초기화 흐름을 끊지 않기 위해서다.
Future<Position?> getCurrentPositionSafe({
  Duration timeLimit = const Duration(seconds: 8),
  double desiredAccuracyMeters = 30,
}) async {
  Position? best;
  StreamSubscription<Position>? sub;
  final completer = Completer<Position?>();

  void finish(Position? result) {
    if (!completer.isCompleted) completer.complete(result);
  }

  Timer? timer;
  try {
    sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).listen(
      (p) {
        if (best == null || p.accuracy < best!.accuracy) best = p;
        /// 충분히 정확하면 더 기다리지 않는다
        if (p.accuracy <= desiredAccuracyMeters) finish(p);
      },
      onError: (e) {
        debugPrint("getCurrentPositionSafe 스트림 오류: $e");
        finish(best);
      },
    );

    /// 전체 상한. 임계값을 못 만족해도 가장 정확했던 값으로 마무리한다
    timer = Timer(timeLimit, () => finish(best));

    final result = await completer.future;
    if (result != null) return result;
  } catch (e, stack) {
    debugPrint("getCurrentPositionSafe 실패: $e\n$stack");
  } finally {
    timer?.cancel();
    await sub?.cancel();
  }

  /// 스트림에서 아무것도 못 받았으면 마지막 위치로 대체한다
  try {
    return await Geolocator.getLastKnownPosition();
  } catch (e2) {
    debugPrint("getLastKnownPosition 실패: $e2");
    return null;
  }
}

/// 현위치 좌표. 못 받으면 기본 좌표(서울시청)로 대신한다. 항상 non-null 이라
/// 지도·출발지 초기화처럼 좌표가 반드시 필요한 곳에서 쓴다.
Future<NLatLng> getCurrentLatLng({
  Duration timeLimit = const Duration(seconds: 8),
  double desiredAccuracyMeters = 30,
}) async {
  final position = await getCurrentPositionSafe(
    timeLimit: timeLimit,
    desiredAccuracyMeters: desiredAccuracyMeters,
  );
  return position != null
      ? NLatLng(position.latitude, position.longitude)
      : kDefaultLatLng;
}

/// "정확한 위치"(정밀)가 켜져 있는지. Android 12+·iOS 에서 사용자가 대략적 위치만
/// 허용하면 FINE 권한이 있어도 수백 m 오차가 난다. 판단이 안 되면 막지 않도록 true.
Future<bool> isLocationPrecise() async {
  try {
    return (await Geolocator.getLocationAccuracy()) ==
        LocationAccuracyStatus.precise;
  } catch (_) {
    return true;
  }
}

bool _approximateWarned = false;

/// 대략적 위치만 켜져 있으면 세션당 한 번만 안내한다.
Future<void> warnIfApproximateLocationOnce() async {
  if (_approximateWarned) return;
  if (await isLocationPrecise()) return;
  _approximateWarned = true;
  Fluttertoast.showToast(
    msg: "'정확한 위치'가 꺼져 있어 현재 위치가 부정확할 수 있어요.\n설정 > 위치 권한에서 '정확한 위치'를 켜 주세요.",
    toastLength: Toast.LENGTH_LONG,
  );
}
