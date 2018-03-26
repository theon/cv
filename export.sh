#!/usr/bin/env bash

# Hacky script to generate CV using local theme and theme manager
# Requires jsonresume-cli to be installed

THEME=jsonresume-theme-lemonlabs

pushd `dirname $0` > /dev/null
BASE_DIR=`pwd -P`
popd > /dev/null

if [ ! -d "target" ]; then
	mkdir target
fi

cd target

if [ ! -d "theme-manager" ]; then
	git clone git@github.com:jsonresume/theme-manager.git
fi

cd theme-manager
npm install
mkdir -p themes

if [ ! -L "themes/$THEME" ]; then
	ln -s $BASE_DIR/$THEME themes/$THEME
fi

cd themes/$THEME/1.0.0
npm install

cd $BASE_DIR/target/theme-manager

node server.js &
THEME_MANAGER_PID=$!
echo "Theme manager running as process $THEME_MANAGER_PID"

sleep 5 # Classic. Fixes everything.

cd $BASE_DIR
export THEME_SERVER=http://localhost:3000/theme/
resume export --theme=lemonlabs index.html

kill $THEME_MANAGER_PID
