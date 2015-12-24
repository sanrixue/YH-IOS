#encoding: utf-8
window.Home=
  input_subscribe_monitor: (input) ->
    if $(input).val().trim()
      $(input).siblings("input[type='submit']").removeAttr("disabled")
    else
      $(input).siblings("input[type='submit']").attr("disabled","disabled") 

$ ->
  $subscribe = $("#subscribe")  
  # detect the change
  Home.input_subscribe_monitor($subscribe)
  $subscribe.bind "change keyup input", ->
    Home.input_subscribe_monitor(this)

