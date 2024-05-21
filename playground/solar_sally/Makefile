all: .tested

SHRINKO8=python3 ../../shrinko8/shrinko8.py
PICO8_FOLDER=../../../../pico8/pico-8
PICO8=$(PICO8_FOLDER)/pico8
PICO8_DAT=$(PICO8_FOLDER)/pico8.dat
COUNTER=../../get_counts.sh
LUA_FILES:=$(shell cat solar_sally.p8 | grep include | cut -c 10-)
SHRINKO8_OPTIONS=--minify --no-minify-lines --focus-tokens # there are some other options for particular runs

.SECONDEXPANSION: # needed for the wildcard stuff
output/solar_sally.p8 output/solar_sally.p8.png &: solar_sally.p8 $(LUA_FILES)
	mkdir -p output
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8 --rename-map rename_map.txt $(SHRINKO8_OPTIONS) # So we can examine minified code
	$(SHRINKO8) solar_sally.p8 output/solar_sally.p8.png $(SHRINKO8_OPTIONS)

.tested: output/solar_sally.p8.png tests/tests.txt
	# cd /mnt/c/Users/dbese/Dropbox/pico8 && cmd.exe /c run-pico8.bat -x root/playground/solar_sally/tests.p8
	rm -f test_output.txt
	cp tests/tests.txt output/tests.lua
	$(PICO8) -x output/tests.lua | tee test_output.txt
	cat test_output.txt | tail -1 | grep "Pass"
	touch .tested

.PHONY: web
web: output/web/solar_sally.html output/web/solar_sally.js

output/web/solar_sally.html output/web/solar_sally.js &: solar_sally.p8 output/solar_sally.p8.png
	mkdir -p output/web/
	# Output the pre-shrinko8 .js file and .html file
	$(PICO8) -export output/web/solar_sally.html output/solar_sally.p8.png
	# Output the shrinko8 .js file
	$(SHRINKO8) solar_sally.p8 output/web/solar_sally.js --pico8-dat $(PICO8_DAT) $(SHRINKO8_OPTIONS)

.PHONY: lint
lint:
	$(SHRINKO8) solar_sally.p8 --lint

.PHONY: find-todos
find-todos:
	! grep --exclude Makefile -rin --color=yes todo .

.PHONY: counts
counts: output/solar_sally.p8.png
	$(SHRINKO8) output/solar_sally.p8.png --count
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
workflow-copy-lint: copy-to-windows .tested lint find-todos
