if [ $# == 1 ]; then
  chromium ${1} & >> /dev/null &
else
  echo "You have to input a markdown file"
fi
