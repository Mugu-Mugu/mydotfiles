# Overview
Gather my configuration for:
* bash
* vim
* emacs

# To install
Just run the below scripts. Existing files are backuped if needed.

```bash
git clone --bare --recursive https://github.com/Mugu-Mugu/mydotfiles.git $HOME/.cfg
function config {
   git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | grep "^\s+" | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config submodule update --init --recursive
config submodule update --recursive
config config status.showUntrackedFiles no
```

Shamelessly copied from [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

