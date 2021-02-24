#!/bin/bash

export SECRET_KEY_BASE=$SECRET_KEY_BASE
export MIX_ENV=prod
export PORT=4791

echo "Stopping old copy of app, if any..."

_build/prod/rel/bulls/bin/bulls stop || true

echo "Starting app..."

_build/prod/rel/bulls/bin/bulls start

# TODO: Add a systemd service file
#       to start your app on system boot.
