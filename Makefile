# Start with a conservative execution path
PATH:=/usr/sbin:/usr/bin:/sbin:/bin
PREFIX:=/

default:
	@echo 'There is nothing to be done for the default target.'

update:
	 svn update .

check-base-deps:
	@echo 'Checking that base packages are installed'
	@test -f /var/lib/dpkg/info/coreutils.list
	@test -f /var/lib/dpkg/info/bash.list

check-root:
# this install be done as root  
	/usr/bin/test 0 -eq `id -u`

check-deps:
	@echo 'Check (and install) dependancies'
	test -f /var/lib/dpkg/info/iproute.list || apt-get -y install iproute
	test -f /var/lib/dpkg/info/firehol.list || apt-get -y install firehol

install: check-root check-base-deps install-bin
	@echo 'test'

install-bin:
	@echo install --group=0 --owner=0 --mode=0755 sbin/advroute $(PREFIX)/sbin