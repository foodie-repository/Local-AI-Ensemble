# CLAUDE.md - Local AI Ensemble Validation (LXV)

## 프로젝트 개요
로컬 환경에서 **Claude, Codex, Gemini** 3대 AI 모델을 병렬 실행하여 코드/기획을 교차 검증하고, 앙상블(Ensemble) 결과를 도출하는 자동화 도구입니다.

## 프로젝트 구조
```
local-ai-ensemble/
├── 01-system-prompts/          # 시스템 프롬프트 원본 (설치 시 배포용)
│   ├── default_review.md       #   코드 리뷰용 프롬프트
│   └── ensemble.md             #   앙상블 종합용 프롬프트
├── 02-scripts/                 # 실행 스크립트
│   ├── xv-local                #   3대 AI 병렬 실행 → report.md 생성
│   └── xv-ensemble             #   report.md → final_decision.md 앙상블
├── ai-ensemble/                # 런타임 생성 폴더 (Git 추적 O)
│   ├── custom-prompts/         #   사용자 커스터마이징용 프롬프트
│   │   └── review.md           #   (첫 실행 시 01-system-prompts/에서 자동 복사)
│   └── reports/                #   실행 결과 (타임스탬프별 폴더)
│       └── YYYYMMDD_HHMMSS/
│           ├── prompt.txt      #     AI에게 보낸 프롬프트
│           ├── claude.txt      #     Claude 응답 원본
│           ├── claude.err      #     Claude stderr 로그
│           ├── codex.txt       #     Codex 응답 원본
│           ├── codex.err       #     Codex stderr 로그
│           ├── gemini.txt      #     Gemini 응답 원본
│           ├── gemini.err      #     Gemini stderr 로그
│           ├── report.md       #     3개 응답 통합 리포트
│           └── final_decision.md #   앙상블 최종 결정 (xv-ensemble 실행 시)
├── install.sh                  # 자동 설치 스크립트
├── plan_request.md             # 질문/요구사항 입력 파일
├── .gitignore
├── CLAUDE.md                   # 이 파일 (Claude Code 가이드)
└── README.md                   # 사용자 가이드
```

## 핵심 워크플로우
1. `plan_request.md`에 질문 작성
2. `xv-local` 실행 → Claude, Codex, Gemini 병렬 호출 → `report.md` 생성
3. `xv-ensemble` 실행 → Gemini가 3개 의견 종합 → `final_decision.md` 생성
4. 결과를 `plan_request.md`에 반영 → 반복

## 스크립트 실행 방법
```bash
# 특정 파일 리뷰 (기획/설계용)
bash 02-scripts/xv-local "파일 plan_request.md 리뷰"

# Staged 변경사항 리뷰 (커밋 전 검증)
bash 02-scripts/xv-local

# 리포트 앙상블 (결론 도출)
bash 02-scripts/xv-ensemble ai-ensemble/reports/YYYYMMDD_HHMMSS/report.md
```

## 사전 요구사항
- `claude` CLI (Anthropic)
- `codex` CLI (OpenAI)
- `gemini` CLI (Google)
- `python3` (프롬프트 템플릿 처리용)

## 주요 규칙
- **언어**: 문서, 프롬프트, 주석 모두 **한국어**로 작성
- **프롬프트 우선순위**: `ai-ensemble/custom-prompts/` → 없으면 `01-system-prompts/`에서 자동 복사
- **ai-ensemble/ 폴더**: `.gitignore`에 포함하지 않음 (결과물도 버전 관리하는 것이 프로젝트 철학)
- **에디터**: Antigravity IDE 우선, VS Code, 기본 에디터 순으로 자동 감지
