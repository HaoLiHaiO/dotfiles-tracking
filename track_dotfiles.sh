function trackAliases() {
  echo Where do you keep your dot files?
  read dotfiles_directory

  DIR="$HOME/$dotfiles_directory/"

  echo Which dot file do you want to track?
  read dotfile_to_track

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
  echo Go to directory? y/n
  read gotodir
  if [[ gotodir == "y" ]]; then
    cd $DIR
  fi
}