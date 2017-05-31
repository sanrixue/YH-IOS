/* jslint plusplus: true */
/* global
     $:false,
     ReportTemplateV2:false,
     TemplateData:false,
     echarts:false
*/
/*
 * version: 2.0.0
 * author: jay_li@intfocus.com
 * date: 16/04/23
 *
 * ## change log:
 *
 * ### 16/05/08:
 *
 * - add: echart component type#`pie`
 * - fixed: tab switch with hidden other tab-part-*
 *
 * ### 16/12/23
 *
 * fixed: SingleValue 计算值小数位未约束，导致爆屏
 *
 */

(function(){

  "use strict";

  window.ReportTemplateV2 = {
    charts: [],
    chartsDom : [],
    tables: {},
    tableIds: {},
    barGtables : {},
    bargtableIds: {},
    toThousands: function(num) {
        var num = Number(num).toFixed(2).toString(),
            result = '';
        while (num.length > 3) {
            result = ',' + num.slice(-3) + result;
            num = num.slice(0, num.length - 3);
        }
        if (num) {
            result = num + result;
        }
        result = result.replace(",.", ".");
        return result.replace("-,", "-");
    },
    formatSVnumber: function(val) {
      switch(val['format']){
        case 'float':
          return Number(val['data']).toFixed(val['percentage']).toString();
        break;
        case 'int':
          return parseInt(val['data']).toString();
        break;
        case 'account':
          return ReportTemplateV2.toThousands(val['data']).toString();
        break;
        default:
          return val;
        break;
      }
    },
    accMul: function(arg1,arg2){
      var m=0,s1=arg1.toString(),s2=arg2.toString();
      try{m+=s1.split(".")[1].length}catch(e){}
      try{m+=s2.split(".")[1].length}catch(e){}
      return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
    },
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
            $modal = $("#ReportTemplateV2Modal");

        $modal.modal("show");
        $modal.find(".modal-title").html($(ctl).data("title"));
        $modal.find(".modal-body").html($(ctl).data("content"));

        var date2 = new Date().getTime(),
            dif = date2 - date1;
        console.log("duration: " + dif);
    },
     generateTemplate: function(outerIndex, template) {
      var parts = template.parts,
          htmlString = "",
          i, len, innerIndex;
      for(i = 0, len = parts.length; i < len; i ++) {
        var part_type = parts[i].type;
        innerIndex = outerIndex * 1000 + i;
        if(part_type === 'banner') {
          htmlString += ReportTemplateV2.generateBanner(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'single_value') {
          htmlString += ReportTemplateV2.generateSingleValue(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === "tables#v3") {
          htmlString += ReportTemplateV2.generateTablesV2(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'chart') {
          htmlString += ReportTemplateV2.generateChart(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'info') {
          htmlString += ReportTemplateV2.generateInfo(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'bargraph') {
          htmlString += ReportTemplateV2.generateBargraph(outerIndex, innerIndex, parts[i].config);
        }
      }
      return htmlString;
    },
    generateTemplates: function(templates) {
      var tabNav = document.getElementById("tabNav"),
          tabContent = document.getElementById("tabContent"),
          colNum = parseInt(12 / templates.length) < 3 ? 3 : parseInt(12 / templates.length),
          template,
          i, len;

      for(i = 0, len = templates.length; i < len; i ++) {
        template = templates[i];
        var listyle = colNum <= 4 ? 'width:'+colNum/100+'%' : '';
        tabNav.innerHTML += "\
          <li  o-class='col-lg-" + colNum + " col-md-" + colNum + " col-sm-" + colNum + " col-xs-" + colNum + "'>\
            <a class='day-container " + (i === 0 ? "highlight" : "") + "' data-index=" + i + ">\
              <span class='day'>"
                + template.title + "\
              </span>\
            </a>\
          </li>";

        tabContent.innerHTML += ReportTemplateV2.generateTemplate(i, template);
      }

      var chartOptions = ReportTemplateV2.charts, chart, chart_id, rcharts = [];
      for(i = 0, len = chartOptions.length; i < len; i ++) {
        chart_id = document.getElementById("template_chart_" + chartOptions[i].index);
        if(/3\.1\.\d+/.test(echarts.version)) {
          ReportTemplateV2.chartsDom[chartOptions[i].index] = chart = echarts.init(chart_id, 'macarons');
          console.log('tempalte engine v2: echart ~> 3.1+');
        }
        // "2.2.7"
        else {
          ReportTemplateV2.chartsDom[chartOptions[i].index] = chart = echarts.init(chart_id);
          chart.setTheme('macarons');
          console.log('tempalte engine v2: echart <~ 3.1+');
        }
        chart.setOption(chartOptions[i].options);
        (function(x){
          ReportTemplateV2.chartsDom[chartOptions[x].index].on('click', function (params, i) {
                console.log(params.seriesType);
                if (params.componentType === 'series' && (params.seriesType === 'line' || params.seriesType === 'bar')) {
                    var di = params['dataIndex'];
                    var d = $(ReportTemplateV2.chartsDom[chartOptions[x].index].getDom()).attr('data-index');
                    var labelColors = {"0":['#f44f4f','up'],"3":['#f44f4f','down'],"1":['#f4bc45','up'],"4":['#f4bc45','down'],"2":['#91c941','up'],"5":['#91c941','down']},
                        selName, textColor, arrowType, formatMainData,  formatSubData, part_trend_value_diff, part_trend_value_perc, part_trend_perc_prefix, part_trend_perc_arrow, part_trend_perc;
                    for (var i = ReportTemplateV2.charts.length - 1; i >= 0; i--) {
                       if(d == ReportTemplateV2.charts[i]['index']){
                          var op = ReportTemplateV2.charts[i]['options'];
                          textColor = op['series'][0]['data'][di]['color'] == undefined ? '' : labelColors[op['series'][0]['data'][di]['color']][0],
                          arrowType = op['series'][0]['data'][di]['color'] == undefined ? '' : labelColors[op['series'][0]['data'][di]['color']][1];
                          formatMainData = ReportTemplateV2.formatSVnumber({'percentage':0, 'data':op['series'][0]['data'][di]['value'],'format': 'float'}),
                          formatSubData  = ReportTemplateV2.formatSVnumber({'percentage':0, 'data':op['series'][1]['data'][di], 'format': 'float'});
                          part_trend_value_diff = formatMainData - formatSubData;
                          part_trend_value_perc = ((part_trend_value_diff / formatMainData) * 100).toFixed(2);
                          part_trend_perc_prefix = (part_trend_value_diff >= 0 ? '+':'');
                          part_trend_perc_arrow = (part_trend_value_diff >= 0 ? 'up':'down');
                          selName = op['xAxis'][0]['data'][di];
                          part_trend_perc = !isNaN(part_trend_value_perc) ? part_trend_perc_prefix+part_trend_value_perc+'%':'NaN';
                          break;
                       }
                    }
                    var arrowhtml = '<span class="arrow"><span class="triangle-'+arrowType+'"></span></span>';
                    $("#template_chart_result_"+d+" .selName").text(selName);
                    $("#template_chart_result_"+d+" .data-a .data-val").text(formatMainData);
                    $("#template_chart_result_"+d+" .data-b .data-val").text(formatSubData);
                    $("#template_chart_result_"+d+" .data-c .data-val").html(part_trend_perc+arrowhtml).css({'color':textColor,'width':13.75*part_trend_perc.length});
                }
            });
         })(i);
      }



      var modalHtml = '\
        <div class="modal fade in" id="ReportTemplateV2Modal">\
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

      // 顶部根页签处理
      var defaultMinTabNum = 4,
          wrapperTabNum = $('.wrapper .scroller ul li').length;
      if(wrapperTabNum > 0 ){
        if(wrapperTabNum <= defaultMinTabNum){
          $('.wrapper .scroller ul li').width((100/wrapperTabNum)+'%')
        } else {
          $('.wrapper').navbarscroll();
        }
      }
    },
    outerApi: function(ctl) {
      var $modal = $("#ReportTemplateV2Modal"),
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
          var width = ReportTemplateV2.screen().width - 10;
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
    generateTableDataV2: function(heads, rows, tabIndex) {
      var tableData = {headColumns:[], dataColumns:[], columnDefs: []};
      for(var index = 0, len = heads.length; index < len; index ++) {
        tableData['headColumns'].push({title: heads[index]});
        if(index<2){
          tableData['columnDefs'].push({"targets": 0, "visible": false,"targets": index,"width":"*"});
        } else {
          tableData['columnDefs'].push({"targets": index,"width":"*"});
        }
      }
      for(var index = 0, len = rows.length; index < len; index ++) {
        var kindex = rows[index][1] == "" ? 0 : (rows[index][1]);
        if(tableData['dataColumns'][kindex]  == undefined) {
          tableData['dataColumns'][kindex] = [rows[index]];
        } else {
          tableData['dataColumns'][kindex].push(rows[index]);
        }
      }
      this.tables[tabIndex] = tableData;
    },
    generateTablesV2: function(outerIndex, innerIndex, tabs) {
      var tabIndex =  outerIndex +'_'+ innerIndex,
          tmpArray = [],
          htmlString, i, len;

      for(i = 0, len = tabs.length; i < len; i ++) {
        tmpArray.push("<li class='" + (i === 0 ? "active" : "") + "'>\
                        <a data-toggle='tab' data-id='" + tabIndex + "_" + i + "' href='#tab_" + tabIndex + "_" + i + "'>" + tabs[i].title + "</a>\
                      </li>");
      }
      htmlString = "<ul class='nav nav-tabs' style='background-color:#2ec7c9;'>" +
                     tmpArray.join("") +
                   "</ul>";
      // clear array
      tmpArray.length = 0;
      for(i = 0, len = tabs.length; i < len; i ++) {
        this.generateTableDataV2(tabs[i].table.head,tabs[i].table.data, tabIndex + "_" + i);
        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "'  class='tab-pane  " + (i === 0 ? "active" : "") + "'>\
                        <div class=''  style='margin-left:0px;margin-right:0px'>\
                          <div o-class='col-lg-12 ' class='table_"+tabIndex + "_" + i+"' style='padding-left:0px;padding-right:0px'>\
                            <table id='table_"+tabIndex + "_" + i+"' class='display table stripe order-column normal-table' cellspacing='0' width='100%'></table>\
                          </div>\
                        </div>\
                      </div>");
      }
      htmlString += "<div class='tab-content tabs-flat no-padding'>" +
                      tmpArray.join("") +
                    "</div>";

      return "\
      <div class='row tab-part tab-part-" + outerIndex + "'  style='margin-left:0px;margin-right:0px'>\
        <div o-class='col-xs-12'  style='padding-left:0px;padding-right:0px'>\
          <div class='dashboard-box'>\
            <div class='box-tabbs'>\
              <div class='tabbable'>"
                + htmlString + "\
              </div>\
              \
            </div>\
          </div>\
        </div>\
      </div>";
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
            data = "<a href='javascript:void(0);' onclick='ReportTemplateV2.outerApi(this);' " +
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
    generateTables: function(outerIndex, innerIndex, tabs) {
      var tabIndex = (new Date()).valueOf() + outerIndex * 1000 + innerIndex,
          tmpArray = [],
          htmlString, i, len;

      for(i = 0, len = tabs.length; i < len; i ++) {
        tmpArray.push("<li class='" + (i === 0 ? "active" : "") + "'>\
                        <a data-toggle='tab' href='#tab_" + tabIndex + "_" + i + "'>" + tabs[i].title + "</a>\
                      </li>");
      }
      htmlString = "<ul class='nav nav-tabs' style='background-color:#2ec7c9;'>" +
                     tmpArray.join("") +
                   "</ul>";

      // clear array
      tmpArray.length = 0;
      for(i = 0, len = tabs.length; i < len; i ++) {
        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "' class='tab-pane animated fadeInUp " + (i === 0 ? "active" : "") + "'>\
                        <div class='row'  style='margin-left:0px;margin-right:0px'>\
                          <div class='col-lg-12' style='padding-left:0px;padding-right:0px'>\
                            <table class='table table-striped table-bordered table-hover'>"
                              + ReportTemplateV2.generateTable(tabs[i].table.head, tabs[i].table.data, tabs[i].outer_api) +
                            "</table>\
                          </div>\
                        </div>\
                      </div>");
      }
      htmlString += "<div class='tab-content tabs-flat no-padding'>" +
                      tmpArray.join("") +
                    "</div>";

      return "\
      <div class='row tab-part tab-part-" + outerIndex + "'  style='margin-left:0px;margin-right:0px'>\
        <div o-class='col-xs-12'  style='padding-left:0px;padding-right:0px'>\
          <div class='dashboard-box'>\
            <div class='box-tabbs'>\
              <div class='tabbable'>"
                + htmlString + "\
              </div>\
              \
            </div>\
          </div>\
        </div>\
      </div>";
    },

    // after require echart.js
    // `innerIndex` = outerIndex * index
    generateChart: function(outerIndex, innerIndex, config) {
      ReportTemplateV2.charts.push({ index: innerIndex, options: ReportTemplateV2.generateChartOptions(config) });
      var labelColors = {"0":['#f44f4f','up'],"3":['#f44f4f','down'],"1":['#f4bc45','up'],"4":['#f4bc45','down'],"2":['#91c941','up'],"5":['#91c941','down']},
          textColor = config['series'][0]['data'][0]['color'] == undefined ? '' : labelColors[config['series'][0]['data'][0]['color']][0],
          arrowType = config['series'][0]['data'][0]['color'] == undefined ? '' : labelColors[config['series'][0]['data'][0]['color']][1];
      var formatMainData = config['series'][0]['data'][0]['value'],
          formatSubData  = config['series'][1]['data'][0];
      var part_trend_value_diff = formatMainData - formatSubData;
      var part_trend_value_perc = ((part_trend_value_diff / formatMainData) * 100).toFixed(2);
      var part_trend_perc_prefix = (part_trend_value_diff >= 0 ? '+':'');
      var part_trend_perc_arrow = (part_trend_value_diff >= 0 ? 'up':'down');
      var part_trend_perc = !isNaN(part_trend_value_perc) ? part_trend_perc_prefix+part_trend_value_perc+'%':'NaN';
      var part_trend_perc_width = 13.75*(part_trend_perc.length);
      return "\
      <div class='row tab-part tab-part-" + outerIndex + "'  style='margin-left:0px;margin-right:0px'>\
        <div class='widget' style='position:relative;'>\
          <div class='chart_compare_reslut' id='template_chart_result_"+innerIndex+"'><div class='selName'>"+config['xAxis'][0]+"</div><div class='chart_compare_data'>\
                <div class='data-a'><span class='data-val'>"+config['series'][0]['data'][0]['value']+"</span><span class='data-name'>"+config['series'][0]['name']+"</span></div>\
                <div class='data-b'><span class='data-val'>"+config['series'][1]['data'][0]+"</span><span class='data-name'>"+config['series'][1]['name']+"</span></div>\
                <div class='data-c' style='width:"+part_trend_perc_width+"px;'><span class='data-val' style='color:"+textColor+"'>"+part_trend_perc+" <span class='arrow'><span class='triangle-"+part_trend_perc_arrow+"' ></span></span></span><span class='data-name'>变化率 </span></div>\
                </div></div>\
          <div class='widget-body' style='padding-top:0px;'>\
            <div class='row'>\
              <div class='col-sm-12'  style='padding-left:0px;padding-right:0px;position:relative;'>\
                <div id='template_chart_" + innerIndex + "' data-index='"+innerIndex+"' class='chart chart-lg'></div>\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>";
    },
    generateChartOptions: function(option) {
      var chart_type = option.chart_type,
          chart_option;
      if(chart_type === 'pie') {
        chart_option = {
          tooltip: {
              trigger: 'item',
              formatter: "{a} <br/>{b}: {c} ({d}%)"
          },
          legend: {
              orient: 'vertical',
              x: 'left',
              data: option.legend
          },
          series: [
            {
              name:option.title,
              type:'pie',
              radius: ['50%', '70%'],
              avoidLabelOverlap: false,
              label: {
                  normal: {
                      show: true,
                      position: 'center'
                  },
                  emphasis: {
                      show: true,
                      textStyle: {
                          fontSize: '30',
                          fontWeight: 'bold'
                      }
                  }
              },
              labelLine: {
                  normal: {
                      show: false
                  }
              },
              itemStyle: {
                  normal: {
                      shadowColor: '#ff0000'
                  }
              },
              data: option.data
            }
          ]
        };
        console.log(JSON.stringify(chart_option));
      }
      else {
        var seriesColor = ['#96d4ed', '#fe626d', '#ffcd0a', '#fd9053', '#dd0929', '#016a43', '#9d203c', '#093db5', '#6a3906', '#192162'];
        for(var i = 0, len = option.series.length; i < len; i ++) {
            var color = '';
            if(i == 1 && option.series[i].type == 'line'){
              color = "#a984d3";
            }
            if(i == 0 && option.series[i].type == 'line'){
              color = "#71a3ed";
            }
            if(i == 1 && option.series[i].type == 'bar'){
              color = "#f57658";
            }
            if(i == 0 && option.series[i].type == 'bar'){
              color = "#eeeff1";
            }
            option.series[i].data = ReportTemplateV2.checkArrayForChart(option.series[i].data);
            option.series[i].itemStyle = { normal: { color: color, width: 2, shadowBlur: 5,
                shadowOffsetX: 3,
                shadowOffsetY: 3 } };
            option.series[i].symbolSize = 10;
        }
        var yAxis;
        for(var i = 0, len = option.yAxis.length; i < len; i ++) {
           yAxis = option.yAxis[i];
           yAxis.nameTextStyle = { color:'#323232' /*cbh*/ };
           option.yAxis[i] = yAxis;
        }
        chart_option = {
          tooltip : {
              trigger: 'axis'
          },
          legend: {
              x: 'center',
              y: '30px',
              padding: 5,    // [5, 10, 15, 20]
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
          calculable: true,
          grid: {
            show:true,
            backgroundColor:'transparent',
            y: 80, y2:20, x2:10, x:40
          },
          xAxis : [
             {
                  type : 'category',
                  boundaryGap : true,
                  splitLine:{
                    show:false,
                  },
                  axisTick: {
                    show:false,/*cbh*/
                  },
                  data : option.xAxis
              }
          ],
          yAxis : option.yAxis,
          series : option.series
        };
      }
      return chart_option;
    },
    generateBanner: function(outerIndex, innerIndex, config) {
      var modelTitle = "说明";
      if(config.title.length) {
        modelTitle = config.title;
      }
      return "\
      <div class='row tab-part tab-part-" + outerIndex + "' style='margin-left:0px;margin-right:0px'>\
          <div class='col-lg-12 col-sm-12 col-xs-12' style='padding-left:0px;padding-right:0px'>\
            <div class='databox radius-bordered bg-white' style='height:100%;'>\
              <div class='databox-row'>\
                <div class='databox-cell cell-12 text-align-center bordered-right bordered-platinum' style='min-height:40px;'>\
                  \
                  <div class='databox-stat radius-bordered bg-qin' style='left:7px;right:initial;'>\
                    <div class='stat-text'>"
                      + (config.date == undefined ? '' : config.date) + "\
                    </div>\
                  </div>\
                  <span class='databox-number lightcarbon'> "
                    + (config.title == undefined ? '' : config.title) + "\
                  </span>\
                  <span class='databox-number sonic-silver no-margin'>"
                    + (config.subtitle == undefined ? '' : config.subtitle) + "\
                  </span>\
                  \
                  <div class='databox-stat '>\
                    <div class='stat-text'>\
                      <a href='javascript:void(0);'  onclick='ReportTemplateV2.modal(this);' data-title='" + modelTitle + "' data-content='" + config.info + "'>" + "\
                        <span style='font-size:20px;' class='qin glyphicon glyphicon-search'></span>\
                      </a>\
                    </div>\
                  </div>\
                  <div class='databox-stat '>\
                    <div class='stat-text'>\
                      <a href='javascript:void(0);'  onclick='ReportTemplateV2.modal(this);' data-title='" + modelTitle + "' data-content='" + config.info + "'>" + "\
                        <span style='font-size:20px;' class='qin glyphicon glyphicon-info-sign'></span>\
                      </a>\
                    </div>\
                  </div>\
                </div>\
              </div>\
            </div>\
          </div>\
      </div>";
    },
    generateSingleValue: function(outerIndex, innerIndex, config) {
      var labelColors = {"0":['#f44f4f','up'],"3":['#f44f4f','down'],"1":['#f4bc45','up'],"4":['#f4bc45','down'],"2":['#91c941','up'],"5":['#91c941','down']},
          textColor = config['state']['color'] == undefined ? '' : labelColors[config['state']['color']][0],
          arrowType = config['state']['color'] == undefined ? '' : labelColors[config['state']['color']][1];
      var formatMainData = ReportTemplateV2.formatSVnumber(config.main_data),
          formatSubData  = ReportTemplateV2.formatSVnumber(config.sub_data);

      var part_trend_value_diff = formatMainData - formatSubData;
      var part_trend_value_perc = ((part_trend_value_diff / config.main_data.data) * 100).toFixed(2);
      var part_trend_perc_prefix = (part_trend_value_diff >= 0 ? '+':'');
      var part_trend_perc_arrow = (part_trend_value_diff >= 0 ? 'up':'down');
      var part_trend_perc = !isNaN(part_trend_value_perc) ? part_trend_perc_prefix+part_trend_value_perc+'%':'NaN';
      return "\
        <div class='row tab-part tab-part-" + outerIndex + "' style='margin-left:0px;margin-right:0px'>\
        <div class='container-fluid compareDivArea compareArea-part-" + outerIndex + "'>\
        <div class='compareArea '>\
          <div class='compareMain'>\
            <div class='compare_total active' data-main-val='"+formatMainData+"' data-sub-val='"+formatSubData+"' datacolor='"+textColor+"' dataid='" + outerIndex + "' style='color:"+textColor+"'>"
            + ReportTemplateV2.formatSVnumber(config.main_data)+"\
            </div>\
            <div class='compare_field' >"
            + config.main_data.name + "\
            </div>\
          </div>\
          <div class='compareLabel'>- VS -</div>\
          <div class='compareSub'>\
            <div class='compare_total' data-main-val='"+formatSubData+"' data-sub-val='"+formatMainData+"' datacolor='"+textColor+"' dataid='" + outerIndex + "'>"
            + ReportTemplateV2.formatSVnumber(config.sub_data)+"\
            </div>\
            <div class='compare_field'>"
            + config.sub_data.name + "\
            </div>\
          </div>\
        </div>\
        <div class='compareData'>\
          <div class=' triangle triangle_a active' style='color:"+textColor+"'>\
          <span class='arrow'><span class='triangle_"+part_trend_perc_arrow+"' ></span></span><span class='triangle_val'>"
          + part_trend_perc +"\
          </span></div>\
          <div class='triangle triangle_b' style='color:"+textColor+"'>"
          + ReportTemplateV2.formatSVnumber(config.main_data)+"\
          </div>\
        </div>\
        </div>\
        </div>";
    },
    generateInfo: function(outerIndex, innerIndex, config) {
      // return "\
      // <div class='row tab-part tab-part-" + outerIndex + "' style='margin-left:0px;margin-right:0px'>\
      //     <div class='col-lg-12 col-sm-12 col-xs-12' style='padding-left:0px;padding-right:0px'>\
      //       <div class='databox radius-bordered bg-white' style='height:100%;'>\
      //         <div class='databox-row'>\
      //           <div class='databox-cell cell-12 text-align-center bordered-right bordered-platinum' style='min-height:40px;'>\
      //             <span class='databox-number sonic-silver no-margin' style='font-size:13px'>"
      //               + config.text + "\
      //             </span>\
      //           </div>\
      //         </div>\
      //       </div>\
      //     </div>\
      // </div>";

      return "<h5 class='row-title before-qin'>" + config.title + "</h5>";
    },
    generateBargraph: function(outerIndex, innerIndex, config) {
      var barg_head = [config['xAxis']['name'], config['series']['name'], ''],
          barg_data = [config['xAxis']['data'], config['series']['data'], config['series']['data']];
      this.generateBargraphTableData(barg_head, barg_data,  "bargraph_" + innerIndex);
      return "\
      <div class='row tab-part tab-part-" + innerIndex + "' style='margin-left:0px;margin-right:0px'>\
          <div class='col-lg-12 col-sm-12 col-xs-12' style='padding-left:0px;padding-right:0px'>\
            <div class='bg-white' style='height:100%;'>\
              <table id='table_bargraph_"+innerIndex + "' class='display table order-column bargraph_table' cellspacing='0' width='100%'></table>\
            </div>\
          </div>\
      </div>";
    },
   generateBargraphTableData :function(heads, rows, tabIndex){
      var tableData = {headColumns:[], dataColumns:[], columnDefs: []};
      for(var index = 0, len = heads.length; index < len; index ++) {
        tableData['headColumns'].push({title: heads[index]});
        if(heads[index] == "") {
          tableData['columnDefs'].push({"targets": index,"width":"*","orderable": false}); //"orderable": false
        } else {
          tableData['columnDefs'].push({"targets": index,"width":(index == 2 ?'110' :'*')}); //
        }

      }
      var distance = ReportTemplateV2.accMul(Math.max.apply(null, rows[1]) - Math.min.apply(null, rows[1]), 100) ;
      for(var index = 0, len = rows[0].length; index < len; index ++) {
        var tmpArray = [rows[0][index], rows[1][index], ReportTemplateV2.accMul(rows[2][index],100)+"_"+distance+"_"+ReportTemplateV2.accMul(Math.min.apply(null, rows[1]),100)];
        if(tableData['dataColumns'][index]  == undefined) {
          tableData['dataColumns'][index] = tmpArray;
        } else {
          tableData['dataColumns'][index].push(tmpArray);
        }
      }
      this.barGtables[tabIndex] = tableData;
   },
    setSearchItems: function() {
      var items = [];
      for(var i = 0, len = window.TemplateDatas.length; i < len; i++) {
        items.push(window.TemplateDatas[i].name);
      }
      window.MobileBridge.setSearchItems(items);
    },
    setTabshidden: function(templates) {
      // echarts will not work when its container has 'hidden' class
      for(var i = 1, len = templates.length; i < len; i ++) {
        $('.tab-part-' + i).addClass('hidden');
      }
      $.each($('.tab-content>.tab-pane'), function(i,that){
         if($(that).hasClass('active')){
            $(that).css({'display':'block'});
         } else {
            $(that).css({'display':'none'});
         }
      })
    },
    renderbarGtablefunc: function() {
      $.each(this.barGtables, function(i, v) {
          ReportTemplateV2.databargtablesfunc(i, v['headColumns'], v['dataColumns'], v['columnDefs']);
       })
    },
    databargtablesfunc : function(tabIndex, head, rows, columnDefs) {
         ReportTemplateV2.bargtableIds[tabIndex] = $('#table_'+tabIndex).DataTable({
              data: rows,
              columns: head,
              scrollY:   '400',
              scrollCollapse: true,
              scrollX: true,
              paging:         false,
              info:           false,
              searching: false,
              bLengthChange: false,
              order: [[ 0, "asc" ]],
              fixedHeader: {
                header: false,
              },
              columnDefs: columnDefs,
              createdRow: function (row, data, index) {
                  $(row).eq(0).find('td').eq(1).html(ReportTemplateV2.accMul(data[1],100)+"%");
                  var dat = data[2].split('_'),
                      t_a_w = (dat[2] < 0 ? Math.abs(dat[2]): 0),
                      t_b_w = dat[1] - t_a_w,
                      t_w_step = 100/dat[1],
                      a_w = (dat[0] < 0 ? Math.abs(dat[0]): 0),
                      b_w = (dat[0] > 0 ? Math.abs(dat[0]): 0);

                  $(row).eq(0).find('td').eq(2).html("<div class='distance'><div class='val_a' style='width:"+ReportTemplateV2.accMul(t_a_w,t_w_step)+"px;'><div style='width:"+ReportTemplateV2.accMul(a_w,t_w_step)+"px;' class='valBar'></div></div><div style='width:"+ReportTemplateV2.accMul(t_b_w,t_w_step)+"px;' class='val_b'><div style='width:"+ReportTemplateV2.accMul(b_w,t_w_step)+"px;' class='valBar'></div></div></div>");
              }
          });
    },
    rendertablefunc: function() {
        $.each(this.tables, function(i, v) {
          var tindex = 0, minKey;
          $.each(v['dataColumns'], function(k, val) {
            if(val != undefined && tindex == 0) {minKey = k; tindex++;}
          })

          ReportTemplateV2.datatablesfunc(i, v['headColumns'], v['dataColumns'][minKey], v['columnDefs']);
        })
    },
    datatablesfunc : function(tabIndex, head, rows, columnDefs) {
         ReportTemplateV2.tableIds[tabIndex] = $('#table_'+tabIndex).DataTable({
              data: rows,
              columns: head,
              scrollY:   '400',
              scrollCollapse: true,
              scrollX: true,
              paging:         false,
              info:           false,
              searching: false,
              fixedColumns:   { leftColumns: 3 },
              bLengthChange: false,
              order: [[ 2, "asc" ]],
              fixedHeader: {
                header: true,
              },
              columnDefs: columnDefs,
              createdRow: function (row, data, index) {
                  if(ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]] != undefined && ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]].length > 0){
                    $(row).eq(0).find('td').eq(0).addClass('active');
                    $(row).eq(0).find('td').eq(0).html('<a href="javascript:ReportTemplateV2.relatedTable(\''+tabIndex+'\',\''+$.trim(data[0])+'\');">'+$(row).eq(0).find('td').eq(0).html()+'</a>')
                  }
              }
          });
    },
    relatedTable: function(tabIndex, index) {
      var childrenTable = {head:[], rows:[]};
      console.log(tabIndex+'-------'+index);
      childrenTable['head'] = ReportTemplateV2.tables[tabIndex]['headColumns'];
      childrenTable['columnDefs'] = ReportTemplateV2.tables[tabIndex]['columnDefs'];
      childrenTable['rows'] = ReportTemplateV2.tables[tabIndex]['dataColumns'][index];
      var dialog = $("<div class='tabledialog' id='modalTable_"+tabIndex+index+"'><div class='header'>"+index+"<a href='javascript:ReportTemplateV2.closedialogtable(\""+tabIndex+index+"\")' class='close'  type='button'><span> ×</span></button></div><div style='height:"+($(document).height()-40)+"px' class='tablebody' ><table class='display table stripe order-column normal-table' cellspacing='0' width='100%' id='modaltablebody_"+tabIndex+index+"'></table></div></div>").css({width:"100%", height:$(document).height(), 'background-color':'#fff', left:0, top:0, position:'fixed', 'z-index': 9999999+index});
      $("body").append(dialog);
      $('#modaltablebody_'+tabIndex+index).DataTable({
              data: childrenTable['rows'],
              columns: childrenTable['head'],
              scrollY:   '400',
              scrollCollapse: true,
              scrollX: true,
              paging:         false,
              info:           false,
              searching: false,
              fixedColumns:   { leftColumns: 3 },
              bLengthChange: false,
              bAutoWidth: false,
              fixedHeader: {
                header: true,
              },
              columnDefs: childrenTable['columnDefs'],
              createdRow: function (row, data, index) {
                if(ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]] != undefined && ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]].length > 0){
                     $(row).eq(0).find('td').eq(0).addClass('active');
                    $(row).eq(0).find('td').eq(0).html('<a href="javascript:ReportTemplateV2.relatedTable(\''+tabIndex+'\',\''+$.trim(data[0])+'\');">'+$(row).eq(0).find('td').eq(0).html()+'</a>')
                }
              }
          });
      console.log(childrenTable);
    },
    closedialogtable: function(tid) {
       $("#modalTable_"+tid).remove();
    },
  }
}).call(this)
