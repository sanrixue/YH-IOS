#!/usr/bin/env ruby
# encoding: utf-8
require 'settingslogic'
require 'active_support/core_ext/string'

class Settings < Settingslogic
  source 'config/config.yaml'
end

File.open('.pgyer_upload.sh', 'w:utf-8') do |file|
  file.puts <<-EOF.strip_heredoc
  #!/usr/bin/env bash

  desktop_path=~/Desktop
  project_name=YH-IOS
  ipa_path=$(find ${desktop_path} -name "${project_name}.ipa" | sort | tail -n 1)

  pgyer_user_key="#{Settings.pgyer.user_key}"
  pgyer_api_key="#{Settings.pgyer.api_key}"

  if test -f "${ipa_path}"
  then
    echo ${ipa_path}
    curl -F "file=@${ipa_path}" -F "uKey=${pgyer_user_key}" -F "_api_key=${pgyer_api_key}" http://www.pgyer.com/apiv1/app/upload
  else
    echo "not find ipa file in: ${desktop_path} with ${ipa_path}"
  fi
  EOF
end

puts `/bin/bash .pgyer_upload.sh`