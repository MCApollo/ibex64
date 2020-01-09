#  ibex - main makefile
#
#  Copyright (c) 2010, 2014-2016 xerub
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


.PHONY: all clean distclean

CROSS_COMPILE = aarch64-apple-darwin17-

CC = $(CROSS_COMPILE)clang
CFLAGS = -Wall -W -pedantic
CFLAGS += -Wno-long-long
CFLAGS += -Os
# CFLAGS += -arch arm64 -miphoneos-version-min=11.0

LD = $(CROSS_COMPILE)clang
LDFLAGS = -L. -nostdlib
# LDFLAGS += -arch arm64
LDLIBS = -lp

AR = $(CROSS_COMPILE)ar
ARFLAGS = crus

OBJCOPY = $(CROSS_COMPILE)objcopy

ifeq ($(TARGET),)
#LDFLAGS += -Ttext=0x800000000
else
include $(TARGET)/target.mak
endif
CFLAGS += -I.
#LDLIBS += -lgcc

SOURCES = \
	link.c \
	main.c

LIBSOURCES = \
	asm/cache.S \
	asm/interrupt.S \
	asm/printf.S \
	asm/snprintf.S \
	lib/atoi.c \
	lib/div.c \
	lib/memcmp.c \
	lib/memmem.c \
	lib/memmove.c \
	lib/memset.c \
	lib/strcmp.c \
	lib/xtol.c \
	lib/xtoi.c

OBJECTS = $(SOURCES:.c=.o)
LIBOBJECTS = $(addsuffix .o, $(basename $(LIBSOURCES)))

.S.o:
	$(CC) -o $@ $(CFLAGS) -c $<

.c.o:
	$(CC) -o $@ $(CFLAGS) -c $<

all: payload

payload: payload.darwin
	$(OBJCOPY) -O binary $< $@

payload.darwin: $(OBJECTS) | entry.o libp.a
	$(LD) -o $@ $(LDFLAGS) $^ $(LDLIBS)

libp.a: $(LIBOBJECTS)
	$(AR) $(ARFLAGS) $@ $^

clean:
	-$(RM) *.o *.elf *.a $(LIBOBJECTS)

distclean: clean
	-$(RM) payload

-include depend
