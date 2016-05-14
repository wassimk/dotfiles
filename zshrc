export ZSH=/Users/wassim/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git rails bundler brew vagrant wassimk)

# User configuration
export PATH="$PATH:/Users/wassim/.rvm/gems/ruby-2.2.3/bin:/Users/wassim/.rvm/gems/ruby-2.2.3@global/bin:/Users/wassim/.rvm/rubies/ruby-2.2.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/wassim/.rvm/bin:/Users/wassim/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin"

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs
# plugins, and themes. Aliases can be placed here.
# For a full list of active aliases, run `alias`.
alias lh='ls -d .*'

# Node Version Manager
export NVM_DIR="/Users/wassim/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
