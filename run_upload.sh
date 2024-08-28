#!/bin/bash

#rm -rf .git
git add *
git add .readthedocs.yaml
git add .gitignore
git status
git commit -m "modify"
git remote remove origin
git remote add origin git@github.com:Pxx-X/NOTEBOOOOK.git 
git push -u origin +master
