import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

/// GPS fix 가 실패·지연될 때 쓰는 기본 좌표 (서울시청).
const NLatLng kDefaultLatLng = NLatLng(37.5666103, 126.9783882);

/// 현위치 좌표를 가져온다.
///
/// 고정밀 GPS fix 는 콜드 스타트·실내에서 오래 걸리거나 실패한다. 제한 시간을 두고,
/// 실패하면 OS 가 캐시한 마지막 위치로, 그마저 없으면 기본 좌표(서울시청)로 대신한다.
/// 여기서 예외를 던지면 호출부의 지도·출발지 초기화가 끊기므로 절대 던지지 않는다.
Future<NLatLng> getCurrentLatLng({
  Duration timeLimit = const Duration(seconds: 5),
}) async {
  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: timeLimit,
    );
    debugPrint("getCurrentLatLng position: $position");
    return NLatLng(position.latitude, position.longitude);
  } catch (e, stack) {
    debugPrint("getCurrentLatLng 실패, 마지막 위치로 대체: $e\n$stack");
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        return NLatLng(last.latitude, last.longitude);
      }
    } catch (e2) {
      debugPrint("getLastKnownPosition 도 실패: $e2");
    }
    return kDefaultLatLng;
  }
}
