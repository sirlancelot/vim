# Installation on *nix

    git clone https://github.com/sirlancelot/vim.git ~/.vim
	git submodule update --init
	ln -s .vim/vimrc.vim ~/.vimrc

You do not need to link `gvimrc.vim` as it is loaded at the bottom of `vimrc.vim`

## Plugins used

All plugins are placed in the `bundle/` subfolder and are git submodules.
Rather than clutter up the `.vim` root folder, my personal additions have been
placed either in the `*vimrc.vim` or `bundle/_`

  - [Fugitive](https://github.com/tpope/vim-fugitive)
  - [FuzzyFinder](https://github.com/slack/vim-fuzzyfinder)
  - [L9](https://github.com/vim-scripts/L9) *dependency of FuzzyFinder*
  - [Supertab](https://github.com/ervandew/supertab)
  - [Surround](https://github.com/tpope/vim-surround)

# Key Mappings

Leader Key: ,
