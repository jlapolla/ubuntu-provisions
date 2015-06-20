#Ubuntu Provisions

Configuration files for Ubuntu, and GNU Make rules for common download, build, and installation tasks.

##Configuration Files

Configuration files are stored under the `etc/skel` directory.

##GNU Make Targets

We recommend running make targets as a regular user. Only use `sudo` when specifically instructed to.

###Targets in Project Root Directory

* home-setup: Update files in home directory from `etc/skel`.
* vundle-install: Install Vundle (plugin manager for Vim) in home directory, and install Vim plugins listed in `etc/skel/.vimrc`.
* cpanminus-install: Install cpanminus (package manager for Perl) globally.
* google-chrome-install: Install Google Chrome (web browser) globally.
* nodejs-install: Install Node.js (JavaScript engine) globally.

###Targets in the `build` Directory

* httpd-install: Build Apache HTTP Server (web server) and install globally.
* httpd-dist.tar.gz: Build Apache HTTP Server (web server) and create binary package.
* nodejs-install: Build Node.js (JavaScript engine) and install globally.
* nodejs-dist.tar.gz: Build Node.js (JavaScript engine) and create binary package.

###Example

To install configuration files in your home directory, run:

```sh
make home-setup
```

##Feedback

Please leave feedback by opening an issue.
