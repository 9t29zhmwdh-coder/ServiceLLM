APP      = ServiceLLM
BUNDLE   = $(APP).app
INSTALL  = /Applications/$(BUNDLE)
ICON_SRC = $(APP).png
ICONSET  = .build/AppIcon.iconset

# Universal binary, so the release runs on Apple Silicon and Intel alike
ARCHS    = --arch arm64 --arch x86_64
# SwiftPM puts multi-arch output in a different directory than single-arch and
# has moved it between releases, so ask it rather than hardcoding the path
BINARY   = $(shell swift build -c release $(ARCHS) --show-bin-path)/$(APP)

.PHONY: build bundle icon install clean open verify-arch

build:
	swift build -c release $(ARCHS)

# Fails the build rather than shipping a silently single-arch binary
verify-arch: build
	@archs="$$(lipo -archs $(BINARY))"; \
	case "$$archs" in \
		*arm64*x86_64*|*x86_64*arm64*) echo "✓ universal binary: $$archs" ;; \
		*) echo "✗ expected a universal binary, got: $$archs" >&2; exit 1 ;; \
	esac

# Generates AppIcon.icns from the 1024px source, so only the PNG is versioned
icon:
	rm -rf $(ICONSET)
	mkdir -p $(ICONSET)
	for size in 16 32 128 256 512; do \
		sips -z $$size $$size $(ICON_SRC) --out $(ICONSET)/icon_$${size}x$${size}.png >/dev/null; \
		sips -z $$(($$size * 2)) $$(($$size * 2)) $(ICON_SRC) --out $(ICONSET)/icon_$${size}x$${size}@2x.png >/dev/null; \
	done
	iconutil -c icns $(ICONSET) -o .build/AppIcon.icns

bundle: verify-arch icon
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
