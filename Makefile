VUNDLE_INSTALL := $(HOME)/.vim/bundle/Vundle.vim/README.md

SUBDIRS := build downloads

.PHONY: clean home-setup vundle-install

define CLEAN_TEMPLATE
	$(MAKE) -C $(1) clean

endef
clean:
	$(foreach VAR,$(SUBDIRS),$(call CLEAN_TEMPLATE,$(VAR)))

$(HOME)/%: etc/skel/%
	cp $< $@

vundle-install: $(VUNDLE_INSTALL)

$(VUNDLE_INSTALL): $(HOME)/.vimrc
	git clone --depth 1 https://github.com/gmarik/Vundle.vim.git $(@D)
	vim '+:PluginInstall' '+:qa' > /dev/null

home-setup: $(addprefix $(HOME)/,$(notdir $(wildcard etc/skel/.[!.]*))) $(VUNDLE_INSTALL)

define SUBDIRS_TEMPLATE
$(1)/%:
	$$(MAKE) -C $(1) $$*

endef
$(foreach VAR,$(SUBDIRS),$(eval $(call SUBDIRS_TEMPLATE,$(VAR))))
