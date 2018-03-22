#!/usr/bin/env bash

# Hacky script to generate CV using local theme and theme manager
# Requires jsonresume-cli to be installed

pushd `dirname $0` > /dev/null
BASE_DIR=`pwd -P`
popd > /dev/null

if [ ! -d "target" ]; then
	mkdir target
fi

if [ ! -d "target/theme-manager" ]; then
	cd target
	git clone git@github.com:jsonresume/theme-manager.git
	cd theme-manager
	npm install
	mkdir -p themes
	ln -s $BASE_DIR/lemonlabs-jsonresume-theme themes/lemonlabs-jsonresume-theme
	cd themes/lemonlabs-jsonresume-theme/1.0.0
	npm install
	cd $BASE_DIR
fi


cd target/theme-manager

node server.js &
THEME_MANAGER_PID=$!
echo "Theme manager running as process $THEME_MANAGER_PID"

sleep 5 # Classic. Fixes everything.

cd $BASE_DIR
export THEME_SERVER=http://localhost:3000/theme/
resume export --theme=lemonlabs-jsonresume-theme index.html

kill $THEME_MANAGER_PID
