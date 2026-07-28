APP     = ServiceLLM
BUNDLE  = $(APP).app
BINARY  = .build/release/$(APP)
INSTALL = /Applications/$(BUNDLE)

.PHONY: build bundle install clean open

build:
	swift build -c release

bundle: build
	rm -rf $(BUNDLE)
	mkdir -p $(BUNDLE)/Contents/MacOS
	mkdir -p $(BUNDLE)/Contents/Resources
	cp $(BINARY) $(BUNDLE)/Contents/MacOS/
	cp Info.plist $(BUNDLE)/Contents/
	codesign --sign - --force --deep $(BUNDLE)
	@echo "✓ $(BUNDLE) ready"

install: bundle
	rm -rf $(INSTALL)
	cp -r $(BUNDLE) /Applications/
	/System/Library/CoreServices/pbs -flush
	@echo "✓ Installed to /Applications, restart apps to see Services menu entries"

clean:
	rm -rf .build $(BUNDLE)

open:
	open Package.swift
