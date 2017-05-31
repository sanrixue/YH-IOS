(function() {
  window.Home = {
    input_subscribe_monitor: function(input) {
      if ($(input).val().trim()) {
        return $(input).siblings("input[type='submit']").removeAttr("disabled");
      } else {
        return $(input).siblings("input[type='submit']").attr("disabled", "disabled");
      }
    }
  };

  $(function() {
    var $subscribe;
    $subscribe = $("#subscribe");
    Home.input_subscribe_monitor($subscribe);
    return $subscribe.bind("change keyup input", function() {
      return Home.input_subscribe_monitor(this);
    });
  });

}).call(this);
