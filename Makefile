# Start with a conservative execution path
PATH:=/usr/sbin:/usr/bin:/sbin:/bin
PREFIX:=/
INSTALL_PROGRAM:=/usr/bin/install --group=0 --owner=0 --mode=0755
INSTALL_DATA:=/usr/bin/install --group=0 --owner=0 --mode=0644

default:
	@echo 'There is nothing to be done for the default target.'

check-base-deps:
	@echo 'Checking that base packages are installed'
	@test -f /var/lib/dpkg/info/coreutils.list
	@test -f /var/lib/dpkg/info/bash.list

check-root:
# this install be done as root  
	/usr/bin/test 0 -eq `id -u`

check-deps:
	@echo 'Check (and install) dependancies'
	@test -f /var/lib/dpkg/info/iproute.list || apt-get -y install iproute
	@test -f /var/lib/dpkg/info/firehol.list || apt-get -y install firehol

install: check-root check-base-deps check-deps \
         install-bin install-conf

install-bin:
	@$(INSTALL_PROGRAM) etc/init.d/advroute $(PREFIX)etc/init.d/
	@if test ! -f $(PREFIX)/etc/rcS.d/S41advroute; then \
		echo "Enabling Startup Links"; \
		update-rc.d advroute start 41 S . ;\
	fi;
	@$(INSTALL_PROGRAM) etc/network/if-up.d/000advroute $(PREFIX)etc/network/if-up.d/
	@$(INSTALL_PROGRAM) sbin/advroute $(PREFIX)sbin/
	@$(INSTALL_PROGRAM) sbin/export_rttables $(PREFIX)sbin/

install-conf:
	@echo Installing configuration files
	@mkdir -p $(PREFIX)usr/share/doc/advroute/examples/
# /etc/network/routes
	@$(INSTALL_DATA) etc/network/routes \
	                 $(PREFIX)usr/share/doc/advroute/examples/routes
	@if test ! -f $(PREFIX)etc/network/routes; then \
		echo "Installing config file /etc/network/routes"; \
		$(INSTALL_DATA) etc/network/routes \
		                $(PREFIX)etc/network/routes; \
	fi; \
# /etc/default/advroute
	@if test ! -f $(PREFIX)etc/default/advroute; then \
		echo "Installing config file /etc/default/advroute"; \
		$(INSTALL_DATA) etc/default/advroute \
		                $(PREFIX)etc/default/advroute; \
	fi;
# /usr/share/doc/advroute/examples/firehol.conf
	@$(INSTALL_DATA) usr/share/doc/advroute/examples/firehol.conf \
	                 $(PREFIX)usr/share/doc/advroute/examples/firehol.conf

