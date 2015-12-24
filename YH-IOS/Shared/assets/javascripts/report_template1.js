(function(){
  window.ReportTemplate1 = {
    checkArrayForChart: function(array) {
        for(var index=0; index < array.length; index++) {
          if(array[index] == null) { array[index] = undefined; }
        }
        return array;
    },
    generateTable: function(heads, rows) {
      var headString = "<thead>";
      for(var index = 0; index < heads.length; index++) {
        headString += "<th>" + heads[index] + "</th>";
      }
      headString += "</thead>";


      var rowsString = "<tbody>";
      for(var row_index = 0; row_index < rows.length; row_index ++) {
        var row = rows[row_index]

        var rowString = "";
        var is_root = (row[0] === 1 || row[0] === "1");
        for(var data_index = 1; data_index < row.length; data_index ++) {
          var data = row[data_index];
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
                                  + ReportTemplate1.generateTable(tab.table.head, tab.table.data) +
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
                  <span class='databox-number lightcarbon'> " 
                    + template.banner.title + "\
                  </span>\
                  <span class='databox-number sonic-silver no-margin'>"
                    + template.banner.subtitle + "\
                  </span>\
                  \
                  <div class='databox-stat bg-gray radius-bordered'>\
                    <div class='stat-text'>"
                      + template.banner.date + "\
                    </div>\
                  </div>\
                </div>\
              </div>\
            </div>\
          </div>\
      </div>"
      + (template.is_show_chart !== "undefined" && template.is_show_chart === true ? "\
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
        if(template.is_show_chart !== "undefined" && template.is_show_chart === true) {
          var chart = echarts.init(document.getElementById("template_chart_" + index));
          chart.setTheme('macarons');
          chart.setOption(ReportTemplate1.generateChart(template.chart));
        }

        if(index !== 0) {
          $(".tab-part-"+index).addClass("hidden");
        }
      }
    }
  }

}).call(this)
