CPANMINUS_INSTALL := /usr/local/bin/cpanm
VUNDLE_INSTALL := $(HOME)/.vim/bundle/Vundle.vim/README.md
GOOGLE_CHROME_INSTALL := /usr/bin/google-chrome

SUBDIRS := build downloads

.PHONY: clean home-setup vundle-install cpanminus-install google-chrome-install

define ROOT_TEST
@test `id -u` = 0 || (printf '%s\n' 'Need root permission. Try "sudo $(MAKE) $@".' 1>&2 ; exit 1)
endef

define CLEAN_TEMPLATE
	$(MAKE) -C $(1) clean

endef
clean:
	$(foreach VAR,$(SUBDIRS),$(call CLEAN_TEMPLATE,$(VAR)))

$(HOME)/%: etc/skel/%
	cp $< $@

vundle-install: $(VUNDLE_INSTALL)

$(VUNDLE_INSTALL): $(HOME)/.vimrc
	@rm -rf $(@D)
	git clone --depth 1 https://github.com/gmarik/Vundle.vim.git $(@D)
	vim '+:PluginInstall' '+:qa' > /dev/null

home-setup: $(addprefix $(HOME)/,$(notdir $(wildcard etc/skel/.[!.]*))) $(VUNDLE_INSTALL)

cpanminus-install: $(CPANMINUS_INSTALL)

$(CPANMINUS_INSTALL): downloads/perl/cpanm
	$(call ROOT_TEST)
	perl $< App::cpanminus
	test -f $(CPANMINUS_INSTALL)
	touch -c $(CPANMINUS_INSTALL)

google-chrome-install: $(GOOGLE_CHROME_INSTALL)

$(GOOGLE_CHROME_INSTALL): downloads/google/google-chrome-stable_current_amd64.deb
	$(call ROOT_TEST)
	-dpkg -i $<
	apt-get install -yf
	dpkg -i $<
	touch -c $(GOOGLE_CHROME_INSTALL)

define SUBDIRS_TEMPLATE
$(1)/%:
	$$(MAKE) -C $(1) $$*

endef
$(foreach VAR,$(SUBDIRS),$(eval $(call SUBDIRS_TEMPLATE,$(VAR))))
