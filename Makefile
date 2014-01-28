ifdef DESTDIR
	prefix ?= /usr
else
	prefix ?= /usr/local
endif

bindir ?= $(prefix)/bin

build:
	@true

clean:
	@true

git-pinch.1: git-pinch.md
	@pandoc -s -t man git-pinch.md -o git-pinch.1

docs: git-pinch.1

install:
	@install -d $(DESTDIR)$(bindir)
	@install git-pinch $(DESTDIR)$(bindir)/git-pinch

test:
	carton install
	carton exec -- prove -lvr t

all: install
	@true

.PHONY: all build clean install test docs
