all: output/solar_sally.p8.png

SHRINKO8=python3 ../../shrinko8/shrinko8.py
COUNTER=../../get_counts.sh
LUA_FILES:=$(shell cat solar_sally.p8 | grep include | cut -c 10-)

.SECONDEXPANSION: # needed for the wildcard stuff
output/solar_sally.p8.png: $$(shell find $$* -type f \( -name "*.lua" -o -name "*.p8" \) ! -path "./output/*" 2>/dev/null | sed 's/ /\\ /g')
	mkdir -p output
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8 --minify --no-minify-lines --focus-tokens # So we can examine minified code
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8.png --minify --no-minify-lines --focus-tokens
	$(SHRINKO8) solar_sally.p8 --lint --no-lint-fail
	$(SHRINKO8) output/solar_sally.p8.png --count


.PHONY: lint
lint:
	$(SHRINKO8) solar_sally.p8 --lint

.PHONY: counts
counts: output/solar_sally.p8.png
	@$(COUNTER) $(LUA_FILES) solar_sally.p8 output/solar_sally.p8.png

.PHONY: run-windows
run-windows:
	cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -run root/mine/solar_sally/output/solar_sally.p8.png

.PHONY: copy-to-windows
copy-to-windows: output/solar_sally.p8.png
	cd ../.. && ./push-to-windows.sh

.PHONY: pull-from-windows
pull-from-windows:
	cd ../.. && ./pull-from-windows.sh

.PHONY: copy-and-run
copy-and-run: copy-to-windows run-windows

.PHONY: clean
clean:
	git clean -X -d -f -f
