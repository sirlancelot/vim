# Installation

Install on Unix-based machines:

    git clone https://github.com/sirlancelot/vim.git ~/.vim
    ./extra/install.sh

You do not need to link `gvimrc.vim` as it is loaded at the bottom of `vimrc.vim`

Install on other platforms: just copy or link `vimrc.vim` to your
home directory and call it `.vimrc`

If you want tags of just my settings (no plugins):

    ctags -R bundle/_/ *.vim

## Plugins used

All plugins are placed in the `bundle/` subfolder and are git submodules.
Rather than clutter up the `.vim` root folder, my personal additions have been
placed either in the `*vimrc.vim` or `bundle/_`

  - [Fugitive](https://github.com/tpope/vim-fugitive)
  - [FuzzyFinder](https://github.com/slack/vim-fuzzyfinder)
  - [Git](https://github.com/tpope/vim-git) *updated runtime for Fugitive*
  - [Jekyll](https://github.com/csexton/jekyll.vim)
  - [L9](https://github.com/vim-scripts/L9) *dependency of FuzzyFinder*
  - [MiniBufEplorer](https://github.com/fholgado/minibufexpl.vim)
  - [Supertab](https://github.com/ervandew/supertab)
  - [Surround](https://github.com/tpope/vim-surround)

# Key Mappings

Leader Key: ,

# Mac Terminal Settings

If the <Home> and <End> keys aren't working for you in Console Vim, you need to
add the following changes to your Terminal Preferences Keyboard Settings:

  - Key: `Home`, Escape Sequence: `\033OH`
  - Key: `End`, Escape Sequence: `\033OF`

Note: `\033` is typed by pressing <Escape> when the cursor is in the text box.
