#!/bin/bash

set -uex

cd "$(dirname "$0")/.."

npm ci
npm run generate:parser
npm run format
npm test
npm run build
if git status --porcelain | grep -v -e "^[MADR]\s"; then
    echo "The working copy has unstaged changes"
    exit 1
fi

if [[ "${1:-}" == "--release" ]]; then
    git config user.email "1853310+rorz@users.noreply.github.com"
    git config user.name "rorz"

    npm version patch
    git push
    git push --tags
    npm publish
fi
