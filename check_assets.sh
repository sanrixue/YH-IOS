#!/bin/bash
#
# check assets.zip with server
# 2016-02-24 by jay
# 

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "this script only run on Darwin"
    exit
fi

current_assets_path="YH-IOS/Shared/assets.zip"
server_assets_path="../../work/YH-Server/public/assets.zip"

function exit_with_info {
  echo "$1 not exist"
  exit
}

test -e ${server_assets_path} || exit_with_info ${server_assets_path}
test -e ${current_assets_path} || exit_with_info ${current_assets_path}

current_assets_md5=$(md5 ${current_assets_path} | cut -d = -f 2)
server_assets_md5=$(md5 ${server_assets_path} | cut -d = -f 2)

if [[ "${current_assets_md5}" == "${server_assets_md5}" ]]; then
  echo "current equal server: ${current_assets_md5}"
else
  echo "diff - current: ${current_assets_md5}, server: ${server_assets_md5}"
  echo "copy server to current asset file"
  cp ${server_assets_path} ${current_assets_path}

  ./check_assets.sh
fi

