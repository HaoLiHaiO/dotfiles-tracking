# Tracking files in a way I like

## Dotfile-tracking Function

The function is in the .bash_aliases.

I also put it in a separate file so that it can be appended to an existing .bashrc or .bash_aliases file conveniently with echo >>

**Reminder**

The function depends on some of my aliases, they should be appended too. If some aliases do not exist on the user's machine, bash will tell them which aliases are problematic when trying to source the updated dot file.

## Purpose

- further automation
- very easy to use

## Features

- [x] check if file exists
- [x] ask user in which directory they keep their files
- - [x] if the folder does not exist, it is created
- - [x] if the folder exists and the file does not, it is created
- - [x] if both the folder and file exist, the user can choose to overwrite the existing tracked file or to abord the operation
- [x] ask user which file they want to track
- [x] user can go (cd) to directory or stay where they are

## Todo:

- [ ] add argument to copy / track more than one file
- [ ] if .git folder exists in target folder, it is a git repo already
- - [ ] if the remote git repo is the right one: directly add, commit and push
- - [ ] if it is not the right one, ask the user to change the remote url
- - [ ] if it is not a git repo, ask the user if they want to git init, remote add origin and push upstream
- [ ] enable autocompletion
- [ ] add tests