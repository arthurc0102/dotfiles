echo "Install Pipx"
export PYTHONUSERBASE=/tmp/pip-tmp
export PIP_CACHE_DIR=/tmp/pip-tmp/cache
pip3 install --disable-pip-version-check --no-warn-script-location --no-cache-dir --user pipx
/tmp/pip-tmp/bin/pipx install --pip-args=--no-cache-dir pipx
rm -rf /tmp/pip-tmp
