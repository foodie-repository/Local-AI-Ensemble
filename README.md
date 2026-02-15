# Local AI Ensemble Validation (LXV)

이 문서는 로컬 환경에서 **Claude, Codex, Gemini** 3대 AI 모델을 사용하여 코드를 교차 검증하고, **최적의 앙상블(Ensemble)** 결과를 도출하는 자동화 시스템 가이드입니다.

## 1. 이 시스템이 강력한 이유 (핵심 철학)

많은 사람들이 AI를 사용할 때 채팅창(Chat)을 엽니다. 하지만 채팅은 **"휘발"**됩니다.
이 시스템은 대화가 아니라 **"문서(Document)"**를 남기는 방식입니다.

### 💡 "3중 백업 시스템"
1.  **현재 (`plan_request.md`)**: 내가 원하는 최신 요구사항이 담긴 파일
2.  **과거 (`sw/reports/`)**: AI가 답변했던 모든 기록이 시간대별로 자동 저장됨
3.  **결론 (`final_decision.md`)**: 여러 의견을 종합하여 확정된 최종 기획서

이 3가지가 자동으로 관리되므로, **"아까 걔가 뭐라고 했더라?"** 하며 채팅 기록을 뒤질 필요가 없습니다.

---

## 2. 실전 가이드: 뉴스 수집기 만들기

이 워크플로우를 따라해보세요. AI와 함께 기획서를 완성해가는 과정입니다.

### Step 1: 질문은 '파일'로 만드세요 (`Spec/Plan` 단계)

채팅창 대신, 프로젝트 루트에 `plan_request.md` 파일을 만들고 질문을 적습니다.

**예시 (`plan_request.md`)**:
```markdown
# 프로젝트 요구사항: AI 뉴스 수집기
- 사용 기술: Python, FastAPI, React
- 기능: RSS 피드 수집, 요약, 태깅

## 질문
이 요구사항을 바탕으로 상세 구현 계획(DB 스키마, API 명세)을 짜줘.
```
> **장점**: 파일로 저장해두면 Git으로 버전 관리가 가능합니다. 질문을 계속 다듬을 수 있죠.

### Step 2: 3대장 소환 (`Cmd + Option + Shift + V`)

`plan.md` 파일을 열어둔 상태에서 단축키를 누르세요.
눈에 보이지 않지만, 백그라운드에서 **엄청난 일**이 일어납니다.

1.  **폴더 생성**: `.ai-check/reports/20260216_140000/` (현재 시간)
2.  **프롬프트 저장**: `prompt.txt` (질문 내용 박제)
3.  **병렬 실행**: Claude, Codex, Gemini가 동시에 달려들어 고민을 시작합니다.
4.  **리포트 생성**: `report.md` 파일이 만들어지고 에디터에서 자동으로 열립니다.

### Step 3: 결과 확인 (`report.md`)

자동으로 열린 `report.md` 파일을 보면 3명의 전문가가 의견을 내놓았습니다.

```markdown
# AI Code Review Report
**Date:** ...
**Prompt Hash:** `a1b2c3d4` (이 결과가 어떤 질문에서 나왔는지 증명하는 지문)

## Claude Response
"아키텍처는 마이크로서비스가 좋겠습니다..."

## Codex Response
"구현 순서는 1. DB설계, 2. API구현..."

## Gemini Response
"데이터 모델은 이렇게 잡으세요..."
```
> **Tip**: 여기서 마음에 드는 부분만 골라내세요(Cherry-pick). 복붙할 필요 없습니다. 다음 단계가 있으니까요.

### Step 4: 앙상블 종합 (`Cmd + Option + E`)

3명의 의견이 너무 많아서 정리하기 힘들죠? **앙상블 리드(Ensemble Lead)**인 Gemini를 부를 차례입니다.
`report.md` 파일이 열린 상태에서 단축키 `Cmd + Option + E`를 누르세요.

- **결과**: `final_decision.md` 파일이 생성되고 열립니다.
- **내용**: 
    > "Claude의 아키텍처와 Gemini의 데이터 모델을 앙상블하여 최종안을 정리했습니다."

이제 복잡한 고민 끝! 최종 결정된 문서가 손안에 들어왔습니다.

### Step 5: 무한 반복 (Evolution)

끝이 아닙니다. `final_decision.md`의 내용을 복사해서, 처음에 만든 `plan_request.md`에 붙여넣으세요. 그리고 **새로운 질문**을 추가합니다.

**업데이트된 `plan_request.md`**:
```markdown
# 프로젝트 요구사항: AI 뉴스 수집기 (v2)
... (확정된 기획 내용) ...

## 추가 질문 (New)
확정된 내용을 바탕으로 main.py 코드를 작성해줘.
```
다시 **Step 2**로 돌아가서 실행합니다.
이 과정을 반복하면 `plan_request.md`는 단순한 질문지가 아니라 **완벽한 프로젝트 설계도(Spec)**로 진화하게 됩니다.

---

## 3. 설치 및 설정 (Setup)

### 사전 요구사항
- `claude`, `codex`, `gemini` CLI 도구가 설치되어 있어야 합니다.
- `xv-local`, `xv-ensemble` 스크립트가 PATH에 있어야 합니다.

### 설정 방법 (한 번만 하면 됨)
```bash
# 스크립트 설치
mkdir -p ~/.local/bin
cp scripts/xv-local ~/.local/bin/xv-local
cp scripts/xv-ensemble ~/.local/bin/xv-ensemble
chmod +x ~/.local/bin/xv-local ~/.local/bin/xv-ensemble
```

### VS Code 설정
1. **Tasks (`tasks.json`)**: 스크립트를 실행할 Task 등록
2. **Keybindings (`keybindings.json`)**: 단축키 매핑

**단축키 목록**:
- `Cmd + Opt + V`: Staged 변경사항 검증 (Commit 전 확인용)
- `Cmd + Opt + Shift + V`: 현재 파일 검증/질문 (기획/설계용)
- `Cmd + Opt + E`: 리포트 앙상블 (결론 도출용)

---

## 4. 고급 활용 팁

### 프롬프트 커스터마이징
리뷰나 기획의 기준을 바꾸고 싶다면?
- `.ai-check/prompts/default_review.md` 파일을 수정하세요.
- 예: "한국어로 대답해줘", "보안을 최우선으로 봐줘" 등

### Validator 연결
코드 품질을 더 높이고 싶다면 Linter나 Test를 자동 실행할 수 있습니다.
(`.env` 파일 설정)
```bash
export LINT_CMD="flake8 ."
export TEST_CMD="pytest"
```
