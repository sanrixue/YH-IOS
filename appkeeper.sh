#!/usr/bin/env bash

##############################################################################
##
##  Ruby switch YH-IOS apps for UN*X
##
##############################################################################

case "$1" in
  yonghui|shengyiplus|qiyoutong)
    bundle exec ruby config/app_keeper.rb "$1"
  ;;
  all)
    echo 'TODO'
  ;;
  *)
  test -z "$1" && echo "current app: $(cat .current-app)" || echo "unknown argument - $1"
  ;;
esac