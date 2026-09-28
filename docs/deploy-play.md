# Play 스토어 자동 업로드

릴리스 빌드부터 **내부 테스트 트랙** 업로드까지 한 번에 돈다.
**프로덕션 승격은 자동화하지 않았다** — Play Console 에서 사람이 누른다.

## 왜 internal 까지만인가

두 가지 이유다.

**환경이 빌드 플레이버로 갈려 있지 않다.** `main.dart` 의
`kDebugMode ? Environment.STAGE : Environment.PROD` 한 줄이라, 릴리스 빌드는 무조건
운영 서버를 바라본다. 프로덕션까지 자동으로 나가면 사람의 확인 없이 실사용자에게
닿는 경로가 생긴다.

**지금 실기기 확인이 debug/STAGE 로만 이뤄진다.** 내부 테스트 트랙에 올리면 PROD 를
바라보는 릴리스 빌드를 실제로 눌러볼 수 있다. 비어 있던 검증 단계가 여기서 채워진다.

## 한 번만 하는 준비

### 1. 서비스 계정 만들기

[Google Cloud Console](https://console.cloud.google.com/) 에서:

1. 프로젝트를 고르거나 새로 만든다
2. **API 및 서비스 → 라이브러리** → `Google Play Android Developer API` **사용 설정**
3. **IAM 및 관리자 → 서비스 계정 → 서비스 계정 만들기**
   - 이름: 예 `play-publisher`
   - 역할은 여기서 주지 않는다 (권한은 Play Console 쪽에서 준다)
4. 만든 계정 → **키 → 키 추가 → 새 키 만들기 → JSON** → 내려받는다

### 2. Play Console 에서 그 계정에 권한 주기

**서비스 계정을 「사용자」로 초대한다.** 예전에는 **설정 → API 액세스** 에서 했는데
지금은 이 방식이다. API 액세스 항목이 안 보여도 정상이다.

먼저 내려받은 JSON 키에서 이메일을 꺼낸다.

```bash
python3 -c "import json;print(json.load(open('<내려받은>.json'))['client_email'])"
# play-publisher@<프로젝트>.iam.gserviceaccount.com
```

[Play Console](https://play.google.com/console/) 에서:

1. 왼쪽 위에서 **「모든 앱」**(개발자 계정 화면)으로 나온다 — 앱 안에서는 이 메뉴가
   보이지 않는다
2. **사용자 및 권한 → 새 사용자 초대**
3. 위에서 꺼낸 서비스 계정 이메일을 붙여넣는다
4. 권한은 **앱 단위로만** 준다
   - 앱: `kr.or.kddsa.kdmp_cm_app`
   - 「출시 관리자」 또는 「비공개 앱 출시 만들기·수정」 정도면 된다
   - **「프로덕션 출시」 권한은 주지 않아도 된다** — 이 자동화는 internal 만 쓴다

> 전파에 시간이 걸릴 수 있다. 바로 안 되면 조금 기다렸다 다시 시도한다.

> 「사용자 및 권한」이나 「API 액세스」가 아예 안 보이면 계정 단위 권한이 없는
> 것이다. 계정 소유자에게 요청한다.

### 3. 키를 놓는다

```bash
# 저장소에 담기지 않는다 (.gitignore)
cp ~/Downloads/<내려받은>.json android/play-service-account.json
```

환경변수로 다른 경로를 줘도 된다.

```bash
export PLAY_SERVICE_ACCOUNT_JSON=/절대/경로/key.json
```

## 로컬에서 올리기

```bash
tool/release_play.sh --dry-run   # 검사와 빌드까지만
tool/release_play.sh             # 업로드까지
```

스크립트가 순서대로 한다.

| 단계 | 하는 일 | 막히면 |
|---|---|---|
| 사전 점검 | 작업트리가 깨끗한지, 로컬 전용 파일 3종이 있는지 | 멈춘다 |
| 출시노트 | `docs/release-notes/<버전>.md` 의 **첫 코드블록**을 뽑아 500자 검사 | 없거나 넘치면 멈춘다 |
| 빌드 | `pub get` → `dart analyze lib` → `build appbundle --release` | 분석 에러면 멈춘다 |
| 서명 확인 | aab 안에 서명 블록이 있는지 | 없으면 멈춘다 |
| 업로드 | `./gradlew publishBundle` → internal 트랙 | |

작업트리가 더러우면 올리지 않는다. 산출물이 어느 커밋인지 말할 수 없는 빌드를
스토어에 두지 않기 위해서다.

## GitHub Actions 에서 올리기

`.github/workflows/release-play.yml`.

**자동으로 돌지 않는다.** `v*` 태그를 밀거나 Actions 탭에서 직접 실행할 때만 돈다.
스토어로 나가는 일은 사람이 시작점을 찍어야 한다.

```bash
git tag v2.1.3 && git push origin v2.1.3
```

### 필요한 Secrets

이 저장소는 빌드에 필요한 파일 세 종을 담지 않는다(`.gitignore`). 러너에는 없으므로
Secrets 에서 되살린다. Firebase 설정 파일(`google-services.json`)은 이 저장소에 아예
없다 — `lib/firebase_options.dart` 로만 설정하고 Gradle 플러그인을 쓰지 않는다. **저장소 → Settings → Secrets and variables → Actions**:

| 이름 | 내용 | 만드는 법 |
|---|---|---|
| `ENV_FILE` | 루트 `.env` 전문 | `cat .env` |
| `KEY_PROPERTIES` | 서명 설정 전문 | `cat android/key.properties` |
| `KEYSTORE_BASE64` | 키스토어를 base64 로 | `base64 -i android/kdmp_cm_app-upload-key.jks \| pbcopy` |
| `PLAY_SERVICE_ACCOUNT_JSON` | 서비스 계정 키 전문 | `cat android/play-service-account.json` |

> `KEYSTORE_BASE64` 만 base64 다 — 나머지는 텍스트라 그대로 붙여넣는다.
> 키스토어와 서비스 계정 키가 유출되면 **이 앱 이름으로 스토어에 무엇이든 올릴 수
> 있다.** Secrets 말고 다른 곳에 두지 않는다.

## 빌드번호

Play 는 **`versionCode` 를 재사용할 수 없다.** 이미 올라간 번호로 업로드하면 거부된다.

`2.1.2(203)` 은 콘솔에서 수동으로 올렸으므로, **자동화의 첫 실행은 204 부터**여야 한다.

```
🔖 release: version 2.1.2(203) -> 2.1.3(204)
```

버전을 올리는 커밋은 따로 남긴다 (`/kdmp-flutter:build-release` 규약).

## 프로덕션으로 올릴 때

internal 에서 확인한 뒤 Play Console 에서:

**프로덕션 → 새 버전 만들기 → 라이브러리에서 추가** → 내부 테스트에 올라간 번들을
고른다. 같은 번들이 그대로 올라가므로 다시 빌드하지 않는다.

## 걸리는 곳

**`The caller does not have permission`** — 서비스 계정에 Play Console 권한이 없거나
아직 전파되지 않았다. 「사용자 및 권한」에 그 이메일이 있는지, 이 앱에 권한이
붙어 있는지 확인하고 조금 기다렸다 다시 시도한다.

**`APK specifies a version code that has already been used`** — `versionCode` 를 올린다.

**`Package not found`** — 서비스 계정이 이 앱에 접근할 수 없다. Play Console 의 앱
액세스 권한을 확인한다.

**퍼블리시 태스크가 안 보인다** — 서비스 계정 키가 없으면 플러그인이 스스로 꺼진다
(`android/app/build.gradle` 의 `play { enabled.set(...) }`). 키 경로를 확인한다.
