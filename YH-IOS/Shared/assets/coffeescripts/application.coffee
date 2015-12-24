#encoding: utf-8
window.App =
  showLoading: ->
    $(".loading").removeClass("hidden")

  showLoading: (text) ->
    $(".loading").html(text)
    $(".loading").removeClass("hidden")

  hideLoading: ->
    $(".loading").addClass("hidden")
    $(".loading").html("loading...")

  params: (type) ->
    obj = {}
    keys = []
    values = []
    pairs = window.location.search.substring(1).split("&")
    for i of pairs
      continue  if pairs[i] is ""
      pair = pairs[i].split("=")
      key = decodeURIComponent(pair[0])
      value = decodeURIComponent(pair[1])
      keys.push(key)
      values.push(value)
      obj[key] = value

    if(type == "key")
      return keys
    else if(type == "value")
      return values
    else 
      return obj

  removeGlyphicon: ->
    $(".dropdown-menu i.glyphicon").remove()
    $(".dropdown-menu a").each ->
      $(this).text($.trim($(this).text()))

  # checkbox operation
  checkboxState: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      return false
    else
      return true

  checkboxChecked: (self) ->
      $(self).attr("checked", "true")

  checkboxUnChecked: (self) ->
      $(self).removeAttr("checked")

  checkboxState1: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
      return true
    else
      $(self).removeAttr("checked")
      return false

  reloadWindow: ->
    window.location.reload()

  cpanelNavbarInit: ->
    pathname = window.location.pathname
    klass = "." + pathname.split("/").join("-")
    console.log(klass)
    $(klass).siblings("li").removeClass("active")
    $(klass).addClass("active")

  resizeWindow: ->
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;

    nav_height    = 80 || $("nav:first").height()
    footer_height = 100 || $("footer:first").height()
    main_height   = y - nav_height - footer_height
    if main_height > 300
      $("#main").css
        "min-height": main_height + "px"

  initBootstrapNavbarLi: ->
    # navbar-nav active menu
    pathname = window.location.pathname
    navbar_right_lis = $("#navbar_right_lis").val() || 1
    navbar_lis = $(".navbar-nav:first li, .navbar-right li:lt("+navbar_right_lis+")")
    is_match = false
    navbar_lis.each ->
      href = $(this).children("a:first").attr("href")
      if pathname is href
        $(this).addClass("active")
        is_match = true
      else
        $(this).removeClass("active")


  initBootstrapPopover: ->
    $("body").popover
      selector: "[data-toggle=popover]"
      container: "body"

  initBootstrapTooltip: ->
    $("body").tooltip
      selector: "[data-toggle=tooltip]"
      container: "body"

# NProgress
NProgress.configure
  speed: 500
#$.getScript "/javascripts/js_util.js", ->
#  console.log("load /javascripts/js_util.js successfully.")
$ ->
  NProgress.start()
  App.resizeWindow()
  NProgress.set(0.2)
  App.initBootstrapPopover()
  NProgress.set(0.4)
  App.initBootstrapTooltip()
  NProgress.set(0.8)
  App.initBootstrapNavbarLi()
  NProgress.done(true)

  currentDate = new Date();
  copyInfo = "&copy; " + currentDate.getFullYear() + " " + window.location.host;
  $("#footer .footer").html(copyInfo);
