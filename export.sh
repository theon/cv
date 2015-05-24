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
	ln -s $BASE_DIR/jsonresume-theme-dark-classy-responsive themes/jsonresume-theme-dark-classy-responsive
	cd $BASE_DIR
fi


cd target/theme-manager

node server.js &
THEME_MANAGER_PID=$!

sleep 1 # Classic. Fixes everything.

cd $BASE_DIR
export THEME_SERVER=http://localhost:3000/theme/
resume export --theme=dark-classy-responsive index.html

kill $THEME_MANAGER_PID
