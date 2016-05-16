export ZSH=/Users/wassim/.oh-my-zsh
ZSH_THEME="wassimk"
plugins=(git rails bundler brew vagrant)

# User configuration
export PATH="$PATH:/Users/wassim/.bin:/Users/wassim/.rvm/gems/ruby-2.2.3/bin:/Users/wassim/.rvm/gems/ruby-2.2.3@global/bin:/Users/wassim/.rvm/rubies/ruby-2.2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/wassim/.rvm/bin:/Users/wassim/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin"

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs
# plugins, and themes. Aliases can be placed here.
# For a full list of active aliases, run `alias`.
alias lsh='ls -d .*'
alias lsa='ls -laF'

# Functions
# Auto complete for code directory
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# Auto complete for home directory
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# Console based weather report, way cool
function weather() {
    if [ "$1" != "" ]
    then
        curl wttr.in/${1}
    else
        curl wttr.in/74041
    fi
}

# Node Version Manager
export NVM_DIR="/Users/wassim/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
