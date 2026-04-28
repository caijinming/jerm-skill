#!/bin/sh
set -eu

printf 'repo: %s\n' "$(pwd)"

ensure_dir_dependencies() {
  dir="$1"
  marker="$dir/node_modules"
  manifest="$dir/package.json"

  if [ ! -f "$manifest" ]; then
    return 0
  fi

  if [ -d "$marker" ]; then
    printf 'deps: ok %s\n' "$dir"
    return 0
  fi

  printf 'deps: missing %s\n' "$dir"
  printf 'hint: run `bun install` in %s\n' "$dir"
}

if command -v bun >/dev/null 2>&1; then
  printf 'runtime: bun\n'
  bun --version
elif command -v npx >/dev/null 2>&1; then
  printf 'runtime: npx-bun\n'
  printf 'note: bun is not installed globally; the first run may need network access\n'
else
  printf 'runtime: missing\n'
  printf 'install bun: brew install oven-sh/bun/bun\n'
  exit 1
fi

if [ -f skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts ]; then
  printf 'cli: ok\n'
else
  printf 'cli: missing\n'
  exit 1
fi

if [ -f skills/baoyu-url-to-markdown/SKILL.md ]; then
  printf 'skill: ok\n'
else
  printf 'skill: missing\n'
  exit 1
fi

ensure_dir_dependencies "skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch"

if [ -f skills/baoyu-translate/SKILL.md ]; then
  printf 'skill: ok baoyu-translate\n'
else
  printf 'skill: missing baoyu-translate\n'
fi

ensure_dir_dependencies "skills/baoyu-translate/scripts"

if [ -f skills/baoyu-imagine/SKILL.md ]; then
  printf 'skill: ok baoyu-imagine\n'
else
  printf 'skill: missing baoyu-imagine\n'
fi

if [ -f skills/baoyu-cover-image/SKILL.md ]; then
  printf 'skill: ok baoyu-cover-image\n'
else
  printf 'skill: missing baoyu-cover-image\n'
fi

if [ -f skills/baoyu-infographic/SKILL.md ]; then
  printf 'skill: ok baoyu-infographic\n'
else
  printf 'skill: missing baoyu-infographic\n'
fi

if [ -f skills/baoyu-image-cards/SKILL.md ]; then
  printf 'skill: ok baoyu-image-cards\n'
else
  printf 'skill: missing baoyu-image-cards\n'
fi

if [ -f skills/baoyu-slide-deck/SKILL.md ]; then
  printf 'skill: ok baoyu-slide-deck\n'
else
  printf 'skill: missing baoyu-slide-deck\n'
fi

if [ -f skills/baoyu-comic/SKILL.md ]; then
  printf 'skill: ok baoyu-comic\n'
else
  printf 'skill: missing baoyu-comic\n'
fi

if [ -f skills/baoyu-article-illustrator/SKILL.md ]; then
  printf 'skill: ok baoyu-article-illustrator\n'
else
  printf 'skill: missing baoyu-article-illustrator\n'
fi

if [ -f skills/baoyu-diagram/SKILL.md ]; then
  printf 'skill: ok baoyu-diagram\n'
else
  printf 'skill: missing baoyu-diagram\n'
fi

if [ -f skills/baoyu-markdown-to-html/SKILL.md ]; then
  printf 'skill: ok baoyu-markdown-to-html\n'
else
  printf 'skill: missing baoyu-markdown-to-html\n'
fi

ensure_dir_dependencies "skills/baoyu-markdown-to-html/scripts"

if [ -f skills/baoyu-format-markdown/SKILL.md ]; then
  printf 'skill: ok baoyu-format-markdown\n'
else
  printf 'skill: missing baoyu-format-markdown\n'
fi

ensure_dir_dependencies "skills/baoyu-format-markdown/scripts"

if [ -f skills/baoyu-youtube-transcript/SKILL.md ]; then
  printf 'skill: ok baoyu-youtube-transcript\n'
else
  printf 'skill: missing baoyu-youtube-transcript\n'
fi

if [ -f skills/baoyu-post-to-wechat/SKILL.md ]; then
  printf 'skill: ok baoyu-post-to-wechat\n'
else
  printf 'skill: missing baoyu-post-to-wechat\n'
fi

ensure_dir_dependencies "skills/baoyu-post-to-wechat/scripts"

if [ -f skills/baoyu-post-to-x/SKILL.md ]; then
  printf 'skill: ok baoyu-post-to-x\n'
else
  printf 'skill: missing baoyu-post-to-x\n'
fi

ensure_dir_dependencies "skills/baoyu-post-to-x/scripts"

if [ -f skills/baoyu-danger-x-to-markdown/SKILL.md ]; then
  printf 'skill: ok baoyu-danger-x-to-markdown\n'
else
  printf 'skill: missing baoyu-danger-x-to-markdown\n'
fi

ensure_dir_dependencies "skills/baoyu-danger-x-to-markdown/scripts"
