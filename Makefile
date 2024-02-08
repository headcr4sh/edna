.POSIX:

SHELL := /bin/sh

PROJECT_NAME := edna
PROJECT_DESCRIPTION := E.D.N.A.

FLUTTER := flutter
FLUTTER_OPTS := --no-sound-null-safety

.PHONY: help
help:
	@echo "Usage:"
	@echo "  init     - Re-creates portions of the project structure"
	@echo "  clean    - Clean flutter build output"
	@echo ""
	@echo "  web      - Build the progressive web app"
	@echo "  linux    - Build the Linux/Desktop app"

.PHONY: init
init:
	@$(FLUTTER) create --org com.cathive --project-name $(PROJECT_NAME) --description "$(PROJECT_DESCRIPTION)" .

.PHONY: prepare
prepare pubspec.lock: pubspec.yaml
	@$(FLUTTER) pub get

.PHONY: web
web build/web/.last_build_id:
	@$(FLUTTER) build web $(FLUTTER_OPTS)

build/linux/x64/debug/bundle/$(PROJECT_NAME):
	@$(FLUTTER) build linux $(FLUTTER_OPTS) --target-platform=linux-x64 --debug

build/linux/x64/release/bundle/$(PROJECT_NAME):
	@$(FLUTTER) build linux $(FLUTTER_OPTS) --target-platform=linux-x64 --release

.PHONY: linux-x64
linux-x64: build/linux/x64/debug/bundle/edna build/linux/x64/release/bundle/$(PROJECT_NAME)

.PHONY: linux
linux: linux-x64

.PHONY: clean
clean:
	@$(FLUTTER) clean
	@rm -Rf build/
