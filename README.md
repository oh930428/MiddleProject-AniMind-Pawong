# 1. 팀 소개
| 오민석 | 권양하 | 이승태 |
|-----|-----|----|
| 팀장  | 부팀장 | 팀원 |


# 2. 프로젝트 개요
- 프로젝트 이름: animind(애니마인드)
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