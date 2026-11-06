VERSION=1.1

SYSCONFDIR = /etc
CONFDDIR = $(SYSCONFDIR)/conf.d
INITDDIR = $(SYSCONFDIR)/init.d
RLVLDIR = $(SYSCONFDIR)/runlevels

KMOD_INITD = \
	$(wildcard kmod/init.d/*)

SYSUSERS_INITD = \
	$(wildcard esysusers/init.d/*)

TMPFILES_INITD = \
	$(wildcard etmpfiles/init.d/*)

TMPFILES_CONFD = \
	$(wildcard etmpfiles/conf.d/*)

UDEV_INITD = \
	$(wildcard udev/init.d/*)

UDEV_CONFD = \
	$(wildcard udev/conf.d/*)

DIRMODE = -dm0755
FILEMODE = -m0644
MODE =  -m0755
LN = ln -snf

install_common:
	install $(DIRMODE) $(DESTDIR){$(CONFDDIR),$(INITDDIR)}
	install $(DIRMODE) $(DESTDIR)$(RLVLDIR)/{sysinit,boot,default}

install_udev: install_common
	install $(FILEMODE) $(UDEV_CONFD) $(DESTDIR)$(CONFDDIR)
	install $(MODE) $(UDEV_INITD) $(DESTDIR)$(INITDDIR)

	$(LN) $(INITDDIR)/udev $(DESTDIR)$(RLVLDIR)/sysinit/udev
	$(LN) $(INITDDIR)/udev-trigger $(DESTDIR)$(RLVLDIR)/sysinit/udev-trigger

install_kmod: install_common
	install $(DIRMODE) $(DESTDIR)$(RLVLDIR)/sysinit
	install $(MODE) $(KMOD_INITD) $(DESTDIR)$(INITDDIR)

	$(LN) $(INITDDIR)/kmod-static-nodes $(DESTDIR)$(RLVLDIR)/sysinit/kmod-static-nodes

install_sysusers: install_common
	install $(MODE) $(SYSUSERS_INITD) $(DESTDIR)$(INITDDIR)

	$(LN) $(INITDDIR)/esysusers $(DESTDIR)$(RLVLDIR)/boot/esysusers

install_tmpfiles: install_common
	install $(FILEMODE) $(TMPFILES_CONFD) $(DESTDIR)$(CONFDDIR)
	install $(MODE) $(TMPFILES_INITD) $(DESTDIR)$(INITDDIR)

	$(LN) $(INITDDIR)/etmpfiles-dev $(DESTDIR)$(RLVLDIR)/sysinit/etmpfiles-dev
	$(LN) $(INITDDIR)/etmpfiles-setup $(DESTDIR)$(RLVLDIR)/boot/etmpfiles-setup


install: install_udev install_kmod install_sysusers install_tmpfiles

PHONY: install install_udev install_kmod install_sysusers install_tmpfiles
