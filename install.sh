#!/usr/bin/env bash

# 설정
INSTALL_DIR="${HOME}/.local/bin"
PROMPT_DIR="${HOME}/.local/share/xv-ensemble/prompts"

echo "Local AI Ensemble Validation 설치를 시작합니다..."

# OS 확인
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "Error: Windows (Powershell/CMD)는 지원하지 않습니다."
    echo "   WSL (Windows Subsystem for Linux)을 사용해주세요."
    exit 1
fi

# 1. 디렉토리 생성
mkdir -p "$INSTALL_DIR"
mkdir -p "$PROMPT_DIR"

# 2. 스크립트 복사
echo "- 스크립트 복사 중: $INSTALL_DIR"
cp 02-scripts/xv-local "$INSTALL_DIR/"
cp 02-scripts/xv-ensemble "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/xv-local" "$INSTALL_DIR/xv-ensemble"

# 3. 프롬프트 복사
echo "- 프롬프트 복사 중: $PROMPT_DIR"
cp 01-system-prompts/* "$PROMPT_DIR/"

echo ""
echo "설치 완료!"
echo ""
echo "$INSTALL_DIR 경로가 PATH에 포함되어 있는지 확인하세요."
echo "Tip: 안 보이면 ~/.zshrc 또는 ~/.bashrc에 아래 줄을 추가하세요:"
echo "  export PATH=$HOME/.local/bin:\$PATH"
