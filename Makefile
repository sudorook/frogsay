# SPDX-FileCopyrightText: 2022 sudorook <daemon@nullcodon.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

# Makefile for Frogsay

PACKAGE_TARNAME = frogsay

prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
datarootdir = ${prefix}/share
datadir = ${datarootdir}
docdir = ${datarootdir}/doc/${PACKAGE_TARNAME}
sysconfdir = ${prefix}/etc
mandir=${datarootdir}/man
srcdir = .

SHELL = /bin/sh
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = ${INSTALL} -m 644

.PHONY: clean man install uninstall

clean:
	@echo Nothing to do.

# The target creates frogsay.1.adoc, and is included for convenience
#
# The 'make man' target is intended for use at write time, not build time,
# so it is not part of the normal build sequence, and its outputs are
# checked in to the source tree. This is partially to simplify the build
# process, and partially to preserve the internal "update" timestamp inside
# the man pages. We do this at build time to avoid introducing a dependency on
# Asciidoc for users.

man: frogsay.1

frogsay.1: frogsay.1.adoc
	a2x --format manpage ./frogsay.1.adoc

install: frogsay.1
	$(INSTALL) -d $(DESTDIR)$(prefix)
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM) frogsay $(DESTDIR)$(bindir)/frogsay
	$(INSTALL_PROGRAM) frogthink $(DESTDIR)$(bindir)/frogthink
	$(INSTALL) -d $(DESTDIR)$(mandir)/man1
	$(INSTALL_DATA) frogsay.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL_DATA) frogthink.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL) -d $(DESTDIR)$(datadir)/frogsay
	cp -R share/frogs $(DESTDIR)$(datadir)/frogsay
	$(INSTALL) -d $(DESTDIR)$(datadir)/frogsay/site-frogs

uninstall:
	rm -f $(DESTDIR)$(bindir)/frogsay $(DESTDIR)$(bindir)/frogthink
	rm -f $(DESTDIR)$(mandir)/man1/frogsay.1 $(DESTDIR)$(mandir)/man1/frogthink.1
	rm -rf $(DESTDIR)$(datadir)/frogs
