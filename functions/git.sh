git-open() {
  url=$(git remote get-url origin) || return

  if [[ $url != http* ]]; then
    url="https://$(git remote get-url origin | awk -F '@' '{ print $2 }' | sed -e 's/:/\//g')"
  fi

  open_command "$url"
}
