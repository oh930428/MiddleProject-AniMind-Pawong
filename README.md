# 1. 팀 소개
| 오민석 | 권양하 | 이승태 |
|-----|-----|----|
| 팀장  | 부팀장 | 팀원 |


# 2. 프로젝트 개요
- 프로젝트 이름: ANIMIND(애니마인드)
- 프로젝트 설명: 반려동물을 더 잘 돌보고 싶은 보호자와 전문지식(훈련, 영양, 건강, 행동, 용품)을 가진 사람이 서로 연결되는 공간


# 3. 기술 스택
- Language: Dart 
- UI Framework: Flutter
- IDE: Android Studio
- Architecture: MVVM + Repository Pattern + Clean Architecture 기반
- State Management: Provider
- Networking: Dio (REST API), flutter_dotenv (환경 변수 관리)
- Backend: Supabase (Auth, Database, Storage)
- DI (Dependency Injection): Provider 기반 의존성 주입
- Local Storage: SharedPreferences
- Dev Tools: Supabase Dashboard, Postman
- Collaboration: Notion, Figma, GitHub
- API: Supabase REST API (자체 DB 테이블 연동)


# 4. 폴더 구조
- core
  - config
  - router
  - theme
  - utils
  - widgets
  - di
- assets
  - images
- fonts
- features
  - auth
    - data
      - datasources
      - repositories
    - domain
      - entities
      - repositories
      - usecases
      - ui
      - viewmodel
  - feed
    - data
        - datasources
        - repositories
    - domain
        - entities
        - repositories
        - usecases
        - ui
        - viewmodel
  - qna
    - data
        - datasources
        - repositories
    - domain
        - entities
        - repositories
        - usecases
        - ui
        - viewmodel
  - pet
    - data
        - datasources
        - repositories
    - domain
        - entities
        - repositories
        - usecases
        - ui
        - viewmodel


# 5. 깃 컨벤션
- ✨ feat - 새로운 기능 추가
- 🐞 fix - 버그 / 오류 수정
- 📝 docs - 문서 수정
- 🎨 style - 코드 스타일 변경 (로직 변화 X)
- ♻️ refactor - 코드 리팩토링 (기능 변화 없이 구조 개선)
- 🔥 remove - 불필요한 코드 / 파일 삭제
- 🚚 rename - 파일 / 폴더 이름 변경 또는 이동
- 🧪 test - 테스트 코드 추가 / 수정
- 📦chore - 빌드 업무, 패키지 설정, 환경 세팅 등
- 🚀 deploy - 배포 관련 작업
- 🛠 config - 환경 설정 관련 변경 (env, config)
- 🖌️design - UI/UX 디자인 변경 (색상, 레이아웃, CSS 등)
- 🚨hotfix - 긴급 오류 수정 (즉시 반영 필요)


# 6. 팀 규칙
- 🌿 브랜치 규칙
  - PR 전 필수: develop 브랜치에서 Pull 필수(평소에도 develop 업데이트 시 가끔씩 Pull 받아 최신 상태 유지)
  - PR 생성 시: 작업 완료 후 Push → PR은 develop 브랜치로 생성

- 🧾 커밋 메시지 규칙 
  - 📌 기본 구조
    - type: 제목 
    - 본문 (선택)
    - 이슈 번호 (선택)

- ✍️ 커밋 메시지 7가지 규칙
  1. 제목과 본문을 빈 행(한 줄 띄워)으로 구분한다.
  2. 제목은 영문 기준 50글자 이내로 제한한다.
  3. 제목의 첫 글자는 대문자로 작성한다.
  4. 제목 끝에는 마침표를 넣지 않는다.
  5. 제목은 명령문으로 사용하며 과거형을 사용하지 않는다.
  6. 본문의 각 행은 72글자 내로 제한한다.
  7. 어떻게 보다는 무엇과 왜를 설명한다.