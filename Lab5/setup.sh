#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "=== Lab 5 环境初始化（无需重新安装 Python）==="

########################################
# 0. 安装 Homebrew（若未安装）
########################################
if ! command -v brew >/dev/null 2>&1; then
  echo "[info] Homebrew 不存在，正在安装…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # 为当前 shell 设置 PATH
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

########################################
# 1. 安装系统包（跳过 Python 相关）
########################################
echo "[info] 通过 Homebrew 安装依赖…"
brew update
brew install git git-lfs wget curl cmake pkg-config \
             rust llvm coreutils openblas openssl@3
brew cleanup

########################################
# 2. Python 虚拟环境（使用现有 python3）
########################################
ENV_NAME="lab5-venv"
PY_BIN=$(command -v python3 || true)

if [[ -z "${PY_BIN}" ]]; then
  echo "[error] 未找到 python3，请确认 PATH 或自行安装 Python ≥ 3.9" >&2
  exit 1
fi

echo "[info] 使用 ${PY_BIN} 创建虚拟环境 ${ENV_NAME}"
"${PY_BIN}" -m venv "${ENV_NAME}"
# shellcheck disable=SC1090
source "${ENV_NAME}/bin/activate"

echo "[info] 升级 pip / setuptools / wheel …"
pip install -U pip setuptools wheel

# 如果有 requirements.txt，就安装依赖
if [[ -f "requirements.txt" ]]; then
  echo "[info] 安装 Python 依赖…"
  pip install -r requirements.txt
fi

########################################
# 3. 克隆作业仓库（示例）
########################################
if [[ ! -d "mit-efficient-ai-lab5" ]]; then
  echo "[info] 克隆实验仓库…"
  git clone https://github.com/mit-han-lab/your-lab5-repo.git mit-efficient-ai-lab5
fi

echo -e "\n=== 完成！===\n"
echo "• 当前虚拟环境：$(which python)"
echo "• 以后重新激活：source ${ENV_NAME}/bin/activate"
echo "🚀 祝实验顺利！"
