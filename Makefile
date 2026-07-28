APP      = ServiceLLM
BUNDLE   = $(APP).app
BINARY   = .build/release/$(APP)
INSTALL  = /Applications/$(BUNDLE)
ICON_SRC = $(APP).png
ICONSET  = .build/AppIcon.iconset

.PHONY: build bundle icon install clean open

build:
	swift build -c release

# Generates AppIcon.icns from the 1024px source, so only the PNG is versioned
icon:
	rm -rf $(ICONSET)
	mkdir -p $(ICONSET)
	for size in 16 32 128 256 512; do \
		sips -z $$size $$size $(ICON_SRC) --out $(ICONSET)/icon_$${size}x$${size}.png >/dev/null; \
		sips -z $$(($$size * 2)) $$(($$size * 2)) $(ICON_SRC) --out $(ICONSET)/icon_$${size}x$${size}@2x.png >/dev/null; \
	done
	iconutil -c icns $(ICONSET) -o .build/AppIcon.icns

bundle: build icon
	rm -rf $(BUNDLE)
	mkdir -p $(BUNDLE)/Contents/MacOS
	mkdir -p $(BUNDLE)/Contents/Resources
	cp $(BINARY) $(BUNDLE)/Contents/MacOS/
	cp Info.plist $(BUNDLE)/Contents/
	cp .build/AppIcon.icns $(BUNDLE)/Contents/Resources/
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
