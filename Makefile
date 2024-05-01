# Devuan 5.0.1 Minimal System Global Makefile Install

TPMTL_PATH = ./template
BASEDIR:=$(shell dab basedir)

global: info/init_ok sysinst addpkg base_config end

end:
        # ========================
        # Create OpenVZ Appliance
        # ========================
	dab finalize

info/init_ok: dab.conf
	dab init
	touch $@

sysinst:
        # =======================
        # Sys Install
        #========================
        # Minimal debootstrap
	@dab bootstrap --minimal

        # locales
	@dab install locales
	@sed -e 's/^# it_IT.UTF-8/it_IT.UTF-8/' -i ${BASEDIR}/etc/locale.gen
	@sed -e 's/^# it_IT@euro/it_IT@euro/' -i ${BASEDIR}/etc/locale.gen
	@dab exec dpkg-reconfigure locales
        # default locale to it_IT UTF8
	@echo "LANG=it_IT.UTF-8" > ${BASEDIR}/etc/default/locale

        # Set timezone to Europe/Paris
	@echo "Europe/Paris" > ${BASEDIR}/etc/timezone
	@dab exec rm -f /etc/localtime
	@dab exec cp -f /usr/share/zoneinfo/Europe/Paris /etc/localtime

addpkg:
        # =========================
        # Add pkg
        # =========================
	@dab install devuan-keyring
	@dab install sudo
	@dab install git
	@dab install htop
	@dab install unattended-upgrades
	@dab install wget
	@dab install apt-transport-https
	@dab install net-tools
	@dab install pciutils
	@dab install screenfetch
	@dab install ncdu
	@dab install python3-pip
	@dab install libpq-dev
	@dab install curl

base_config:
        # =====================
        # Sys Config
        # =====================
	install -m 0644 $(TPMTL_PATH)/profile ${BASEDIR}/etc/profile
	install -m 0644 $(TPMTL_PATH)/bash.bashrc ${BASEDIR}/etc/bash.bashrc

        # Network config sample
	install -m 0644 $(TPMTL_PATH)/interfaces.static ${BASEDIR}/etc/network/interfaces.static

.PHONY: clean
clean:
	dab clean
	rm -f *~

.PHONY: dist-clean
dist-clean:
	dab dist-clean
	rm -f *~
