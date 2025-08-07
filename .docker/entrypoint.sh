#!/bin/bash
set -e

# Git設定（node:22-bookwormにはGitが含まれている）
# グローバルGit設定（安全なディレクトリを追加）
git config --global --add safe.directory /unity-editor-mcp

# ユーザー名とメールの設定（環境変数から）
if [ -n "$GITHUB_USERNAME" ]; then
    git config --global user.name "$GITHUB_USERNAME"
fi

if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Git認証ファイルを環境変数から作成
if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
    echo "https://${GITHUB_USERNAME}:${GITHUB_PERSONAL_ACCESS_TOKEN}@github.com" > /root/.git-credentials
    chmod 600 /root/.git-credentials
    git config --global credential.helper store
fi

# GitHub CLIの認証（GITHUB_TOKENが設定されている場合）
if [ -n "$GITHUB_TOKEN" ] && command -v gh &> /dev/null; then
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
fi

# プロジェクトディレクトリに移動
cd /unity-editor-mcp

echo "🚀 Claude Worktree Docker environment is ready!"
echo ""

# コマンドの実行（デフォルトはbash）
exec "$@"
