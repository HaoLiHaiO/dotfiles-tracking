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