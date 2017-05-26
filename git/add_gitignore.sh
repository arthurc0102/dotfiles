#!/bin/bash
# Download gitignore from: https://github.com/github/gitignore

if [ "$1" == "" ]; then
    echo "No kind input."
    exit
fi

res=$(curl -s https://raw.githubusercontent.com/github/gitignore/master/$1.gitignore)

if [ "$res" == "404: Not Found" ]; then
    echo "Can not find this kind of gitignore."
    exit
fi

echo -e "$res" > .gitignore
echo "Add $1's ignore success."
