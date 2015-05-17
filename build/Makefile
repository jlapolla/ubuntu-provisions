HTTPD_VERSION := 2.4.12
APR_VERSION := 1.5.2
APR_UTIL_VERSION := 1.5.4
HTTPD_UNPACK := httpd/README
HTTPD_CONFIGURE := httpd/Makefile
HTTPD_BUILD := httpd/httpd
HTTPD_INSTALL := /usr/local/apache2/bin/httpd
HTTPD_DIST := httpd-dist/usr/local/apache2/bin/httpd

SUBDIRS := ..

.PHONY: clean httpd-unpack httpd-configure httpd-build httpd-install httpd-dist

clean:
	rm -rf httpd httpd-dist httpd-dist.tar.gz

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
	$(MAKE) -C httpd install

httpd-dist: $(HTTPD_DIST)

$(HTTPD_DIST): $(HTTPD_BUILD)
	@rm -rf httpd-dist
	@mkdir httpd-dist
	$(MAKE) -C httpd DESTDIR="`pwd`/httpd-dist" install

httpd-dist.tar.gz: $(HTTPD_DIST)
	(cd httpd-dist && find . ! -type d -print0) | xargs -0 tar --owner=root --group=root -C httpd-dist -czf $@

define SUBDIRS_TEMPLATE
$(1)/%:
	$$(MAKE) -C $(1) $$*

endef
$(foreach VAR,$(SUBDIRS),$(eval $(call SUBDIRS_TEMPLATE,$(VAR))))
