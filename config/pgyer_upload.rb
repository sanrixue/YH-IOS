#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'settingslogic'
require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

current_app = ''
unless File.exist?('.current-app')
  puts %(Abort: .current-app not exist)
  exit
end

ipa_path = `find ~/Desktop -name "YH-IOS.ipa" | sort | tail -n 1`.strip
puts ipa_path
unless File.exist?(ipa_path)
  puts %(Abort: ipa not found - #{ipa_path})
  exit
end

puts %(- done: generate apk(#{File.size(ipa_path)}) - #{ipa_path})
current_app = IO.read('.current-app').strip
NAME_SPACE = current_app # TODO: namespace(variable_instance)
class Settings < Settingslogic
  source 'config/config.yaml'
  namespace NAME_SPACE
end

response = `curl --silent -F "file=@#{ipa_path}" -F "uKey=#{Settings.pgyer.user_key}" -F "_api_key=#{Settings.pgyer.api_key}" http://www.pgyer.com/apiv1/app/upload`

hash = JSON.parse(response).deep_symbolize_keys[:data]
puts %(- done: upload apk to #pgyer#\n\t#{hash[:appName]}\n\t#{hash[:appIdentifier]}\n\t#{hash[:appVersion]}(#{hash[:appVersionNo]})\n\t#{hash[:appQRCodeURL]})
