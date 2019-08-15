#!/bin/bash

function _source_if_present {
	if [[ -f "$1" ]]; then
		source $1;
	fi
}

_source_if_present ~/.local.dotfiles/pre.bash
_source_if_present ~/.dotfiles/base.bash
_source_if_present ~/.dotfiles/sensible.bash
_source_if_present ~/.local.dotfiles/post.bash
_source_if_present ~/scripts/bootstrap.bash
