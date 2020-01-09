#!/bin/bash

function config {
   git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@
}

function config_bootstrap {
	git clone --bare --recursive https://github.com/Mugu-Mugu/mydotfiles.git $HOME/.dotfiles.git
	config checkout
	if [ $? = 0 ]; then
		echo "Checked out config.";
	else
		echo "Backing up pre-existing dot files.";
		mkdir -p .config-backup
		config checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
	fi;
	config checkout
	config config status.showUntrackedFiles no
	config_install_emacs_dotfiles
	config_install_all
}

function config_install_emacs_dotfiles {
	if [ ! -d $HOME/.emacs.d ]; then
		git clone https://github.com/Mugu-Mugu/.emacs.d/
	else
	    echo "emacs already installed"
	fi
}

function _config_install_from_deb {
     curl -L $1 -o /tmp/tmp.deb
     sudo dpkg -i /tmp/tmp.deb
}

function _config_install_fzf {
    curl -L  https://github.com/junegunn/fzf-bin/releases/download/0.18.0/fzf-0.18.0-linux_amd64.tgz -o /tmp/fzf.tgz
    (cd ~/bin/; tar xvzf /tmp/fzf.tgz)
}

function _config_install_emacs {
	rm -rf /tmp/emacs
	sudo apt install libgtk-3-dev libxpm-dev libjpeg-dev libgif-dev libtiff-dev gnutls-bin gnutls-dev libncurses-dev libxml2-dev libjansson-dev libvterm-dev cmake libtool-bin
	git clone https://git.savannah.gnu.org/git/emacs.git /tmp/emacs
	cd /tmp/emacs && ./autogen.sh && ./configure --with-modules --with-json --with-cairo && make
	sudo make install
	cd -
}

# utilities that can't be installed through apt
function _config_install_special_packages {
    _config_install_from_deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
    _config_install_from_deb https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-musl_7.3.0_amd64.deb
    _config_install_fzf
    _config_install_emacs
}

function config_install_all {
	sudo apt install built-essential automake autoconf texinfo
	_config_install_special_packages
}
