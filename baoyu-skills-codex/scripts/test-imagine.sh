#!/bin/sh
set -eu

echo "running baoyu-imagine local tests"
bun test skills/baoyu-imagine/scripts/main.test.ts skills/baoyu-imagine/scripts/providers/*.test.ts

echo "note: live image generation is not included in this smoke test"
echo "note: to validate real generation, provide a provider API key and run the CLI manually"
