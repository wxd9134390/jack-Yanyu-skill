#!/usr/bin/env bash
# push.sh —— 把 huasheng13-yanyu-skill 推到你的 GitHub
#
# 用法（二选一）：
#   ./push.sh <你的GitHub用户名>
#   GITHUB_TOKEN=ghp_xxx ./push.sh <你的GitHub用户名>
#
# 前置：先在 https://github.com/new 建一个空仓库，名字 huasheng13-yanyu-skill，
#       不要勾选 "Add a README file" / .gitignore / license，保持完全空白。

set -euo pipefail

GITHUB_USER="${1:-}"
REPO_NAME="huasheng13-yanyu-skill"

if [[ -z "$GITHUB_USER" ]]; then
  echo "用法: ./push.sh <你的GitHub用户名>"
  exit 1
fi

cd "$(dirname "$0")"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "错误：当前目录不是 git 仓库"
  exit 1
fi

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  REMOTE="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
else
  REMOTE="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
fi

git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

echo "==> 推送 main 与 tag..."
git push -u origin main
git push origin v1.0.0 || echo "（tag 已存在或推送失败，可稍后 git push --tags）"

# 若用 token 推送，把 URL 里的 token 去掉，避免明文残留
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  git remote set-url origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
  echo "==> 已清除 remote URL 中的 token"
fi

echo ""
echo "完成：https://github.com/${GITHUB_USER}/${REPO_NAME}"
