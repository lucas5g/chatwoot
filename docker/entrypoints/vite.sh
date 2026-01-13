#!/bin/sh
set -x

rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

# install missing gems
bundle check || bundle install

pnpm store prune
pnpm install --force

echo "Ready to run Vite development server."

exec "$@"
