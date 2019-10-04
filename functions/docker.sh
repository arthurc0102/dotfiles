docker-service() {
  if [ -z ${1} ] || [ ${1} = "list" ]; then
    echo "$(find ~/Docker/* -type d -maxdepth 0 -exec basename {} \;)"
    return
  fi

  docker-compose -f ~/Docker/${1}/docker-compose.yml ${@:2}
}
