#!/usr/bin/env bash

set -e

cd /opt/build

APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"

mkdir -p /opt/build/releases

mix.local rebar --force
mix.local hex --if-mixing --force

export MIX_ENV=prod

mix deps.get --prod-only
mix do clean, compile --force

mix release

cp . releases/
