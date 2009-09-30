#!/usr/bin/make -f
#
#   Copyright information
#
#	Copyright (C) 2003-2009 Jari Aalto
#	Copyright (C) YYYY Firstname Lastname
#
#   License
#
#	This program is free software; you can redistribute it and/or
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of the
#	License, or (at your option) any later version
#
#	This program is distributed in the hope that it will be useful, but
#	WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#	General Public License for more details.
#
#	Visit <http://www.gnu.org/copyleft/gpl.html>

ifneq (,)
This makefile requires GNU Make.
endif

PACKAGE		= foo
DESTDIR		=
prefix		= /usr
exec_prefix	= $(prefix)
man_prefix	= $(prefix)/share
mandir		= $(man_prefix)/man
bindir		= $(exec_prefix)/bin
sharedir	= $(prefix)/share

BINDIR		= $(DESTDIR)$(bindir)
DOCDIR		= $(DESTDIR)$(sharedir/doc
SHAREDIR	= $(DESTDIR)$(prefix)/share/$(PACKAGE)
LIBDIR		= $(DESTDIR)$(prefix)/lib/$(PACKAGE)
SBINDIR		= $(DESTDIR)$(exec_prefix)/sbin
ETCDIR		= $(DESTDIR)/etc/$(PACKAGE)

# 1 = regular, 5 = conf, 6 = games, 8 = daemons
MANDIR		= $(DESTDIR)$(mandir)
MANDIR1		= $(MANDIR)/man1
MANDIR5		= $(MANDIR)/man5
MANDIR6		= $(MANDIR)/man6
MANDIR8		= $(MANDIR)/man8

INSTALL_OBJS_BIN   = $(PACKAGE)
INSTALL_OBJS_MAN1  = *.1
INSTALL_OBJS_SHARE =
INSTALL_OBJS_ETC   =

INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) -m 755
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_SUID	= $(INSTALL) -m 4755

LDFLAGS		=
CC		= gcc
GCCFLAGS	= -Wall
DEBUG		= -g
CFLAGS		= $(CC_EXTRA_FLAGS) $(DEBUG) -O2
CXX		= g++
CXXFLAGS	= $(CXX_EXTRA_FLAGS) $(DEBUG) -O2

SRCS		= $(PACKAGE).c
OBJS		= $(SRCS:.c=.o)
EXE		= $(PACKAGE)
LIBS		=

ASM_SRCS	=
ASM_OBJS	= $(ASM_SRCS:.asm=.o)
ASM_FLAGS	=

.SUFFIXES: .asm

all: $(EXE)

.cc.o:
	$(CXX) $(CXXLAGS) -c -o $*.o $<

.asm.o: $(ASM_OBJS)
	nasm $(ASM_FLAGS) $<

$(EXE): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS) $(LIBS)

clean:
	# clean
	-rm -f *[#~] *.\#* *.o core \
	*.pyc *.elc \
	*.exe *.stackdump $(PACKAGE)

distclean: clean

realclean: clean

install-etc:
	# install-etc
	$(INSTALL_BIN) -d $(ETCDIR)
	$(INSTALL_BIN)	  $(INSTALL_OBJS_ETC) $(ETCDIR)

install-man:
	# install-man
	$(INSTALL_BIN) -d $(MANDIR1)
	$(INSTALL_DATA) $(INSTALL_OBJS_MAN1) $(MANDIR1)

install-bin:
	# install-bin
	$(INSTALL_BIN) -d $(BINDIR)
	$(INSTALL_BIN) -s $(INSTALL_OBJS_BIN) $(BINDIR)

install: all install-bin install-man

.PHONY: clean distclean realclean install install-bin install-man

# End of file