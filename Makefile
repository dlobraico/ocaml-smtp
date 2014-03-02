UNIX ?= $(shell if ocamlfind query unix >/dev/null 2>&1; then echo --flag unix; fi)
LWT ?= $(shell if ocamlfind query lwt.unix >/dev/null 2>&1; then echo --flag lwt; fi)
ASYNC ?= $(shell if ocamlfind query async_unix >/dev/null 2>&1; then echo --flag async; fi)

ifneq ($(UNIX),)
UNIXPATH = dist/build/lib-smtp_unix/*
endif

ifneq ($(LWT),)
LWTPATH = dist/build/lib-smtp_lwt/*
endif

ifneq ($(LWT),)
ASYNCPATH = dist/build/lib-smtp_async/*
endif

all: build

dist/setup:
	obuild configure $(UNIX) $(LWT) $(ASYNC)

build: dist/setup
	obuild build

install: build
	ocamlfind install smtp dist/build/lib-smtp/* $(UNIXPATH) $(LWTPATH) $(ASYNCPATH) lib/META

uninstall:
	ocamlfind remove smtp

reinstall:
	$(MAKE) uninstall || true
	$(MAKE) install

PHONY: clean

clean:
	obuild clean
