#!/bin/bash

desktop_path=/Users/lijunjie/Desktop
project_name=YH-IOS
ipa_path=$(find ${desktop_path} -name "${project_name}.ipa" | sort | tail -n 1)

pgyer_user_key="f6e103c159fc1ad745b154de23970e96"
pgyer_api_key="45be6d228e747137bd192c4c47d4f64a"

if test -f "${ipa_path}"
then
  echo ${ipa_path}
  curl -F "file=@${ipa_path}" -F "uKey=${pgyer_user_key}" -F "_api_key=${pgyer_api_key}" http://www.pgyer.com/apiv1/app/upload
else
  echo "not find ipa file in: ${desktop_path} with ${ipa_path}"
fi