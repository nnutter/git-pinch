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

install:
	@install -d $(DESTDIR)$(bindir)
	@install git-pinch $(DESTDIR)$(bindir)/git-pinch

test:
	carton install
	carton exec -- prove -lvr t

all: install
	@true

.PHONY: all build clean install test
