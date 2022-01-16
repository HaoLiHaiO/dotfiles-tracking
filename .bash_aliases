################################################################################
# git
################################################################################

alias ga='git add'
alias gaa='git add -A'
alias gba='git branch --all'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbn='git checkout -b'
alias gca='git-cz --amend'
alias gcan='git-cz --amend --no-edit'
alias gcann='git commit --amend --no-edit --no-verify'
alias gcl='git clone'
alias gcm='git commit -m'
alias gco='git checkout'
alias gc='git-cz'
alias gcr='git-cz --retry'
alias gd='git diff'
alias gdc='git diff --cached'
alias gfa='git fetch --all'
alias gl='git log --branches --remotes --tags --graph --oneline --decorate'
alias gp='git push'
alias gpf='git push -f'
alias gpsuo='git push --set-upstream origin'
alias gpu='git pull'
alias gpuff='git pull --ff-only'
alias gpur='git pull --rebase --autostash'
alias gpurm='git fetch --all && git pull --rebase --autostash origin master'
alias gpurmi='git fetch --all && git rebase --interactive --autostash origin/master'
alias gmm='git fetch --all && git merge origin/master'
alias gr='git rebase --autostash'
alias gri='git rebase --interactive'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias grv='git remote -v'
alias greh='git reset --hard'
alias gri='git rebase --interactive'
alias grsh='git reset --hard'
alias gs='git status'
alias gstl='git stash list'
alias gst='git stash'
alias gsts='git stash show'
alias gstp='git stash pop'
alias gstpi='git stash pop --index'
alias gsta='git stash apply'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'

function gln() {
  n=${1:-1}
  git log "-$n"
}

function gbDm() {
  for branch in $(gba | grep $1 | grep -v origin); do
    gbD $branch
  done
}

function pushAll() {
  echo What is your message?
  read commit_message
  gaa && gcm "$commit_message" && gp
}

################################################################################
# bash
################################################################################

alias cdr='cd $(git rev-parse --show-toplevel)'
alias changelang='setxkbmap -layout de,ch,us -option grp:alt_shift_toggle'
alias dfh='df -h'
alias freem='free -m'
alias gh='history | grep'
alias left='ls -t -1'
alias lt='ll --human-readable --size -1 -S --classify'
alias sbr='source ~/.bashrc'

function completeAlias() {
  echo "complete -F _complete_alias ${1}" >>~/.bash_completion
}

################################################################################
# MY SIMPLE CUSTOM IMPLEMENTATION TO TRACK DOTFILES WITHOUT OVERTHINKING
################################################################################

function trackAliases() {
  echo Going to home directory where dot files are kept
  cd $HOME
  pwd
  echo Where do you keep your dot files?
  read -e dotfiles_directory

  DIR="$HOME/$dotfiles_directory/"

  echo Which dot file do you want to track?
  read -e dotfile_to_track

  if [[ -d "$DIR" && ! -f "$DIR/$dotfile_to_track" ]]; then
    cp $HOME/$dotfile_to_track $DIR
    echo $dotfile_to_track has successfully been copied to selected directory.
  fi

  if [[ -d "$DIR" && -f "$DIR/$dotfile_to_track" ]]; then
    echo A file with the same already exists. Are you sure you want to overwrite it? y/n
    read is_user_sure
    if [[ $is_user_sure == "y" ]]; then
      cp $HOME/$dotfile_to_track $DIR
      echo $dotfile_to_track has successfully been copied to selected directory.
    else
      echo Operation aborted.
    #exit 1
    fi
  fi

  if [ ! -d "$DIR" ]; then
    mkdir $DIR
    cp $HOME/$dotfile_to_track $DIR
  fi

  echo ""
  echo Go to directory? y/n
  echo Necessary if you want to add, commit and push the files.
  read gotodir
  if [[ $gotodir == "y" ]]; then
    echo Hello
    echo $DIR
    cd $DIR
  fi

  if [[ ! -d "$DIR/.git/" ]]; then
    echo Would you like to initiate a git repository?
    read init_git
    if [[ $init_git == "y" ]]; then
      git init
    fi
  fi

  if [[ -d "$DIR/.git/" && pwd == "$DIR" ]]; then
    echo 'Would you like to add, commit and push the updated file(s)? y/n'
    read push_or_not
    if [[ $push_or_not == "y" ]]; then
      pushAll
    fi
  fi
}

function checkGit() {
  for d in */; do
    cd "$d"
    git status &>/dev/null

    if [ "$?" -ne 0 ]; then
      pwd
      echo "not a git repo"
    fi

    cd ..
  done
}

################################################################################
# nvim
################################################################################

alias vimdiff='nvim -d'

################################################################################
# gradle
################################################################################

function gw() {
  DIR=$(pwd)
  cd $(git rev-parse --show-toplevel)
  ./gradlew "$@"
  cd "$DIR"
}

################################################################################
# docker
################################################################################

alias d='docker'
alias dp='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dspa='docker system prune -a'
alias dsa='docker stop $(docker ps -q)'
alias dsta='docker start $(docker ps -qa)'
alias dra='docker stop $(docker ps -q); docker rm $(docker ps -qa)'
alias dei='docker exec -ti'

################################################################################
# docker-compose
################################################################################

alias dcu='docker-compose up -d'
alias dcd='docker-compose down'

function dcuf() {
  FILE=$1
  shift
  docker-compose -f $FILE up -d $@
}

function dcdf() {
  FILE=$1
  shift
  docker-compose -f $FILE down $@
}

################################################################################
# yadm
################################################################################

alias yms='yadm status'
alias yma='yadm add'
alias ymp='yadm push'
alias ymcm='yadm commit -m'
alias ymc='yadm commit -m'
alias ymd='yadm diff'
alias ymdc='yadm diff --cached'

function ymln() {
  yadm log "-$1"
}

################################################################################
# npm and npx
################################################################################

alias nc='npm-check'
alias npxts='npx tsc --init'

################################################################################
# yarn
################################################################################

alias y='yarn'
alias yadts='yarn add typescript @types/node @types/react @types/react-dom @types/jest'
alias yt='y && y test'
alias ytw='y && yarn test --watch'
alias yw='y && yarn watch'
alias ys='yarn && yarn start'
alias ysb='y && yarn start-storybook'
alias ytl='y && yarn test && yarn lint'
alias yc='yarn-check'
alias ycu='yarn-check -u'
alias ycz='yarn commit'

################################################################################
# tmux
################################################################################

alias t='tmux'
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias tk='tmux kill-session -t'

################################################################################
# erlang / elixir
################################################################################

alias iex='iex --erl "-kernel shell_history enabled"'

################################################################################
# code
################################################################################
alias co='code $(git rev-parse --show-toplevel)'
