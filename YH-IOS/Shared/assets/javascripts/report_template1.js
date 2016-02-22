(function(){
  window.ReportTemplate1 = {
    modal: function(ctl) {
        var date1 = new Date().getTime();

        var $modal = $("#ReportTemplate1Modal");
        $modal.modal("show");
        $modal.find(".modal-title").html($(ctl).data("title"));
        $modal.find(".modal-body").html($(ctl).data("content"));

        var date2 = new Date().getTime();
        var dif = date2 - date1;
        console.log("duration: " + dif);
    },
    outerApi: function(ctl) {
      var url = $(ctl).data("url");
      var split = url.indexOf("?") > 0 ? "&" : "?";
      url = url + split + $(ctl).data("params");

      var $modal = $("#ReportTemplate1Modal");
      $modal.modal("show");
      $modal.find(".modal-title").html($(ctl).data("title"));

      $.ajax({
        type: "GET",
        url: url, 
        success:function(result) {
          try {
              var json = JSON.parse(result);
              var table = "<table class='table'>\
              <tbody>";

              var regPhone1 = /^1\d{10}$/
              var regPhone2 = /^0\d{2,3}-?\d{7,8}$/
              var regEmail =  re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/
              for(var key in json) {
                var value = json[key];
                if(regPhone1.test(value) || regPhone2.test(value)) {
                  value = "<a class='sms' href='sms:" + value + "'>" + value + "</a>&nbsp;&nbsp;&nbsp;&nbsp;\
                  <a class='tel' href='tel:" + value + "'><span class='glyphicon glyphicon-earphone'></span></a>";
                }
                else if(regEmail.test(value)) {
                  value = "<a class='mail' href='mailto:'" + value + "'>" + value + "</a>";
                }
                table = table + "<tr><td>" + key + "</td><td>" +value + "</td></tr>";
              }
              table = table + "</tbody></table>";

              $modal.find(".modal-body").html(table);
          } catch (e) {
              console.log(e);
              $modal.find(".modal-body").html(result);
          }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown) {
              $modal.find(".modal-body").html("Get " + url + "<br>状态:" + textStatus + "<br>报错:" + errorThrown);
        }
      });
    },
    checkArrayForChart: function(array) {
        for(var index=0; index < array.length; index++) {
          if(array[index] == null) { array[index] = undefined; }
        }
        return array;
    },
    generateTable: function(heads, rows, outer_api) {
      var headString = "<thead>";
      for(var index = 0; index < heads.length; index++) {
        headString += "<th>" + heads[index] + "</th>";
      }
      headString += "</thead>";

      var is_outer_api = (typeof(outer_api) !== 'undefined');
      var rowsString = "<tbody>";
      for(var row_index = 0; row_index < rows.length; row_index ++) {
        var row = rows[row_index]

        var rowString = "";
        var is_root = (row[0] === 1 || row[0] === "1");
        for(var data_index = 1; data_index < row.length; data_index ++) {
          var data = row[data_index];

          if(is_outer_api && !is_root && outer_api.target === data_index) {
            data = "<a href='javascript:void(0);' onclick='ReportTemplate1.outerApi(this);' data-title='" + data + "' data-url='" + outer_api.url + "' data-params='" + outer_api.data[row_index] + "'>" + data + "</a>";
          }

          if(data_index === 1) {
            rowString += (is_root ? "\
              <tr>\
                <td>\
                  <a href='#' class='table-more table-more-closed'>" 
                    + data + 
                  "</a>\
                </td>"
                :
              "<tr class='more-items' style='display:none'> \
                <td>&nbsp;&nbsp;&nbsp;" 
                  + data + 
                "</td>");
          }
          else {
            rowString += "<td>" + data + "</td>";
          }
        }
        rowString += "</tr>";

        rowsString += rowString;
      }

      rowsString = rowsString + "</tbody>";

      return (headString + rowsString);
    },
    generateTabs: function(tabs) {
      var tab_index = (new Date()).valueOf();
      var navString = "<ul class='nav nav-tabs'>";
      for(var index = 0; index < tabs.length; index++) {
        navString += "<li class='" + (index === 0 ? "active" : "") + "'>\
                        <a data-toggle='tab' href='#tab_" + tab_index + "_" + index + "'>" + tabs[index].title + "</a>\
                      </li>";
      }
      navString += "</ul>";

      var contentString = "<div class='tab-content tabs-flat no-padding'>";
      for(var index = 0; index < tabs.length; index++) {
        var tab = tabs[index];

        contentString += "<div id='tab_" + tab_index + "_" + index + "' class='tab-pane animated fadeInUp " + (index === 0 ? "active" : "") + "'>\
                            <div class='row'  style='margin-left:0px;margin-right:0px'>\
                              <div class='col-lg-12' style='padding-left:0px;padding-right:0px'>\
                                <table class='table table-striped table-bordered table-hover'>"
                                  + ReportTemplate1.generateTable(tab.table.head, tab.table.data, tab.outer_api) +
                                "</table>\
                              </div>\
                            </div>\
                          </div>";
      }
      contentString += "</div>";

      return (navString + contentString);
    },

    // after require echart.js
    generateChart: function(option) {
      for(var index=0; index < option.series.length; index ++) {
          option.series[index].data = ReportTemplate1.checkArrayForChart(option.series[index].data);
      }

      return {
        tooltip : {
            trigger: 'axis'
        },
        legend: {
            x: 'center',
            y: 'top',
            data: option.legend
        },
        toolbox: {
            show : false,
            x: 'right',
            y: 'top',
            feature : {
                mark : {show: true},
                dataView : {show: true, readOnly: false},
                magicType : {show: true, type: ['line', 'bar']},
                restore : {show: true},
                saveAsImage : {show: false}
            }
        },
        calculable : true,
        grid: {y: 17, y2:20, x2:2, x:40},
        xAxis : [
            {
                type : 'category',
                boundaryGap : true,
                data : option.xAxis
            }
        ],
        yAxis : option.yAxis,
        series : option.series
      }; 
    },
    generateTemplate: function(index, template) {
      return "\
      <div class='row tab-part tab-part-" + index + "' style='margin-left:0px;margin-right:0px'>\
          <div class='col-lg-12 col-sm-12 col-xs-12' style='padding-left:0px;padding-right:0px'>\
            <div class='databox radius-bordered bg-white databox-shadowed' style='height:100%;'>\
              <div class='databox-row'>\
                <div class='databox-cell cell-12 text-align-center bordered-right bordered-platinum'>\
                  \
                  <div class='databox-stat bg-gray radius-bordered' style='left:7px;right:initial;'>\
                    <div class='stat-text'>"
                      + template.banner.date + "\
                    </div>\
                  </div>\
                  <span class='databox-number lightcarbon'> " 
                    + template.banner.title + "\
                  </span>\
                  <span class='databox-number sonic-silver no-margin'>"
                    + template.banner.subtitle + "\
                  </span>\
                  \
                  <div class='databox-stat '>\
                    <div class='stat-text'>\
                      <a href='javascript:void(0);' style='color:#ccc!important;' onclick='ReportTemplate1.modal(this);' data-title='" + template.banner.title + "' data-content='" + template.banner.info + "'>" + "\
                        <span class='glyphicon glyphicon-info-sign'></span>\
                      </a>\
                    </div>\
                  </div>\
                </div>\
              </div>\
            </div>\
          </div>\
      </div>"
      + (typeof(template.is_show_chart) !== "undefined" && template.is_show_chart === true ? "\
      <div class='row tab-part tab-part-" + index + "'  style='margin-left:0px;margin-right:0px'>\
        <div class='widget'>\
          <div class='widget-body'>\
            <div class='row'>\
              <div class='col-sm-12'  style='padding-left:0px;padding-right:0px'>\
                <div id='template_chart_" + index + "' class='chart chart-lg'></div>\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>" : "") 
      + "\
      <div class='row tab-part tab-part-" + index + "'  style='margin-left:0px;margin-right:0px'>\
        <div class='col-xs-12'  style='padding-left:0px;padding-right:0px'>\
          <div class='dashboard-box'>\
            <div class='box-tabbs'>\
              <div class='tabbable'>"
                + ReportTemplate1.generateTabs(template.tabs) + "\
              </div>\
              \
            </div>\
          </div>\
        </div>\
      </div>";
    }, 
    generateTemplates: function(templates) {

      var tabNav = document.getElementById("tabNav");
      var tabContent = document.getElementById("tabContent");

      var colNum = parseInt(12 / templates.length);
      for(var index = 0; index < templates.length; index ++) {
        var template = templates[index];

        tabNav.innerHTML += "\
          <div class='col-lg-" + colNum + " col-md-" + colNum + " col-sm-" + colNum + " col-xs-" + colNum + "'>\
            <a class='day-container " + (index === 0 ? "highlight" : "") + "' data-index=" + index + ">\
              <div class='day'>" 
                + template.title + "\
              </div>\
            </a>\
          </div>";

        tabContent.innerHTML += ReportTemplate1.generateTemplate(index, template);
      }

      for(var index = 0; index < templates.length; index ++) {
        var template = templates[index];
        if(typeof(template.is_show_chart) !== "undefined" && template.is_show_chart === true) {
          var chart = echarts.init(document.getElementById("template_chart_" + index));
          chart.setTheme('macarons');
          chart.setOption(ReportTemplate1.generateChart(template.chart));
        }

        if(index !== 0) {
          $(".tab-part-"+index).addClass("hidden");
        }
      }

      var modalHtml = '\
        <div class="modal fade in" id="ReportTemplate1Modal">\
          <div class="modal-dialog">\
            <div class="modal-content">\
              <div class="modal-header">\
                <button aria-label="Close" class="close" data-dismiss="modal" type="button">\
                  <span aria-hidden="true"> ×</span>\
                </button>\
                <h4 class="modal-title">...</h4>\
              </div>\
              <div class="modal-body">\
              loading...\
              </div>\
            </div>\
          </div>\
        </div>';

      $(modalHtml).appendTo($("body"));
    }
  }

}).call(this)
