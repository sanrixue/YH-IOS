#!/usr/bin/env bash

##############################################################################
##
##  Script switch YH-IOS apps for UN*X
##
##############################################################################

check_assets() {
    local shared_path="YH-IOS/Shared/"

    if [[ -z "$1" ]];
    then
        echo "ERROR: please offer assets filename"
        exit
    fi

    local filename="$1.zip"
    local filepath="$shared_path/$filename"
    local url="http://120.132.68.21:8080/api/v1/download/$1.zip"

    echo -e "\n## $filename\n"
    local status_code=$(curl -s -o /dev/null -I -w "%{http_code}" $url)

    if [[ "$status_code" != "200" ]];
    then
        echo "ERROR: $status_code - $url"
        exit
    fi
    echo "- http response 200."

    curl -s -o $filename $url
    echo "- download $([[ $? -eq 0 ]] && echo 'successfully' || echo 'failed')"

    local md5_server=$(md5 ./$filename | cut -d ' ' -f 4)
    local md5_local=$(md5 ./$filepath | cut -d ' ' -f 4)

    if [[ "$md5_server" = "$md5_local" ]];
    then
        echo "- not modified."
        test -f $filename && rm $filename
    else
        mv $filename $filepath
        echo "- $filename updated."
    fi
}

case "$1" in
    yonghui|shengyiplus|qiyoutong|yonghuitest|test)
        # bundle exec ruby config/app_keeper.rb --plist --assets --constant
        bundle exec ruby config/app_keeper.rb --app="$1" --plist --assets --constant
    ;;
    assets:check)
        check_assets "BarCodeScan"
        check_assets "advertisement"
        check_assets "assets"
        check_assets "fonts"
        check_assets "images"
        check_assets "javascripts"
        check_assets "stylesheets"
        check_assets "loading"
        check_assets "icons"
    ;;
    *)
        test -z "$1" && echo "current app: $(cat .current-app)" || echo "unknown argument - $1"
    ;;
esac

case "$1" in
  shengyiplus|qiyoutong|test)
      # bundle exec ruby config/app_keeper.rb --plist --assets --constant
      bundle exec ruby config/app_keeper.rb --app="$1" --plist --assets --constant
      #downloadassets="http://123.56.91.131:8090"
  ;;
  yonghuitest)
     bundle exec ruby config/app_keeper.rb --app="$1" --plist --assets --constant
     downloadassets="https://development.shengyiplus.com"
  ;;
  yonghui)
     bundle exec ruby config/app_keeper.rb --app="$1" --plist --assets --constant
     downloadassets="https://yonghui.idata.mobi"
  ;;
  pgyer)
      bundle exec ruby config/app_keeper.rb --app="$(cat .current-app)" --pgyer
  ;;
  view)
    bundle exec ruby config/app_keeper.rb --view
  ;;
  all)
      echo 'TODO'
  ;;
  del:entitle)
      project=YH-IOS.xcodeproj/project.pbxproj
      sed -i '.bak' /CODE_SIGN_ENTITLEMENTS/d YH-IOS.xcodeproj/project.pbxproj
      diff ${project} ${project}.bak
      mv ${project}.bak build/
  ;;
  git:push)
      git_current_branch=$(git rev-parse --abbrev-ref HEAD)
      git push origin ${git_current_branch}
  ;;
  git:pull)
      git_current_branch=$(git rev-parse --abbrev-ref HEAD)
      git pull origin ${git_current_branch}
  ;;
  *)
      test -z "$1" && echo "current app: $(cat .current-app)" || echo "unknown argument - $1"
  ;;
esac
