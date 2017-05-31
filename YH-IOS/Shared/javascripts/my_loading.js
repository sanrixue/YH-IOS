window.Loading = {
  setState: function(state) {
    if(state === 'show') {
      $(".loading").removeClass("hidden");
    } else {
      $(".loading").addClass("hidden");
    }
  },
  show: function(text) {
    window.Loading.makeSureLoadingExist();

    $(".loading").html(text);
    window.Loading.makeSureCenterHorizontal();
    window.Loading.setState('show');
  },
  hide: function() {
    window.Loading.setState('hide');
  },
  makeSureLoadingExist: function(type) {
    if($(".loading").length === 0) {
      $("body").append('<div class="loading hidden">loading...</div>');
    }
  },
  popup: function(text) {
    window.Loading.makeSureLoadingExist();

    $(".loading").html(text);
    window.Loading.setState('show');
    window.Loading.makeSureCenterHorizontal();
    $(".loading").slideDown(1000, function() {
      $(this).slideUp(1000);
    })
  },
  makeSureCenterHorizontal: function() {
    var window_width = $(window).width(),
        loading_width = $(".loading").width(),
        left_width = (window_width - loading_width)/2;
    // console.log('window_width:' + window_width + ', loading_width:' + loading_width+ ', left_width:' + left_width);
    $(".loading").css({"left": left_width, "margin-left": '0px'});
  }
}
