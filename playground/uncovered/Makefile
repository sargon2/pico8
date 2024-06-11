.PHONY: copy-to-windows
copy-to-windows: uncovered.p8
	cd ../.. && ./push-to-windows.sh

.PHONY: run-windows
run-windows: copy-to-windows
	cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -run root/playground/uncovered/uncovered.p8

