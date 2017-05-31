(function(){

    window.IOSBridge = {
      connectWebViewJavascriptBridge: function(callback) {
        if(window.WebViewJavascriptBridge) {
          callback(WebViewJavascriptBridge)
        }
        else {
          document.addEventListener('WebViewJavascriptBridgeReady', function() {
            callback(WebViewJavascriptBridge)
          }, false)
        }
      },
      pageLink: function(bannerName, link, objectId) {
        //alert(bannerName)

        IOSBridge.connectWebViewJavascriptBridge(function(bridge){
          bridge.callHandler('iosCallback', {'bannerName': bannerName, 'link': link, 'objectID': objectId}, function(response) {});
        })
      },
      writeComment: function() {
        var content = document.getElementById("content").value.trim();

        if(content.length > 0) {
          IOSBridge.connectWebViewJavascriptBridge(function(bridge){
            bridge.callHandler('writeComment', {'content': content}, function(response) {
            });
          })
        }
        else {
          alert("请输入评论内容");
        }
      },
      storeTabIndex: function(pageName, tabIndex) {
        IOSBridge.connectWebViewJavascriptBridge(function(bridge){
          bridge.callHandler('pageTabIndex', {'action': 'store', 'pageName': pageName, 'tabIndex': tabIndex}, function(response) {});
        })
      },
      restoreTabIndex: function(pageName) {
        IOSBridge.connectWebViewJavascriptBridge(function(bridge){
          bridge.init(function(message, responseCallback) {
          })
          bridge.callHandler('pageTabIndex', {'action': 'restore', 'pageName': pageName}, function(response) {
            var tabIndex = response;
            var klass = ".tab-part-" + tabIndex;
            $(".tab-part").addClass("hidden");
            $(klass).removeClass("hidden");

            $(".day-container").removeClass("highlight");
            $(".day-container").each(function(){
              var eIndex = parseInt($(this).data("index")) ;
              if(eIndex === tabIndex) {
                $(this).addClass("highlight");
              }
            })
          });
        })
      }
    }
}).call(this)