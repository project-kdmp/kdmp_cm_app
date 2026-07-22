import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_request.dart';
import 'package:kdmp_cm_app/data/model/lost_child/lost_child_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/lost_child/get_lost_child_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';

class LostChildViewModel {
  LostChildViewModel({
    required this.getLostChildListUseCase,
    required this.setupUseCase,
  });

  final GetLostChildListUseCase getLostChildListUseCase;
  final SetupUseCase setupUseCase;

  /// 안내 노출 주기(시간)
  int lostChildHour = 24;

  /// 상태
  StateAPI state = Loading();

  /// 노출 주기(24시간 등) 제한 적용 여부
  /// - true: 마지막 노출 후 lostChildHour(서버 응답값)가 지나야 다시 노출
  /// - false: 홈 화면에 진입할 때마다 매번 노출
  static const bool useShowIntervalLimit = true;

  /// 마지막 노출 이후 노출 주기(시간)가 지났는지 확인
  Future<bool> needToShow() async {
    if (!useShowIntervalLimit) {
      return true;
    }

    final lastShownDt = await setupUseCase.getLostChildLastShownDt();
    if (lastShownDt.isEmpty) {
      return true;
    }

    final lastHour = await setupUseCase.getLostChildHour();
    final elapsed = DateTime.now().difference(DateTime.parse(lastShownDt));
    return elapsed.inHours >= lastHour;
  }

  /// 실종아동 찾기 리스트 조회 API
  Future<List<LostChild>> getLostChildList({required String sido, required String sigungu}) async {
    state = Loading();

    final request = LostChildListRequest(mbrAddressSido: sido, mbrAddressSigungu: sigungu);
    final result = await getLostChildListUseCase.execute(lostChildListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.lostChildListResponse;

      /// 서버 lostChildHour는 실제로 '분' 단위로 내려옴 (예: 1440 = 24시간)
      final hour = response.lostChildHour > 0 ? (response.lostChildHour / 60).round() : 0;
      lostChildHour = hour > 0 ? hour : 24;

      /// 마지막 노출시각 및 노출 주기 갱신
      await setupUseCase.setLostChildLastShownDt(lostChildLastShownDt: DateTime.now().toIso8601String());
      await setupUseCase.setLostChildHour(lostChildHour: lostChildHour);

      return response.resultList;
    }

    return List.empty();
  }
}
