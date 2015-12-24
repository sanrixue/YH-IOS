(function(){
    window.Spinner = {
      init: function() {
        var body = document.getElementsByTagName("body")[0];
        body.innerHTML += '<div class="spinner">\
                              <div class="rect1"></div>\
                              <div class="rect2"></div>\
                              <div class="rect3"></div>\
                              <div class="rect4"></div>\
                              <div class="rect5"></div>\
                            </div>';
      },
      remove: function() {
        var spinners = document.getElementsByClassName("spinner");
        for(var index = 0; index < spinners.length; index++) {
          spinners[index].remove();
        }
      }
    }
}).call(this);