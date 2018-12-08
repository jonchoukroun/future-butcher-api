#!/bin/sh

release_ctl eval --mfa "FutureButcherApi.ReleaseTasks.migrate/1" --argv -- "$@"
