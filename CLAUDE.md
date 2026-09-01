# CLAUDE.md

<!--
  이 파일은 원장(kdmp-harness) 에서 관리한다. 이 저장소에서 직접 고치지 말 것.
  원장의 canonical/app-customer/CLAUDE.md 를 고치고 scripts/sync.sh 로 배포한다.
-->

`kdmp_cm_app` — KDMP **고객용(CM = customer)** Flutter 앱.
Android `kr.or.kddsa.kdmp_cm_app` / iOS `kr.or.kddsa.kdmpCmApp`. 현재 `2.1.0+201`.

고객이 본인인증 후 가입하고, 출발지·경유지·도착지를 지정해 대리운전 콜을 요청·취소하며,
요금 흐름과 결제수단(빌링키)을 관리한다. 이용내역·차량 관리·문의·공지·약관·실종아동 조회를 제공한다.
지도는 Naver Map 을 쓴다.

README 는 Flutter 기본 템플릿이라 정보가 없다. 이 파일이 기준 문서다.

## 공통 규약은 스킬에 있다

구조·DI·상태관리·`StateAPI`·네트워킹은 **기사용·법인 앱과 동일**하므로 여기 적지 않는다.

- 아키텍처: `/kdmp-flutter:architecture`
- 빌드·릴리스·커밋 규약: `/kdmp-flutter:build-release`
- 브랜치·저장소 간 작업: `/kdmp-common:git-workflow`, `/kdmp-common:multi-repo`

**빌드는 `fvm flutter ...` 로 한다.** 시스템 flutter 는 버전이 다르다.

## 이 앱 고유

- **API prefix `/v1/biztotal/cm/...`** (리포지토리 39곳). 인증은 `/v1/auth-svr/...`.
  법인 고객용 앱도 같은 `cm` prefix 를 쓴다.
- 백엔드는 `kdmp-msa-servers` 의 `kdmp-biz-total`(8088). 관리자 화면의 `/v1/biztotal/adm/...` 와 같은 모듈이다.
- 본인인증(모빌리언스)과 결제는 웹뷰(`webview_flutter`, `flutter_inappwebview`)로 처리한다.
  외부 앱 실행은 `MethodChannel('kdmp_cm')` 의 `getAppUrl`/`getMarketUrl` 로 네이티브에 위임한다
  (`register/phone_verify_screen.dart`).
- Android 인앱 업데이트(`in_app_update`)는 `splash_screen.dart` 에서만 쓴다.
- 기능 슬라이스: `auth`, `register`, `term`, `work`, `payment`, `mypage`, `notice`,
  `inquiry`, `policy`, `lost_child`, `juso`, `naver`, `fcm`, `secure_storage`

## 큰 파일 — 고치기 전에 흐름부터 읽을 것

- `presentation/view/screen/home/home_screen.dart` (약 1,630줄)
- `presentation/view/screen/work/work_screen.dart` (약 700줄)

콜 요청·진행 흐름의 중심이다. 손대기 전에 대응 ViewModel(`viewmodel/home`, `viewmodel/work`)의
`ValueNotifier` 흐름을 먼저 읽는다.

## 브랜치

GitHub 기본 브랜치는 `main` 이지만 **실제 작업은 `dev_ver2`** 에서 한다.
CI 워크플로가 없어 푸시로 배포되지 않는다. 스토어 제출은 수동이다.

## 형제 저장소

같은 백엔드(KDMP MSA)를 공유한다. 이 저장소에 선례가 없는 패턴은
기사용 앱(`kdmp_dm_app`)이나 법인 앱(`kdmp_cm_corporate_app`)의 같은 슬라이스를 참고한다.
약관·공지처럼 관리자 화면에서 등록하고 앱에서 노출하는 데이터는 `kdmp-admin-client` 와 짝을 이룬다.

경로는 머신마다 다르므로 여기 적지 않는다. `/kdmp-common:multi-repo` 참고.
