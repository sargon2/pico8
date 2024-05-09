all: .tested

SHRINKO8=python3 ../../shrinko8/shrinko8.py
COUNTER=../../get_counts.sh
LUA_FILES:=$(shell cat solar_sally.p8 | grep include | cut -c 10-)

.SECONDEXPANSION: # needed for the wildcard stuff
output/solar_sally.p8.png: solar_sally.p8 $(LUA_FILES)
	mkdir -p output
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8 --minify --no-minify-lines --focus-tokens # So we can examine minified code
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8.png --minify --no-minify-lines --focus-tokens
	# $(SHRINKO8) solar_sally.p8 --lint --no-lint-fail
	$(SHRINKO8) output/solar_sally.p8.png --count

.tested: output/solar_sally.p8.png
	# cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -x root/playground/solar_sally/tests.p8
	rm -f test_output.txt
	cp tests/tests.txt output/tests.lua
	../../../../pico8/pico-8/pico8 -x output/tests.lua | tee test_output.txt
	cat test_output.txt | tail -1 | grep "Pass"
	touch .tested

.PHONY: lint
lint:
	$(SHRINKO8) solar_sally.p8 --lint

.PHONY: counts
counts: output/solar_sally.p8.png
	@$(COUNTER) $(LUA_FILES) solar_sally.p8 output/solar_sally.p8.png

.PHONY: run-windows
run-windows: copy-to-windows
	cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -run root/playground/solar_sally/output/solar_sally.p8.png

.PHONY: run-windows-nonpng
run-windows-nonpng: copy-to-windows
	cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -run root/playground/solar_sally/output/solar_sally.p8

.PHONY: pull-noncode-back
pull-noncode-back:
	# Copy everything except code from the output .p8 file to the input .p8 file.
	# Suitable for use with run-windows-nonpng.
	cp /mnt/c/Users/dbese/Dropbox/pico8/root/playground/solar_sally/output/solar_sally.p8 output/
	sed '/__.*__/{/__lua__/!q;}' solar_sally.p8 | head -n -1 > solar_sally_new.p8
	awk '/__.*__/ && !/__lua__/ {p=1} p' output/solar_sally.p8 >> solar_sally_new.p8
	mv solar_sally_new.p8 solar_sally.p8

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

# Workflow targets

# Intended for use with watch-and-run. We do the build before running lint so we can debug pre-linted code
.PHONY: workflow-copy-lint
workflow-copy-lint: copy-to-windows lint
