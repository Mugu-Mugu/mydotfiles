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
	config_install_emacs
}

function config_install_emacs { 
	if [ ! -d $HOME/.emacs.d ]; then
		git clone https://github.com/Mugu-Mugu/.emacs.d/
	else
	    echo "emacs already installed"
	fi
}

function config_install_dependencies { 
    DEPENDENCIES = "vim emacs"
	sudo apt install $DEPENDENCIES
}
