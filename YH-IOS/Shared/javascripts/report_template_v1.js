/* jslint plusplus: true */
/* global
     $:false, 
     ReportTemplateV1:false,
     TemplateData:false,
     echarts:false
*/
/*
  version: 1.4.6
  author: jay_li@intfocus.com
  date: 16/05/09
 */

(function(){

  "use strict";

  window.ReportTemplateV1 = {
    screen: function() {
        var w = window,
        d = document,
        e = d.documentElement,
        obj = {}; // new Object(); // The object literal notation {} is preferable.
        obj.width = w.innerWidth || e.innerWidth;
        obj.height = w.innerHeight || e.innerHeight;
        return obj;
    },
    modal: function(ctl) {
        var date1 = new Date().getTime(),
            $modal = $("#ReportTemplateV1Modal");

        $modal.modal("show");
        $modal.find(".modal-title").html($(ctl).data("title"));
        $modal.find(".modal-body").html($(ctl).data("content"));

        var date2 = new Date().getTime(),
            dif = date2 - date1;
        console.log("duration: " + dif);
    },
    outerApi: function(ctl) {
      var $modal = $("#ReportTemplateV1Modal"),
          url = $(ctl).data("url"),
          split = url.indexOf("?") > 0 ? "&" : "?";

      url = url + split + $(ctl).data("params");

      $modal.modal("show");
      $modal.find(".modal-title").html($(ctl).data("title"));

      $.ajax({
        type: "GET",
        url: url, 
        success:function(result, status, xhr) {
          $modal.find(".modal-body").html("loading...");

          try {
              var contentType = xhr.getResponseHeader("content-type") || "default-not-set",
                  table = "<table id='modalContentTable' class='table'><tbody>";

              $("#contentType").html(contentType);
              if(contentType.toLowerCase().indexOf("application/json") < 0) {
                table = table + "<tr><td style='width:30%;'>提示</td><td style='width:70%;'>content-type 有误</td></tr>";
                table = table + "<tr><td style='width:30%;'>期望值</td><td style='width:70%;'>application/json</td></tr>";
                table = table + "<tr><td style='width:30%;'>响应值</td><td style='width:70%;'>" + contentType + "</td></tr>";
                table = table + "</tbody></table>";

                $modal.find(".modal-body").html(table);
                return;
              }

              var json = JSON.parse(JSON.stringify(result)),
                  regPhone1 = /^1\d{10}$/,
                  regPhone2 = /^0\d{2,3}-?\d{7,8}$/,
                  regEmail = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;

              if(result === null || result.length === 0) {
                table = table + "<tr><td style='width:30%;'>响应</td><td style='width:70%;'>内容为空</td></tr>"
                table = table + "<tr><td style='width:30%;'>链接</td><td style='width:70%;word-break:break-all;'>" + url + "</td></tr>"
              }

              for(var key in json) {
                var value = json[key];
                if(regPhone1.test(value) || regPhone2.test(value)) {
                  value = "<a class='sms' href='tel:" + value + "'>" + value + "</a>&nbsp;&nbsp;&nbsp;&nbsp;" +
                          "<a class='tel' href='sms:" + value + "'> 短信 </a>";
                }
                else if(regEmail.test(value)) {
                  value = "<a class='mail' href='mailto:'" + value + "'>" + value + "</a>";
                }
                table = table + "<tr><td style='width:30%;'>" + key + "</td><td style='width:70%;'>" +value + "</td></tr>";
              }
              table = table + "</tbody></table>";

              $modal.find(".modal-body").html(table);
          } catch (e) {
              console.log(e);
              $modal.find(".modal-body").html("response:\n" + JSON.stringify(result) + "\nerror:\n" + e);
          }

          // modal width should equal or thinner than screen
          var width = ReportTemplateV1.screen().width - 10;
          $("#modalContentTable").css("max-width", width + "px");
        },
        error:function(XMLHttpRequest, textStatus, errorThrown) {
              $modal.find(".modal-body").html("GET " + url + "<br>状态:" + textStatus + "<br>报错:" + errorThrown);
        }
      });
    },
    checkArrayForChart: function(array) {
        for(var index = 0, len = array.length; index < len; index ++) {
          if(array[index] === null) { 
            array[index] = undefined; 
          }
        }
        return array;
    },
    generateTable: function(heads, rows, outerApi) {
      var tmpArray = [],
          isOuterAapi = (typeof(outerApi) !== 'undefined'),
          htmlString;

      for(var index = 0, len = heads.length; index < len; index ++) {
        tmpArray.push(heads[index]);
      }
      htmlString = "<thead><th>" + tmpArray.join("</th><th>") + "</th></thead>";

      // clear array
      tmpArray.length = 0;
      for(var rowIndex = 0, rowLen = rows.length; rowIndex < rowLen; rowIndex ++) {
        var row = rows[rowIndex],
            isRoot = (row[0] === 1 || row[0] === "1"),
            rowString;

        for(var dataIndex = 1, dataLen = row.length; dataIndex < dataLen; dataIndex ++) {
          var data = row[dataIndex];

          if(isOuterAapi && !isRoot && outerApi.target === dataIndex) {
            data = "<a href='javascript:void(0);' onclick='ReportTemplateV1.outerApi(this);' " +
                   "data-title='" + data + "' " +
                   "data-url='" + outerApi.url + "' " +
                   "data-params='" + outerApi.data[rowIndex] + "'>" + data + 
                   "</a>";
          }

          if(dataIndex === 1) {
            rowString = (isRoot ? "\
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

        tmpArray.push(rowString);
      }
      htmlString += "<tbody>" + tmpArray.join("") + "</tbody>";

      return htmlString;
    },
    generateTabs: function(tabs) {
      var tabIndex = (new Date()).valueOf(), 
          tmpArray = [],
          htmlString,
          i, len;

      for(i = 0, len = tabs.length; i < len; i ++) {
        tmpArray.push("<li class='" + (i === 0 ? "active" : "") + "'>\
                        <a data-toggle='tab' href='#tab_" + tabIndex + "_" + i + "'>" + tabs[i].title + "</a>\
                      </li>");
      }
      htmlString = "<ul class='nav nav-tabs'>" + 
                     tmpArray.join("") + 
                   "</ul>";

      // clear array
      tmpArray.length = 0;
      for(i = 0, len = tabs.length; i < len; i ++) {
        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "' class='tab-pane animated fadeInUp " + (i === 0 ? "active" : "") + "'>\
                        <div class='row'  style='margin-left:0px;margin-right:0px'>\
                          <div class='col-lg-12' style='padding-left:0px;padding-right:0px'>\
                            <table class='table table-striped table-bordered table-hover'>"
                              + ReportTemplateV1.generateTable(tabs[i].table.head, tabs[i].table.data, tabs[i].outer_api) +
                            "</table>\
                          </div>\
                        </div>\
                      </div>");
      }
      htmlString += "<div class='tab-content tabs-flat no-padding'>" +
                      tmpArray.join("") + 
                    "</div>";

      return htmlString;
    },

    // after require echart.js
    generateChart: function(option) {
      var seriesColor = ['#96d4ed', '#fe626d', '#ffcd0a', '#fd9053', '#dd0929', '#016a43', '#9d203c', '#093db5', '#6a3906', '#192162'];
      for(var i = 0, len = option.series.length; i < len; i ++) {
          option.series[i].data = ReportTemplateV1.checkArrayForChart(option.series[i].data);
          option.series[i].itemStyle = { normal: { color: seriesColor[i] } };
      }
      var yAxis;
      for(var i = 0, len = option.yAxis.length; i < len; i ++) {
         yAxis = option.yAxis[i];
         yAxis.nameTextStyle = { color:'#323232' /*cbh*/ };
         option.yAxis[i] = yAxis;
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
        grid: {y: 30, y2:20, x2:2, x:40},
        xAxis : [
            {
                type : 'category',
                boundaryGap : true,
                splitLine: {
                  show:false,/* grid wangge cbh*/
                },
                axisTick: {
                  show:false,/* x cbh*/
                  // lineStyle:{
                  //   color:'#eee'
                  // }
                },
                data : option.xAxis
            }
        ],
        yAxis : option.yAxis,
        series : option.series
      }; 
    },
    generateTemplate: function(index, template) {
      var modelTitle = "说明";
      if(template.banner.title.length) {
        modelTitle = template.banner.title;
      }
      else if(template.title.length) {
        modelTitle = template.title;
      }
      return "\
      <div class='row tab-part tab-part-" + index + "' style='margin-left:0px;margin-right:0px'>\
          <div class='col-lg-12 col-sm-12 col-xs-12' style='padding-left:0px;padding-right:0px'>\
            <div class='databox radius-bordered bg-white databox-shadowed' style='height:100%;'>\
              <div class='databox-row'>\
                <div class='databox-cell cell-12 text-align-center bordered-right bordered-platinum' style='min-height:40px;'>\
                  \
                  <div class='databox-stat radius-bordered bg-qin' style='left:7px;right:initial;'>\
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
                      <a href='javascript:void(0);' onclick='ReportTemplateV1.modal(this);' data-title='" + modelTitle + "' data-content='" + template.banner.info + "'>" + "\
                        <span style='font-size:20px;' class='qin glyphicon glyphicon-info-sign'></span>\
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
                + ReportTemplateV1.generateTabs(template.tabs) + "\
              </div>\
              \
            </div>\
          </div>\
        </div>\
      </div>";
    }, 
    generateTemplates: function(templates) {
      var tabNav = document.getElementById("tabNav"),
          tabContent = document.getElementById("tabContent"),
          colNum = parseInt(12 / templates.length),
          template,
          i, len;

      for(i = 0, len = templates.length; i < len; i ++) {
        template = templates[i];

        tabNav.innerHTML += "\
          <div class='col-lg-" + colNum + " col-md-" + colNum + " col-sm-" + colNum + " col-xs-" + colNum + "'>\
            <a class='day-container " + (i === 0 ? "highlight" : "") + "' data-index=" + i + ">\
              <div class='day'>" 
                + template.title + "\
              </div>\
            </a>\
          </div>";

        tabContent.innerHTML += ReportTemplateV1.generateTemplate(i, template);
      }

      for(i = 0, len = templates.length; i < len; i ++) {
        template = templates[i];

        if(typeof(template.is_show_chart) !== "undefined" && template.is_show_chart === true) {
          var chart_id = document.getElementById("template_chart_" + i),
              chart;
          if(/3\.1\.\d+/.test(echarts.version)) {
            chart = echarts.init(chart_id, 'macarons');
            console.log('tempalte engine v1: echart 3+')
          }
          // "2.2.7"
          else {
            chart = echarts.init(chart_id);
            chart.setTheme('macarons');
            console.log('tempalte engine v1: echart <> 3+')
          }
          chart.setOption(ReportTemplateV1.generateChart(template.chart));
        }

        if(i !== 0) {
          $(".tab-part-"+i).addClass("hidden");
        }
      }

      var modalHtml = '\
        <div class="modal fade in" id="ReportTemplateV1Modal">\
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
              <div class="modal-footer">\
                <span id="contentType" style="line-height:34px;width:50%;text-align:left;float:left;color:silver;"></span>\
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>\
              </div>\
            </div>\
          </div>\
        </div>';

      $(modalHtml).appendTo($("body"));

      // fixed: tab 下表格内容过长而导致样式上的屏幕溢出
      $(".tab-pane table").css({
        "table-layout": "fixed", 
        "word-break": "break-all",
        "max-width": ReportTemplateV1.screen().width + "px"
      });
    }
  }
}).call(this)

window.onerror = function(e) {
  window.alert(e);
}
$(function(){
  ReportTemplateV1.generateTemplates(TemplateData.templates);
  //ReportTemplateV1.caculateHeightForTable(".tab-part-0");

  $('a.table-more').each(function() {
    var $this = $(this),
        $currentRow = $this.closest('tr'),
        items = $currentRow.nextUntil('tr[class!=more-items]').map(function(){ return 1; }).get();

    if(items === undefined || items.length === 0) {
        $this.addClass('table-more-without-children');
    }
  });

  $('a.table-more').click(function(e) {
    e.preventDefault()

    var $this = $(this),
        $currentRow = $this.closest('tr');
    $currentRow.nextUntil('tr[class!=more-items]').toggle();
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

    //ReportTemplateV1.caculateHeightForTable(klass);
  });
});
