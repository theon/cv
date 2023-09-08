#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
BASE_DIR=`pwd -P`
popd > /dev/null

THEME=jsonresume-theme-lemonlabs
GLOBAL_NODE_MODULES="/usr/local/lib/node_modules"

if [ ! -d "$GLOBAL_NODE_MODULES/$THEME" ]; then
  ln -s "$BASE_DIR" "$GLOBAL_NODE_MODULES/$THEME"
fi

# Export HTML
resume export --theme lemonlabs index.html

# Export PDF - (npm install -g chrome-headless-render-pdf)
python -m http.server &

RESUME_SERVE_PID=$!
chrome-headless-render-pdf  --url=http://localhost:8000 --pdf=ian-forsey-resume.pdf
kill -9 $RESUME_SERVE_PID
