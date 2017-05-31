

if(typeof(window.ReportTemplateV2) === undefined) {
  alert("ERROR: undefined window.ReportTemplateV2");
}
console.log('template version: ' + window.ReportTemplateV2.version);

window.ReportTemplateV2.modal = function(ctl, type) {
  var date1 = new Date().getTime(),
      $modal = $("#ReportTemplateV2Modal");

  $modal.modal("show");
  console.log(type);

  if(type === 'info') {
    $modal.find(".modal-title").html($(ctl).data("title"));
    $modal.find(".modal-body").html($(ctl).data("content"));
  }
  else if(type === 'search') {
    $modal.find(".modal-title").html("选择门店");
    var items = [], itemName;
    for(var i = 0, len = window.TemplateDatas.length; i < len; i++) {
      itemName = window.TemplateDatas[i].name;
      items.push("<a href='javascript:void(0);' onclick='ReportTemplateV2.setSelectedItem(\"" + itemName + "\")'>" + itemName + "</a>");
    }

    $modal.find(".modal-body").html(items.join("<br>"));
  }
  else {
    console.log("unkown type: " + type);
  }
  var date2 = new Date().getTime(),
      dif = date2 - date1;
  console.log("duration: " + dif);
}
window.ReportTemplateV2.setSelectedItem = function(selectedItem) {
 $(document).attr("title", selectedItem);

  if(selectedItem && selectedItem.length) {
    window.TemplateDataConfig.selected_item = selectedItem;
    for(var i = 0, len = window.TemplateDatas.length; i < len; i ++) {
      if(window.TemplateDatas[i].name === selectedItem) {
        window.TemplateData.templates = window.TemplateDatas[i].data;
        break;
      }
    }
  }
  ReportTemplateV2.generateTemplates(window.TemplateData.templates);

  $(document).on("click","a.table-more",function(e) {
    e.preventDefault()
    var $this = $(this),
        $currentRow = $this.closest('tr');
        $currentRow.siblings(".tr-item-"+$(this).attr('data-id')).each(function(e){
          if($(this).is(":hidden")){
            if($(this).hasClass("hasChild") && !$(this).find('a.table-more').hasClass('table-more-closed')){
              $(this).siblings("tr[class='tr-item-"+$(this).find('a.table-more').attr('data-id')+" trthreelev']").show();
            }
            $(this).show();
          } else {
            if($(this).hasClass("hasChild") && !$(this).find('a.table-more').hasClass('table-more-closed')){
              $(this).siblings("tr[class='tr-item-"+$(this).find('a.table-more').attr('data-id')+" trthreelev'] ").hide();
            }
            $(this).hide();
          }
        });
    //$currentRow.nextUntil('tr[class!=more-items]').toggle();
    $this.toggleClass('table-more-closed');
  });

  $('a.day-container').click(function(el) {
    el.preventDefault();

    $(".day-container").removeClass("highlight");
    $(this).addClass("highlight");

    var tabIndex = $(this).data("index");
    var klass = ".tab-part-" + tabIndex;
    $(".tab-part").addClass("hidden");
    $(klass).removeClass("hidden");
    //ReportTemplateV2.caculateHeightForTable(klass);
  });

  $("#ReportTemplateV2Modal").modal("hide");
}

window.ReportTemplateV2.setSearchItems = function() {
  var items = [];
  for(var i = 0, len = window.TemplateDatas.length; i < len; i++) {
    items.push(window.TemplateDatas[i].name);
  }

  return items[0];
  // window.MobileBridge.setSearchItems(items);
}


window.onerror = function(e) {
  window.alert(e);
}
$(function() {
  var selectedItem = ReportTemplateV2.setSearchItems();
  ReportTemplateV2.setSelectedItem(selectedItem);
});

