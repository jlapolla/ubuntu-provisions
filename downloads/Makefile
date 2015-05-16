APACHE_MIRROR := http://mirror.cogentco.com/pub/apache
APACHE := https://www.apache.org/dist

.PHONY: clean

clean:
	rm -rf apache

define TEMPLATE
apache/$(1)/KEYS:
	@mkdir -p $$(@D)
	curl -s $$(APACHE)/$(1)/KEYS > $$@
	-gpg --import $$@

apache/$(1)/%.tar.gz.asc:
	@mkdir -p $$(@D)
	curl -s $$(APACHE)/$(1)/$$*.tar.gz.asc > $$@

apache/$(1)/%-UNVERIFIED.tar.gz:
	@mkdir -p $$(@D)
	curl -s $$(APACHE_MIRROR)/$(1)/$$*.tar.gz > $$@

apache/$(1)/%.tar.gz: $$(addprefix apache/$(1)/,%.tar.gz.asc %-UNVERIFIED.tar.gz) | apache/$(1)/KEYS
	@mkdir -p $$(@D)
	gpg --verify $$^
	cp apache/$(1)/$$*-UNVERIFIED.tar.gz $$@

endef
$(foreach VAR,apr httpd,$(eval $(call TEMPLATE,$(VAR))))
