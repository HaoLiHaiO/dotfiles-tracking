# Tracking files in a way I like

## Dotfile-tracking Function

The function is in the .bash_aliases.

I also put it in a separate file so that it can be appended to an existing .bashrc or .bash_aliases file conveniently with echo >>

## Purpose

- further automation
- very easy to use

## Features

- [ x ] check if file exists
- [ x ] ask user in which directory they keep their files
- - [ x ] if the folder does not exist, it is created
- - [ x ] if the folder exists and the file does not, it is created
- - [ x ] if both the folder and file exist, the user can choose to overwrite the existing tracked file or to abord the operation
- [ x ] ask user which file they want to track
- [ x ] user can go (cd) to directory or stay where they are

## Todo:

- [ ] add argument to copy / track more than one file
- [ ] check the return value of remote git repo, if not git repo, add the right remote repo and pull, then merge local changes with version from remote git repo and push everything back
- [ ] enable autocompletion