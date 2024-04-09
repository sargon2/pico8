all: solar_sally.p8.png

SHRINKO8=python3 ../../shrinko8/shrinko8.py

.SECONDEXPANSION: # needed for the wildcard stuff
solar_sally.p8.png: $$(shell find $$*/*.lua $$*/*.p8 -type f 2>/dev/null | sed 's/ /\\ /g')
	mkdir -p output
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8 --minify-safe-only # So we can examine minified code
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8.png --minify-safe-only
	$(SHRINKO8) solar_sally.p8 --lint --no-lint-fail
	$(SHRINKO8) output/solar_sally.p8.png --count


.PHONY: lint
lint:
	$(SHRINKO8) solar_sally.p8 --lint

.PHONY: run-windows
run-windows:
	cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -run root/mine/solar_sally/output/solar_sally.p8.png

.PHONY: copy-to-windows
copy-to-windows: solar_sally.p8.png
	cd ../.. && ./push-to-windows.sh

.PHONY: copy-and-run
copy-and-run: copy-to-windows run-windows

.PHONY: clean
clean:
	git clean -X -d -f -f
