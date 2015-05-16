SUBDIRS := build downloads

.PHONY: clean

define CLEAN_TEMPLATE
	$(MAKE) -C $(1) clean

endef
clean:
	$(foreach VAR,$(SUBDIRS),$(call CLEAN_TEMPLATE,$(VAR)))

define SUBDIRS_TEMPLATE
$(1)/%:
	$$(MAKE) -C $(1) $$*

endef
$(foreach VAR,$(SUBDIRS),$(eval $(call SUBDIRS_TEMPLATE,$(VAR))))
