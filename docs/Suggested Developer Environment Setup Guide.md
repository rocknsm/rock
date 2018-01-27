# Suggested Developer Environment Setup Guide

## Use Linux or Mac as your operating system.
* The computer used to develop with should be able to install Ansible. Unfortunately, Windows is not supported at the time of this writing.
* Having Ansible installed on your developer machine allows you to run the playbooks from your machine to remote machines. This means you can also make changes to the playbooks without needing to copy the changes to the remote system.
* If you still want to use Windows (which is totally fine) you will need to use a Linux/Mac OS machine that has Ansible installed to be able to deploy Rock

## Install [Atom](https://atom.io/), the preferred text editor
* Atom is an open source text editor that is supports Linux, Mac, and Windows.
* Atom has a built-in package manager that gives you access to several packages
* Atom has a built-in file system browser allowing you to quickly open and close files
* Atom has a spell checker, auto-completion, multiple panes, and a powerful find and replace  

## Install these packages in Atom:
* To install packages and themes, open Atom and navigate to Packages -> Settings View -> Install Packages/Themes
* autocomplete-ansible - Helps write Ansible files, the core source code type of Rock
* sublime-style-column-selection - Allows quick editing of multiple lines at once.

## Install [GitKraken](https://www.gitkraken.com/) to manage your GitHub projects
* GitKraken is a git GUI client for Linux, Mac, and Windows
* GitKraken removes the learning curve with git, provides an easy to use interface, and also gives you a visual representation of the git commit history
* GitKraken provides a great interface for comparing changes between commits, showing the differences between your local code and the committed code, and allows for picking and choosing which parts of the changes you wish to actually commit.
* Installation note: There is no rpm package available for download, which is what is used on Fedora, RedHat, and CentOS. If you are using one of these operating systems, download the Linux (Gzip) option, extract the archive and double click on the gitkraken binary inside the folder.

## Ideal git flow using GitHub and GitKraken
* If you have Ansible, Atom, GitKraken, and a SSH client, then you can follow this git flow:

  ![Git Flow](../images/Git%20Flow.png)
