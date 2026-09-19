import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_detail_response.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/call_detail_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'call_detail_viewmodel_test.mocks.dart';

/// 이용내역 상세의 일시 분기.
///
/// 9/19 에 넣은 9/20 예약이 고객에게 9/19 로 보이던 버그를 고친 자리다(9b7b2e8).
/// 일시가 가리키는 값이 상태마다 달라, 값과 라벨이 함께 움직이는지를 못 박는다.
@GenerateMocks([
  GetMbrSqUseCase,
  GetCallDetailUseCase,
  SetCallCancelUseCase,
  SetConfirmCallCancelUseCase,
  SetFCMPushUseCase,
])
void main() {
  late MockGetMbrSqUseCase mockGetMbrSq;
  late MockGetCallDetailUseCase mockGetCallDetail;
  late CallDetailViewModel viewModel;

  /// 일시 세 필드만 바꿔가며 쓴다. 나머지는 이 테스트와 무관해 고정값으로 채운다
  CallDetailResponse responseWith({
    String? reqRegDt,
    String? drvReserveDt,
    String? drvStartDt,
    String? drvEndDt,
  }) {
    return CallDetailResponse(
      serverVersion: "V1",
      serverId: "BIZTOTAL",
      drvReqSq: 2085,
      reqRegDt: reqRegDt,
      drvReserveDt: drvReserveDt,
      drvStartDt: drvStartDt,
      drvEndDt: drvEndDt,
      reqStartAddress: "경기도 성남시 분당구 판교역로 72",
      reqStartPlaceNm: "",
      reqEndAddress: "경기도 성남시 분당구 판교백현로 104",
      reqEndPlaceNm: "남서울제1골프연습장",
      stopOverLst: const [],
    );
  }

  /// 날짜 포맷이 ko_KR 을 쓴다(string_util). 앱에서는 MaterialApp 의 현지화
  /// 델리게이트가 초기화해 주지만 단위 테스트에는 그것이 없어 직접 넣는다
  setUpAll(() async => initializeDateFormatting('ko_KR'));

  setUp(() {
    mockGetMbrSq = MockGetMbrSqUseCase();
    mockGetCallDetail = MockGetCallDetailUseCase();

    when(mockGetMbrSq.execute()).thenAnswer((_) async => 24286);

    viewModel = CallDetailViewModel(
      getMbrSqUseCase: mockGetMbrSq,
      getCallDetailUseCase: mockGetCallDetail,
      setCallCancelUseCase: MockSetCallCancelUseCase(),
      setConfirmCallCancelUseCase: MockSetConfirmCallCancelUseCase(),
      setFCMPushUseCase: MockSetFCMPushUseCase(),
    );
  });

  group('CallDetailViewModel', () {
    group('getCallDetail — 일시와 라벨', () {
      test('Given 운행이 시작된 콜, When 상세를 조회하면, Then 운행 일시를 보여준다', () async {
        // Arrange
        when(mockGetCallDetail.execute(callDetailRequest: anyNamed('callDetailRequest')))
            .thenAnswer((_) async => Success(responseWith(
                  reqRegDt: "2026-09-19T00:05:40",
                  drvReserveDt: "2026-09-20T11:00:00",
                  drvStartDt: "2026-09-20T11:04:10",
                  drvEndDt: "2026-09-20T11:41:00",
                )));

        // Act
        await viewModel.getCallDetail(2085);

        // Assert
        expect(viewModel.dateLabelNotifier.value, StringCalled.workDate);
        expect(viewModel.date, contains("11:04"));
      });

      test('Given 예약만 잡힌 콜, When 상세를 조회하면, Then 접수일이 아니라 예약 일시를 보여준다', () async {
        // Arrange — 9/19 에 넣은 9/20 예약. 고쳐지기 전에는 9/19 로 보였다
        when(mockGetCallDetail.execute(callDetailRequest: anyNamed('callDetailRequest')))
            .thenAnswer((_) async => Success(responseWith(
                  reqRegDt: "2026-09-19T00:05:40",
                  drvReserveDt: "2026-09-20T11:00:00",
                )));

        // Act
        await viewModel.getCallDetail(2085);

        // Assert
        expect(viewModel.dateLabelNotifier.value, StringCalled.reserveDate);
        expect(viewModel.date, contains("09월 20일"));
        expect(viewModel.date, isNot(contains("09월 19일")));
      });

      test('Given 예약도 운행도 없는 콜, When 상세를 조회하면, Then 접수 일시를 보여준다', () async {
        // Arrange — 서버가 drvReserveDt 를 아직 안 주는 경우도 여기로 떨어진다
        when(mockGetCallDetail.execute(callDetailRequest: anyNamed('callDetailRequest')))
            .thenAnswer((_) async => Success(responseWith(
                  reqRegDt: "2026-09-19T00:05:40",
                )));

        // Act
        await viewModel.getCallDetail(2085);

        // Assert
        expect(viewModel.dateLabelNotifier.value, StringCalled.requestDate);
        expect(viewModel.date, contains("09월 19일"));
      });

      test('Given 조회가 실패하면, When 상세를 조회하면, Then 일시를 건드리지 않는다', () async {
        // Arrange
        when(mockGetCallDetail.execute(callDetailRequest: anyNamed('callDetailRequest')))
            .thenAnswer((_) async => Fail(errorMessage: "네트워크 오류"));

        // Act
        final result = await viewModel.getCallDetail(2085);

        // Assert — 실패했는데 값이 채워지면 빈 화면을 채워진 것으로 읽는다
        expect(result, isA<Fail>());
        expect(viewModel.date, isEmpty);
        expect(viewModel.dateLabelNotifier.value, StringCalled.requestDate);
      });
    });
  });
}
