# ### Defining the prompt
function fish_prompt
  echo
  # line 1: "{hostname} {·|⒟} {Ruby version} · {current path}"
  set_color purple
  echo -n ( hostname -s )" · "

  if test $RUBY_VERSION
    set_color yellow
    echo -n $RUBY_VERSION

    set_color normal
    echo -n " · "
  end

  set_color green
  pwd | sed 's@'"$HOME"'@~@'

  # line 2: "[virtual env]({current git branch}) ➔ "
  if set -q VIRTUAL_ENV
    set_color green
    echo -n "["( basename "$VIRTUAL_ENV" )"]"

    set_color normal
  end

  echo -n ( __fish_git_prompt )" "
  echo -n "➔ "
  set_color normal
end


# Ask for confirmation y/N
function read_confirm
  while true
    read -l -p read_confirm_prompt confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

function read_confirm_prompt
  echo 'Do you want to continue? [y/N] '
end


# ### Show my external IP address
function myip
  echo "My external IP:" ( curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+' )
end


# ### Show all React props in a given file
function get_react_props
  grep "this.props." $argv | tr "=,[](){}" "\n" | perl -lne '/^.*this\.props\.([a-z\d\.]+).*$/ig && print "$1: PropTypes.any,"' | sort | uniq
end


# ### "bundle exec" for node
function npm-exec
  set -lx PATH (npm bin) $PATH
  eval $argv
end


# Add homebrew folders to the path
set -gx PATH /usr/local/sbin $HOME/bin $PATH


# Add node folders to the path
if not contains /usr/local/share/npm/bin $PATH
  set -gx PATH $PATH /usr/local/share/npm/bin
end


# Postgres
set psql_path /Applications/Postgres.app/Contents/Versions/9.4/bin
if test -d $psql_path
  if not contains $psql_path $PATH
    set -gx PATH $PATH $psql_path
  end
end


# Android dev
if test -d $HOME/android-sdk-macosx
  if not contains $HOME/android-sdk-macosx/tools $PATH
    set -gx PATH $PATH $HOME/android-sdk-macosx/tools
    set -gx ANDROID_HOME "$HOME/android-sdk-macosx"
  end
end


# Java
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.7)


# ### Aliases
alias be "bundle exec"
alias dnsflush "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias gpull "git pull origin"
alias gpush "git push origin"
alias ll "ls -Gal"
alias ne "npm-exec"
alias serve "python -m SimpleHTTPServer"
alias t "tree --dirsfirst -C"
alias tmux "env TERM=xterm-256color tmux"
alias v "vagrant"


# ### chruby-fish
source /usr/local/share/chruby/chruby.fish
source /usr/local/share/chruby/auto.fish


# Set editor and git editor
if test -f /usr/local/bin/atom
  set -x EDITOR "/usr/local/bin/atom -w"
  set -x GIT_EDITOR '/usr/local/bin/atom -w'
else if -f /usr/local/bin/subl
  set -x EDITOR "/usr/local/bin/subl -w"
  set -x GIT_EDITOR '/usr/local/bin/subl -w'
end


# Python virtualenv wrapper
# eval (python -m virtualfish 2>&1 >> /dev/null)
