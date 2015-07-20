HTTPD_VERSION := 2.4.16
APR_VERSION := 1.5.2
APR_UTIL_VERSION := 1.5.4
HTTPD_UNPACK := httpd/README
HTTPD_CONFIGURE := httpd/Makefile
HTTPD_BUILD := httpd/httpd
HTTPD_INSTALL := /usr/local/apache2/bin/httpd
HTTPD_DIST := httpd-dist$(HTTPD_INSTALL)

NODEJS_VERSION := 0.12.3
NODEJS_UNPACK := nodejs/README.md
NODEJS_CONFIGURE := nodejs/config.mk
NODEJS_BUILD := nodejs/out/Release/node
NODEJS_INSTALL := /usr/local/bin/node
NODEJS_DIST := nodejs-dist$(NODEJS_INSTALL)

SUBDIRS := ..

.PHONY: clean httpd-unpack httpd-configure httpd-build httpd-install httpd-dist \
	nodejs-unpack nodejs-configure nodejs-build nodejs-install nodejs-dist

define ROOT_TEST
@test `id -u` = 0 || (printf '%s\n' 'Need root permission. Try "sudo $(MAKE) $@".' 1>&2 ; exit 1)
endef

clean:
	rm -rf httpd httpd-dist httpd-dist.tar.gz nodejs nodejs-dist nodejs-dist.tar.gz

httpd-unpack: $(HTTPD_UNPACK)

define UNTAR_TEMPLATE
	tar -xzmof $(1)

endef
$(HTTPD_UNPACK): $(addprefix ../downloads/apache/,httpd/httpd-$(HTTPD_VERSION).tar.gz apr/apr-$(APR_VERSION).tar.gz apr/apr-util-$(APR_UTIL_VERSION).tar.gz)
	@rm -rf httpd
	$(foreach VAR,$^,$(call UNTAR_TEMPLATE,$(VAR)))
	mv httpd-$(HTTPD_VERSION) httpd
	mv apr-$(APR_VERSION) httpd/srclib/apr
	mv apr-util-$(APR_UTIL_VERSION) httpd/srclib/apr-util

httpd-configure: $(HTTPD_CONFIGURE)

$(HTTPD_CONFIGURE): $(HTTPD_UNPACK) 
	(cd httpd && ./configure --with-included-apr)

httpd-build: $(HTTPD_BUILD)

$(HTTPD_BUILD): $(HTTPD_CONFIGURE)
	$(MAKE) -C httpd all

httpd-install: $(HTTPD_INSTALL)

$(HTTPD_INSTALL): $(HTTPD_BUILD)
	$(call ROOT_TEST)
	$(MAKE) -C httpd install

httpd-dist: $(HTTPD_DIST)

$(HTTPD_DIST): $(HTTPD_BUILD)
	@rm -rf httpd-dist
	@mkdir httpd-dist
	$(MAKE) -C httpd DESTDIR="`pwd`/httpd-dist" install

httpd-dist.tar.gz: $(HTTPD_DIST)
	(cd httpd-dist && find . ! -type d -print0) | xargs -0 tar --owner=root --group=root -C httpd-dist -czf $@

nodejs-unpack: $(NODEJS_UNPACK)

$(NODEJS_UNPACK):
	@rm -rf nodejs
	git clone -b v$(NODEJS_VERSION) --depth 1 https://github.com/joyent/node.git nodejs

nodejs-configure: $(NODEJS_CONFIGURE)

$(NODEJS_CONFIGURE): $(NODEJS_UNPACK)
	(cd nodejs && ./configure)

nodejs-build: $(NODEJS_BUILD)

$(NODEJS_BUILD): $(NODEJS_CONFIGURE)
	$(MAKE) -C nodejs all

nodejs-install: $(NODEJS_INSTALL)

$(NODEJS_INSTALL): $(NODEJS_BUILD)
	$(call ROOT_TEST)
	$(MAKE) -C nodejs install
	touch -c $(NODEJS_INSTALL)

nodejs-dist: $(NODEJS_DIST)

$(NODEJS_DIST): $(NODEJS_BUILD)
	@rm -rf nodejs-dist
	@mkdir nodejs-dist
	$(MAKE) -C nodejs DESTDIR="`pwd`/nodejs-dist" install
	touch -c $(NODEJS_DIST)

nodejs-dist.tar.gz: $(NODEJS_DIST)
	(cd nodejs-dist && find . ! -type d -print0) | xargs -0 tar --owner=root --group=root -C nodejs-dist -czf $@

define SUBDIRS_TEMPLATE
$(1)/%:
	$$(MAKE) -C $(1) $$*

endef
$(foreach VAR,$(SUBDIRS),$(eval $(call SUBDIRS_TEMPLATE,$(VAR))))
