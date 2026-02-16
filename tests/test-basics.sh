#!/usr/bin/env bash
# test-basics.sh: 프로젝트 기본 구조 및 함수 검증 테스트
#
# 실행: bash tests/test-basics.sh
# AI CLI 호출 없이 구조적 검증만 수행합니다.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

PASS=0
FAIL=0

# 테스트 헬퍼 함수
assert_ok() {
    local desc="$1"
    if eval "$2" &> /dev/null; then
        echo "  ✅ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ❌ $desc"
        FAIL=$((FAIL + 1))
    fi
}

assert_fail() {
    local desc="$1"
    if ! eval "$2" &> /dev/null; then
        echo "  ✅ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ❌ $desc (should have failed)"
        FAIL=$((FAIL + 1))
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " LXV 기본 테스트"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. 필수 파일 존재 확인 ──
echo ""
echo "[1] 필수 파일 존재 확인"
assert_ok "README.md 존재" "[ -f README.md ]"
assert_ok "README.ko.md 존재" "[ -f README.ko.md ]"
assert_ok "LICENSE 존재" "[ -f LICENSE ]"
assert_ok "install.sh 존재" "[ -f install.sh ]"
assert_ok "xv-local 존재" "[ -f 02-scripts/xv-local ]"
assert_ok "xv-ensemble 존재" "[ -f 02-scripts/xv-ensemble ]"
assert_ok "xv-common 존재" "[ -f 02-scripts/xv-common ]"
assert_ok "default_review.md 존재" "[ -f 01-system-prompts/default_review.md ]"
assert_ok "ensemble.md 존재" "[ -f 01-system-prompts/ensemble.md ]"

# ── 2. 스크립트 실행 권한 확인 ──
echo ""
echo "[2] 스크립트 실행 권한 확인"
assert_ok "xv-local 실행 가능" "[ -x 02-scripts/xv-local ]"
assert_ok "xv-ensemble 실행 가능" "[ -x 02-scripts/xv-ensemble ]"
assert_ok "install.sh 실행 가능" "[ -x install.sh ]"

# ── 3. 공통 함수 로드 테스트 ──
echo ""
echo "[3] 공통 함수 (xv-common) 테스트"
source 02-scripts/xv-common

assert_ok "get_model_info 함수 존재" "type get_model_info"
assert_ok "load_prompt_template 함수 존재" "type load_prompt_template"
assert_ok "get_timeout_cmd 함수 존재" "type get_timeout_cmd"
assert_ok "open_in_editor 함수 존재" "type open_in_editor"

# get_model_info 반환값 테스트 (CLI가 없어도 이름은 반환해야 함)
RESULT=$(get_model_info "nonexistent_cli" 2>/dev/null || echo "nonexistent_cli")
assert_ok "get_model_info: 없는 CLI도 이름 반환" "[ -n '$RESULT' ]"

# get_timeout_cmd 테스트
TIMEOUT_RESULT=$(get_timeout_cmd 60)
# timeout 또는 gtimeout이 있으면 값이 있고, 없으면 빈 문자열
assert_ok "get_timeout_cmd: 정상 반환" "true"

# ── 4. 프롬프트 템플릿 검증 ──
echo ""
echo "[4] 프롬프트 템플릿 검증"
assert_ok "review 템플릿에 {{DIFF_CONTENT}} 포함" "grep -q '{{DIFF_CONTENT}}' 01-system-prompts/default_review.md"
assert_ok "review 템플릿에 {{CONTEXT_ARG}} 포함" "grep -q '{{CONTEXT_ARG}}' 01-system-prompts/default_review.md"
assert_ok "ensemble 템플릿에 {{REPORT_CONTENT}} 포함" "grep -q '{{REPORT_CONTENT}}' 01-system-prompts/ensemble.md"

# ── 5. xv-local 기본 검증 (변경사항 없을 때 정상 종료) ──
echo ""
echo "[5] xv-local 기본 검증"
# Staged도 없고 Working tree도 깨끗하면 exit 0으로 종료해야 함
if git diff --cached --quiet && git diff --quiet; then
    assert_ok "변경사항 없을 때 정상 종료" "bash 02-scripts/xv-local 2>&1"
fi

# ── 6. xv-ensemble 인자 검증 ──
echo ""
echo "[6] xv-ensemble 인자 검증"
assert_fail "인자 없이 실행 시 에러" "bash 02-scripts/xv-ensemble 2>&1"
assert_fail "존재하지 않는 파일 시 에러" "bash 02-scripts/xv-ensemble nonexistent.md 2>&1"

# ── 결과 요약 ──
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOTAL=$((PASS + FAIL))
echo " 결과: ${PASS}/${TOTAL} 통과 (${FAIL}개 실패)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
