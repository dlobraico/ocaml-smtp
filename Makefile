UNIX ?= $(shell if ocamlfind query unix >/dev/null 2>&1; then echo --flag unix; fi)
LWT ?= $(shell if ocamlfind query lwt.unix >/dev/null 2>&1; then echo --flag lwt; fi)

ifneq ($(UNIX),)
UNIXPATH = dist/build/lib-smtp_unix/*
endif

ifneq ($(LWT),)
LWTPATH = dist/build/lib-smtp_lwt/*
endif

all: build

dist/setup:
	obuild configure $(UNIX) $(LWT)

build: dist/setup
	obuild build

install: build
	ocamlfind install smtp dist/build/lib-smtp/* $(UNIXPATH) $(LWTPATH) lib/META

uninstall:
	ocamlfind remove smtp

reinstall:
	$(MAKE) uninstall || true
	$(MAKE) install

PHONY: clean

clean:
	obuild clean
