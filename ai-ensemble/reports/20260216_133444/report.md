# AI 코드 리뷰 리포트
**날짜:** Mon Feb 16 13:36:07 KST 2026
**컨텍스트:** 파일 plan_request.md 리뷰
**프롬프트 해시:** `1eeadf1e2c9b5e88e19cfb72ad683a81b6984f3d30b5e5540a168867d70910d8`

## 상태


## Claude 응답
`★ Insight ─────────────────────────────────────`
1. **명확한 요구사항의 중요성**: 추상적인 질문("구현 계획 짜줘")보다 구체적인 질문(DB 선택 근거, 인덱싱 전략)이 AI 모델로부터 훨씬 실용적인 답변을 이끌어냅니다.
2. **앙상블 효과 극대화**: 같은 질문을 3대 AI에게 던질 때, 비교 가능한 형식(numbered list, 명확한 요청)으로 작성하면 최종 앙상블 단계에서 의견 통합이 수월합니다.
3. **MVP 사고방식**: 초기 요구사항에 "최대 20개 RSS", "30일치 보관" 같은 제약을 명시하면, AI가 과도하게 복잡한 설계를 제안하는 것을 방지할 수 있습니다.
`─────────────────────────────────────────────────`

## 📝 최종 리뷰 결과

### ✅ 강점
- 간결하고 핵심만 담은 요구사항
- 적절한 기술 스택 선택 (Python, FastAPI)

### ⚠️ 개선 필요 (Critical)
1. **요구사항 구체화**: 위에서 제안한 템플릿처럼 수집 주기, 데이터 보관 정책, 보안 요구사항 등을 명시해야 합니다.
2. **질문 세분화**: "상세 구현 계획"이라는 포괄적 질문을 4개의 구체적 질문(DB, API, 아키텍처, 보안)으로 나누는 것이 좋습니다.
3. **제약 조건 추가**: MVP 범위를 명확히 하기 위해 "최대 N개", "M일치 보관" 같은 제약을 포함하세요.

### 🎯 다음 단계

파일 수정 권한을 승인하시면:
1. `plan_request.md`를 위 개선안으로 업데이트
2. `xv-local` 스크립트 실행으로 3대 AI 병렬 검증 시작
3. `report.md` 생성 후 `xv-ensemble`로 최종 결정 도출

**또는** 수동으로 아래 명령어를 실행하셔도 됩니다:
```bash
bash 02-scripts/xv-local "파일 plan_request.md 리뷰"
```

현재 상태로도 앙상블 검증은 가능하지만, 요구사항을 구체화하면 훨씬 실용적인 설계안을 얻을 수 있습니다. 어떻게 진행하시겠습니까?

---

## Codex 응답
**요약**  
`plan_request.md`는 방향성은 명확하지만, 현재 정보만으로 DB 스키마/API 명세를 안정적으로 설계하기엔 요구사항이 너무 추상적입니다. 이 상태로 진행하면 구현 해석 차이, 보안 누락, 성능 병목이 발생할 가능성이 큽니다.

**개선항목**  
1. `[높음][정확성]` `plan_request.md:4`  
기능이 “수집/요약/태깅” 수준으로만 적혀 있어 동작 규칙(중복 처리, 업데이트 기준, 실패 재시도, 삭제 정책)이 없습니다.  
해결: 유스케이스별 입력/처리/출력과 상태 전이 규칙을 명시하세요.

2. `[높음][보안]` `plan_request.md:4`, `plan_request.md:7`  
외부 RSS 수집 시 보안 요구(SSRF 방지, 악성 콘텐츠 처리)가 없습니다.  
해결: URL 허용 정책, 요청 타임아웃/크기 제한, 안전한 파싱, 프론트 렌더링 전 sanitize 요구를 추가하세요.

3. `[높음][보안]` `plan_request.md:7`  
API 인증/인가 요구가 없습니다.  
해결: 인증 방식(JWT/API Key), 권한 모델, rate limit, 감사 로그 요구사항을 포함하세요.

4. `[중간][성능]` `plan_request.md:4`  
처리량 기준(피드 수, 폴링 주기, 기사량, 응답 SLA)이 없어 성능 설계가 불가능합니다.  
해결: 목표 수치를 먼저 정의하고, 수집과 요약/태깅을 비동기 큐로 분리하는 아키텍처 요구를 명시하세요.

5. `[중간][정확성/스타일]` `plan_request.md:7`  
“DB 스키마, API 명세” 요청은 있으나 계약 수준(필드/에러/버전/페이지네이션)이 없습니다.  
해결: 최소 엔터티(`sources`, `articles`, `summaries`, `tags`, `jobs`)와 API 규칙(`/v1`, 표준 에러 포맷, pagination, idempotency)을 선행 정의하세요.

6. `[중간][정확성]` `plan_request.md:4`  
요약/태깅 품질 기준이 없어 결과 검증이 어렵습니다.  
해결: 지원 언어, 요약 길이/형식, 태그 체계, 품질 지표(정확도 또는 휴먼 리뷰 기준), 실패 fallback을 명시하세요.

7. `[낮음][스타일]` `plan_request.md:1`, `plan_request.md:7`  
문서가 질문형으로 끝나 추적성과 실행력이 낮습니다.  
해결: `목표`, `기능 요구`, `비기능 요구`, `보안`, `수용 기준(AC)`, `범위 제외` 섹션으로 재구성하세요.

---

## Gemini 응답
### 리뷰 결과: `plan_request.md`

**요약**

해당 문서는 'AI 뉴스 수집기' 프로젝트의 고수준 요구사항과 목표를 명확하게 제시하고 있습니다. Python, FastAPI, React 기술 스택을 활용하여 RSS 피드 수집, 요약, 태깅 기능을 구현하는 것을 목표로 하며, 이를 바탕으로 상세 구현 계획 수립을 요청하고 있습니다.

**개선항목**

현재 문서는 프로젝트의 초기 기획 단계로, 실제 개발을 진행하기에는 세부 사항이 부족합니다. 요청하신 내용을 바탕으로 아래와 같이 DB 스키마와 API 명세를 구체화하여 제안합니다. 이 계획을 기반으로 백엔드와 프론트엔드 개발을 시작할 수 있습니다.

---

### **상세 구현 계획 제안**

#### **1. 데이터베이스 스키마 (SQLAlchemy + Pydantic 모델 기준)**

- **`articles` 테이블**: 수집된 뉴스 기사 정보를 저장합니다.
    - `id` (Integer, Primary Key): 기사 고유 ID
    - `title` (String): 기사 제목
    - `link` (String, Unique): 원본 기사 링크
    - `content` (Text): 기사 원문 (수집 시 저장)
    - `summary` (Text): AI가 생성한 요약본
    - `published_at` (DateTime): 원본 기사 발행일
    - `created_at` (DateTime): DB 저장 시간
    - `feed_id` (Integer, Foreign Key to `feeds.id`): 어떤 RSS 피드에서 왔는지 참조

- **`feeds` 테이블**: 수집할 RSS 피드 정보를 관리합니다.
    - `id` (Integer, Primary Key): 피드 고유 ID
    - `url` (String, Unique): RSS 피드 주소
    - `name` (String): 피드 이름 (예: "Google AI Blog")
    - `last_fetched_at` (DateTime): 마지막으로 피드를 수집한 시간

- **`tags` 테이블**: AI가 생성하거나 사용자가 추가한 태그를 저장합니다.
    - `id` (Integer, Primary Key): 태그 고유 ID
    - `name` (String, Unique): 태그 이름 (예: "LLM")

- **`article_tags` 테이블** (Association Table): 기사와 태그의 다대다(N:M) 관계를 정의합니다.
    - `article_id` (Integer, Foreign Key to `articles.id`)
    - `tag_id` (Integer, Foreign Key to `tags.id`)

#### **2. API 명세 (FastAPI 기준)**

**Pydantic Schemas:**

- `ArticleSchema`, `FeedSchema`, `TagSchema` 등 DB 모델에 대응하는 스키마를 정의하여 데이터 유효성 검사 및 응답 모델로 사용합니다.

**Endpoints:**

- `POST /feeds/`: 새로운 RSS 피드를 등록합니다.
    - **Request Body**: `{ "url": "string", "name": "string" }`
    - **Response**: 등록된 피드 정보

- `GET /feeds/`: 등록된 모든 RSS 피드 목록을 조회합니다.
    - **Response**: 피드 목록 배열

- `DELETE /feeds/{feed_id}`: 특정 RSS 피드를 삭제합니다.

- `GET /articles/`: 기사 목록을 페이지네이션과 함께 조회합니다.
    - **Query Parameters**: `?skip=0&limit=20&tag=LLM` (태그별 필터링)
    - **Response**: 기사 목록 배열 (요약, 태그 포함)

- `GET /articles/{article_id}`: 특정 기사의 상세 정보를 조회합니다.
    - **Response**: 기사 상세 정보 (원문 포함)

- `POST /tasks/fetch-feeds`: 모든 피드를 순회하며 새로운 기사를 수집하는 백그라운드 작업을 실행합니다. (관리자용 또는 스케줄링)
    - **Response**: 작업 실행 상태

#### **3. 핵심 로직 구현 방안**

- **RSS 피드 수집**: `feedparser` 라이브러리를 사용하여 주기적으로 각 RSS 피드에서 새로운 기사를 수집하고 `articles` 테이블에 저장합니다.
- **요약 및 태깅**: 새로 수집된 기사의 `content`(원문)를 프롬프트로 구성하여 대규모 언어 모델(LLM) API를 호출합니다. 응답으로 받은 요약과 태그를 각각 `summary` 필드와 `tags`/`article_tags` 테이블에 저장합니다. 이 과정은 시간이 걸릴 수 있으므로 FastAPI의 `BackgroundTasks`를 활용하는 것이 좋습니다.
- **스케줄링**: `apscheduler`와 같은 라이브러리를 FastAPI와 통합하여 특정 시간 간격(예: 1시간마다)으로 피드 수집 및 분석 작업을 자동 실행하도록 구성합니다.
