#!/usr/bin/bash -ex

./copy_to_windows_and_run_solar_sally.sh &
sleep 1
watch-and-run . ./push-to-windows.sh
