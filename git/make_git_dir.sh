if [ $# == 1 ]; then
  mkdir ${1}
  cd ${1}
  git init >> /dev/null
  echo "# "${1} >> README.md
  git add . >> /dev/null
  git commit -m "init" >> /dev/null
else
  echo "You have to enter a directory name"
fi
