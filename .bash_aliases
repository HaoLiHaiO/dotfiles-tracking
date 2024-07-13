################################################################################
# golang
################################################################################

alias gi='goimports -w -v .'

alias gb='go build'
alias gr='go run'
alias gins='go install'
alias gtest='go test'
alias gvet='go vet'
alias gf='go fmt'
alias gdoc='godoc -http=:6060'
alias gmodtidy='go mod tidy'
alias gmodvendor='go mod vendor'
alias gclean='go clean -cache -modcache -i -r'
alias gg='go get -u'
alias ggv='go get'
alias gmodu='go get -u ./... && go mod tidy'
alias gstatic='staticcheck ./...'
alias gdocs='godoc -http=:6060'
alias glint='golangci-lint run'
alias ggen='go generate ./...'
alias gtestv='go test -v ./...'
alias gmodinit='go mod init $(basename $(pwd))'

benchmark() {
  go test -bench=. $@
}


function gocover() { 
  t=$(tempfile)
  go test $COVERFLAGS -coverprofile=$t $@ && go tool cover -func=$t && unlink $t
}

function coverweb() {
  t=$(tempfile)
  go test $COVERFLAGS -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

################################################################################
# SonarQube
################################################################################

# mount current working directory as a volume at /usr/src where sonar-scanner
# is looking for source code.

alias sonar-scanner='docker run --rm -v "$(pwd):/usr/src" sonar-scanner-cli'

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
alias gras='git rebase --autostash'
alias gri='git rebase --interactive'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias grv='git remote -v'
alias greh='git reset --hard'
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
alias ll='ls -lA'
alias la='ls -aF'
alias lt='ll --human-readable --size -1 -S --classify'
alias sbr='source ~/.bashrc'
alias lshr='du -ah --max-depth 1'

function completeAlias() {
  echo "complete -F _complete_alias ${1}" >>~/.bash_completion
}

################################################################################
# openvpn
################################################################################

startvpn() {
    echo "Select a VPN location:"
    echo "1) Bordeaux"
    echo "2) Marseille"
    echo "3) Paris"
    echo "4) Zurich"

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1) config="NCVPN-FR-Bordeaux-UDP.ovpn" ;;
        2) config="NCVPN-FR-Marseille-UDP.ovpn" ;;
        3) config="NCVPN-FR-Paris-UDP.ovpn" ;;
        4) config="NCVPN-CH-Zurich-UDP.ovpn" ;;
        *) echo "Invalid choice"; return ;;
    esac

    sudo openvpn --config "/etc/openvpn/udp/$config" --daemon

    # Wait for a short duration to allow the VPN connection to establish.
    sleep 10

    # Check for tun or tap interface
    if ip link show | grep -qE 'tun|tap'; then
        echo "VPN connection seems to be established successfully."
    else
        echo "VPN connection failed or took too long to establish."
    fi
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
    cd $DIR
    pwd
  fi

  if [[ -d "$DIR/.git/" && pwd == "$DIR" ]]; then
    echo 'Would you like to add, commit and push the updated file(s)? y/n'
    read push_or_not
    if [[ $push_or_not == "y" ]]; then
      pushAll
    fi
  fi

  if [[ ! -d "$DIR/.git/" ]]; then
    echo Would you like to initiate a git repository?
    read init_git
    if [[ $init_git == "y" ]]; then
      git init
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
# Arch Linux
################################################################################

alias aur-list='pacman -Qqm'

function isRebootRequired() {
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	NOCOLOR='\033[0m'
	echo "CHECKING IF A REBOOT IS REQUIRED"
	echo "BEGINNING OF COMPARISON OF uname -r and file /boot/vmlinuz"
	NEXTLINE=0
	FIND=""
	for L in `file /boot/vmlinuz*`; do
		if [ ${NEXTLINE} -eq 1 ]; then
			FIND="${L}"
			NEXTLINE=0
		else
			if [ "${L}" = "version" ]; then NEXTLINE=1; fi
		fi
	done
	if [ ! "${FIND}" = "" ]; then
		CURRENT_KERNEL=`uname -r`
		if [ ! "${CURRENT_KERNEL}" = "${FIND}" ]; then
			echo -e "${RED}REBOOT YOUR COMPUTER NOW!! ${NOCOLOR}\n"
		else
			echo -e "${GREEN}No reboot required. ${NOCOLOR}\n"
		fi
	fi
}

# Purpose: This function is used to update any package from the Arch User
# Repository (AUR) on an Arch Linux system in a way that works for me.
# It first navigates to the home directory, then checks if a local repository
# of the given package exists.
# If it does, it pulls the latest changes from the remote repository and makes
# the package or just exits if no new changes are detected.
# If it doesn't, it clones the repository and makes the package.
# After the update is finished, it returns the user back to the Downloads directory.
function updateAur() {
  # Check if package name is provided
  if [ -z "$1" ]; then
    echo "Error: No package name provided. Usage: updateAur <package_name>"
    return 1
  fi
  
  # Define the package name
  local PACKAGE="$1"
  
  # Print a message to the user
  echo "Navigating to the home directory..."
  
  # Go to home directory
  cd $HOME
  
  # Define the download directory path
  local DL="$HOME/Downloads"
  
  # Define the Arch User Repository (AUR) URL
  local AUR="https://aur.archlinux.org"
  
  # Check if a local repository of the given package exists in the download
  # directory
  if [ -d "$DL/$PACKAGE" ]; then
      echo "Existing repository found, pulling latest changes..."
      
      # If it does, navigate to the repository
      cd "$DL/$PACKAGE"
      
      # Pull the latest changes
      git_output=$(git pull)
      
      # Check if there are any new updates
      if [[ $git_output == *"Already up to date."* ]]; then
        echo "Nothing to update for $PACKAGE. Going back to the Downloads directory..."
        cd $DL
        return 0
      fi
      
      # Build and install the package from the updated sources
      makepkg -si
  else
      # If it doesn't, print a message
      echo "No existing repository found, cloning..."
      
      # Clone the repository from the AUR
      git clone "$AUR/$PACKAGE.git" "$DL/$PACKAGE"
      
      # Navigate to the new repository
      cd "$DL/$PACKAGE"
      
      # Make the package
      makepkg -si
  fi

  # After the update is finished, print a message to the user
  echo "Update of $PACKAGE finished. Going back to the Downloads directory..."

  # Navigate back to the Downloads directory
  cd $DL
}



# Purpose: This function is used to update Google Chrome from the AUR on an
# Arch Linux system.
# It first navigates to the home directory, then checks if a local repository
# of Google Chrome exists.
# If it does, it pulls the latest changes from the remote repository.
# If it doesn't, it clones the repository and makes the package.
function updateChrome() {
  echo "Navigating to the home directory..." 
  cd $HOME
  local DL="$HOME/Downloads"
  local AUR="https://aur.archlinux.org"
  
  # Define the name of the Google Chrome repository
  local GC="google-chrome"
  
  # Check if a local repository of Google Chrome exists in the download
  # directory
  if [ -d "$DL/$GC" ]; then
      echo "Existing repository found, pulling latest changes..."
      # If it does, navigate to the repository
      cd "$DL/$GC"
      
      # Pull the latest changes
      git pull

      makepkg -si
  else
      echo "No existing repository found, cloning..."
      
      # Clone the repository from the AUR
      git clone "$AUR/$GC.git" "$DL/$GC"
      
      # Navigate to the new repository
      cd "$DL/$GC"
      
      # Make the package
      makepkg -si
  fi

  echo "Update finished. Going back to the Downloads directory..."
  cd $DL
}


function updateVscode() {
  echo "Going to the home directory"
  echo ""
  cd $HOME
  DL="$HOME/Downloads"

  if [ ! -d $DL ]; then
    mkdir $DL
  fi

  cd $DL
  AUR="https://aur.archlinux.org/"
  VSCODE="visual-studio-code-bin"
  echo "Starting to clone VSCODE-BIN AUR git"
  git clone "$AUR/$VSCODE.git"
  cd $VSCODE/
  makepkg -si
  cd ..
  echo ""
  echo "Removing now useless directory..."
  rm -rf "$VSCODE/"
}

function updateSlack() {
  echo "Going to the home directory"
  echo ""
  cd $HOME
  DL="$HOME/Downloads"

  if [ ! -d $DL ]; then
    mkdir $DL
  fi

  cd $DL
  AUR="https://aur.archlinux.org/"
  SLACK="slack-desktop"
  echo "Starting to clone Slack AUR git"
  git clone "$AUR/$SLACK.git"
  cd $SLACK/
  makepkg -si
  cd ..
  echo ""
  echo "Removing now useless directory..."
  rm -rf "$SLACK/"
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

dockersize() {
    if ! docker_output=$(docker manifest inspect -v "$1" 2>/dev/null); then
        echo "Error: Failed to fetch manifest for image '$1'. Please check if the image name is correct."
        return 1
    fi

    if ! jq_output=$(echo "$docker_output" | jq -c 'if type == "array" then .[] else . end' 2>/dev/null); then
        echo "Error: Failed to process JSON output. Ensure jq is correctly processing the manifest."
        return 1
    fi

    if ! size_output=$(echo "$jq_output" | jq -r '
        [ 
            ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), 
            ( [ .SchemaV2Manifest.layers[].size ] | add ) 
        ] | join(" ")' 2>/dev/null); then
        echo "Error: Failed to extract and process sizes from manifest. Check the structure of the manifest."
        return 1
    fi

    if ! formatted_output=$(echo "$size_output" | numfmt --to iec --format '%.2f' --field 2 2>/dev/null); then
        echo "Error: Failed to format sizes into human-readable format."
        return 1
    fi

    echo "$formatted_output" | sort | column -t
}




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
