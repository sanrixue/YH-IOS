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
    tableSort : {},
    tableActive : {},
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
    getLength: function(str) {
      return str.replace(/[\u0391-\uFFE5]/g,"aa").length;  //先把中文替换成两个字节的英文，在计算长度
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
        else if(part_type === "tables") {
          htmlString += ReportTemplateV2.generateTablesV2(outerIndex, innerIndex, parts[i].config, i);
        }
        else if(part_type === "tables#v3") {
          htmlString += ReportTemplateV2.generateTablesV3(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'chart') {
          htmlString += ReportTemplateV2.generateChart(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'chart#v2') {
          htmlString += ReportTemplateV2.generateChartV2(outerIndex, innerIndex, parts[i].config);
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
        if(i == 0) { ReportTemplateV2.tableActive['activeId'] = '.tab-part-'+i; }
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
                //console.log(params.seriesType);
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
                    return;
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
    createArrayReleated: function(tableRows){
      var resetArray = [];
      for(var rowIndex = 0, rowLen = tableRows.length; rowIndex < rowLen; rowIndex ++) {
         var val = tableRows[rowIndex];
         if(tableRows[rowIndex][0] === 1){ resetArray.push(val); }
         if(tableRows[rowIndex][0] === 2){
            if(resetArray[resetArray.length-1]['children'] === undefined){  resetArray[resetArray.length-1]['children'] = []; }
            resetArray[resetArray.length-1]['children'].push(val);
         }
         if(tableRows[rowIndex][0] === 3){
            if(resetArray[resetArray.length-1]['children'][resetArray[resetArray.length-1]['children'].length-1]['children'] === undefined){ resetArray[resetArray.length-1]['children'][resetArray[resetArray.length-1]['children'].length-1]['children'] = []; }
            resetArray[resetArray.length-1]['children'][resetArray[resetArray.length-1]['children'].length-1]['children'].push(val);
         }
      }
      return resetArray;
    },
    orderByTableList: function(tableid,field) {
       var array = tableid.split("_");
       window.ReportTemplateV2.tableSort[tableid] = field;
       if($.isArray(array) && array.length == 3){
          var tabObj = window.TemplateData.templates[array[0]].parts[array[1]].config[array[2]];
          var tableInnerHTML = ReportTemplateV2.generateTableV2(tabObj.table.head, tabObj.table.data, tabObj.outer_api, array[0]+"_"+array[1]+"_"+array[2]);
          $("#tb_"+tableid).empty().html(tableInnerHTML);
       }
    },
    generateTableTrV2: function(deep, maxDeep, outerApi, row, i_t) {
      var isOuterAapi = (typeof(outerApi) !== 'undefined'),
          rowString;
      for(var dataIndex = 1, dataLen = row.length; dataIndex < dataLen; dataIndex ++) {
          var data = row[dataIndex];
          if(isOuterAapi && deep === maxDeep && outerApi.target === dataIndex) {
            data = "<a href='javascript:void(0);' onclick='ReportTemplateV2.outerApi(this);' style='text-decoration: underline;'" +
                   "data-title='" + data + "' " +
                   "data-url='" + outerApi.url + "' " +
                   "data-params='" + outerApi.data[i_t] + "'>" + data +
                   "</a>";
          }
          if(dataIndex === 1) {
            var tabtd = row['children'] !== undefined ? "<a href='javascript:;' data-id='"+i_t+"' class='table-more table-more-closed'><span class='icon'></span><span class='text'>"+data+"</span></a>" : data;
            var hasChildClass = row['children'] !== undefined ? " hasChild" : "";
            i_t += "";
            var i_t_array = i_t.indexOf("_")?i_t.split('_'):i_t;
            if(deep === 1){
                rowString = "<tr class='trfirstlev'><td>"+tabtd+"</td>";
            }
            if(deep === 2){
                rowString = "<tr class='tr-item-"+i_t_array[0]+hasChildClass+" trtwolev' style='display:none'><td>"+tabtd+"</td>";
            }
            if(deep === 3){
                rowString = "<tr class='tr-item-"+i_t_array[0]+"_"+i_t_array[1]+hasChildClass+" trthreelev' style='display:none'><td>" + tabtd + "</td>";
            }
          }
          else {
            rowString += "<td>" + data + "</td>";
          }
        }
        rowString += "</tr>";
        return rowString;
    },
    generateTableV2: function(heads, rows, outerApi, tableid) {
      var newRows = ReportTemplateV2.createArrayReleated($.extend(true, [], rows)), fieldsort, fieldby;
      var newRows = newRows.sortBy(window.ReportTemplateV2.tableSort[tableid]);
      if(window.ReportTemplateV2.tableSort[tableid][0] == '-'){
        fieldsort = window.ReportTemplateV2.tableSort[tableid].substr(1);
        fieldby= ''
      } else {
        fieldsort = window.ReportTemplateV2.tableSort[tableid];
        fieldby='-';
      }
      var tmpArray = [],
          isOuterAapi = (typeof(outerApi) !== 'undefined'),
          htmlString;
      for(var index = 1, len = heads.length; index <= len; index ++) {
        var sortby = index == fieldsort ? fieldby+index:index;
        var sorttg = '';
        if(index == fieldsort) {
            sorttg = fieldby == '-' ? '↑':'↓';
        }
        tmpArray.push('<a href="javascript:void(0);" onclick="ReportTemplateV2.orderByTableList(\''+tableid+'\', \''+sortby+'\')" >'+heads[index-1]+sorttg+'</a>');
      }
      htmlString = "<thead><th>" + tmpArray.join("</th><th>") + "</th></thead>";
      // level maximum deep
      var maxDeep = 1;
      for(var rowIndex = 0, rowLen = newRows.length; rowIndex < rowLen; rowIndex++) {
        if(maxDeep == 3) continue;

        if(newRows[rowIndex]['children'] != undefined && newRows[rowIndex]['children'].length>0){
          maxDeep = 2;
        }
        if(newRows[rowIndex]['children'] !== undefined) {
          for(var rowIndex2 = 0, rowLen2 = newRows[rowIndex]['children'].length; rowIndex2 < rowLen2; rowIndex2++) {
            if(newRows[rowIndex]['children'][rowIndex2]['children'] != undefined && newRows[rowIndex]['children'][rowIndex2]['children'].length > 0) {
              maxDeep = 3;
            }
          }
        }
      }
      // clear array
      tmpArray.length = 0;
      for(var rowIndex = 0, rowLen = newRows.length; rowIndex < rowLen; rowIndex++) {
        if(newRows[rowIndex]['children'] != undefined && newRows[rowIndex]['children'].length>0){
          newRows[rowIndex]['children'] = newRows[rowIndex]['children'].sortBy(window.ReportTemplateV2.tableSort[tableid]);
        }
        tmpArray.push(ReportTemplateV2.generateTableTrV2(1, maxDeep, outerApi, newRows[rowIndex], rowIndex));
         if(newRows[rowIndex]['children'] !== undefined) {
            for(var rowIndex2 = 0, rowLen2 = newRows[rowIndex]['children'].length; rowIndex2 < rowLen2; rowIndex2++) {
              if(newRows[rowIndex]['children'][rowIndex2]['children'] != undefined && newRows[rowIndex]['children'][rowIndex2]['children'].length > 0) {
                newRows[rowIndex]['children'][rowIndex2]['children'] = newRows[rowIndex]['children'][rowIndex2]['children'].sortBy(window.ReportTemplateV2.tableSort[tableid]);
              }
              tmpArray.push(ReportTemplateV2.generateTableTrV2(2, maxDeep, outerApi, newRows[rowIndex]['children'][rowIndex2], rowIndex+'_'+rowIndex2));
              if(newRows[rowIndex]['children'][rowIndex2]['children'] !== undefined) {
                 for(var rowIndex3 = 0, rowLen3 = newRows[rowIndex]['children'][rowIndex2]['children'].length; rowIndex3 < rowLen3; rowIndex3++) {
                    tmpArray.push(ReportTemplateV2.generateTableTrV2(3, maxDeep, outerApi, newRows[rowIndex]['children'][rowIndex2]['children'][rowIndex3], rowIndex+'_'+rowIndex2+'_'+rowIndex3));
                 }
              }
            }
         }
      }
      htmlString += "<tbody>" + tmpArray.join("") + "</tbody>";
      return htmlString;
    },
    generateTablesV2: function(outerIndex, innerIndex, tabs, partsindex) {
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
        window.ReportTemplateV2.tableSort[outerIndex+"_"+partsindex+"_"+i] = "1";
        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "' class='tab-pane animated fadeInUp " + (i === 0 ? "active" : "") + "'>\
                        <div class='row'  style='margin-left:0px;margin-right:0px'>\
                          <div class='col-lg-12' style='padding-left:0px;padding-right:0px'>\
                            <table data-config='"+i+"' id='tb_"+outerIndex+"_"+partsindex+"_"+i+"' class='table table-striped table-bordered table-hover'>"
                              + ReportTemplateV2.generateTableV2(tabs[i].table.head, tabs[i].table.data, tabs[i].outer_api, outerIndex+"_"+partsindex+"_"+i) +
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
        <div class='col-xs-12'  style='padding-left:0px;padding-right:0px'>\
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
    generateTableDataV3: function(heads, rows, tabIndex) {
      var tableData = {headColumns:[], dataColumns:[], columnDefs: []};
      for(var index = 0, len = heads.length; index < len; index ++) {
        var tdW = heads[index] != '' ? ReportTemplateV2.getLength(heads[index])*12+"px" : "*";
        tableData['headColumns'].push({title: heads[index], width: (index == 2 ? '20%': '20%')});
        if(index<2){
          tableData['columnDefs'].push({targets: index, "visible": false, "width":"20%"});
        } else {
          tableData['columnDefs'].push({targets: index, "width": (index == 2 ? '20%': '20%')});
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
    generateTablesV3: function(outerIndex, innerIndex, tabs) {
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
        this.generateTableDataV3(tabs[i].table.head,tabs[i].table.data, tabIndex + "_" + i);

        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "'  class='tab-pane  " + (i === 0 ? "active" : "") + "'>\
                        <div class=''  style='margin-left:0px;margin-right:0px'>\
                          <div o-class='col-lg-12 ' class='table_"+tabIndex + "_" + i+"' style='padding-left:0px;padding-right:0px'>\
                            <table id='table_"+tabIndex + "_" + i+"' class='display table stripe order-column normal-table' cellspacing='0' width='100%'></table>\
                          </div>\
                        </div>\
                      </div>");
      }
      htmlString += "<div class='tab-content tab-content-v3 tabs-flat no-padding'>" +
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
    generateChart: function(outerIndex, innerIndex, config) {
      ReportTemplateV2.charts.push({ index: innerIndex, options: ReportTemplateV2.generateChartOptions(config) });
      return "\
      <div class='row tab-part tab-part-" + outerIndex + "'  style='margin-left:0px;margin-right:0px'>\
        <div class='widget'>\
          <div class='widget-body'>\
            <div class='row'>\
              <div class='col-sm-12'  style='padding-left:0px;padding-right:0px'>\
                <div id='template_chart_" + innerIndex + "' class='chart chart-lg'></div>\
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
                      show: false,
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
              // itemStyle: {
              //     normal: {
              //         shadowBlur: 200,
              //         shadowColor: 'rgba(0, 0, 0, 0.5)'
              //     }
              // },
              data: option.data
            }
          ]
        };
        console.log(JSON.stringify(chart_option));
      }
      else {
        var seriesColor = ['#96d4ed', '#fe626d', '#ffcd0a', '#fd9053', '#dd0929', '#016a43', '#9d203c', '#093db5', '#6a3906', '#192162'];
        for(var i = 0, len = option.series.length; i < len; i ++) {
            option.series[i].data = ReportTemplateV2.checkArrayForChart(option.series[i].data);
            option.series[i].itemStyle = { normal: { color: seriesColor[i] } };
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
              y: 'top',
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
    generateChartV2: function(outerIndex, innerIndex, config) {
      ReportTemplateV2.charts.push({ index: innerIndex, options: ReportTemplateV2.generateChartOptionsV2(config) });
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
    generateChartOptionsV2: function(option) {
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
                <div class='databox-cell cell-12 text-align-center bordered-right bordered-platinum' style=''>\
                  \
                  <div class='databox-stat radius-bordered bg-qin' style=''>\
                    <div class='stat-text'>"
                       + (config.title == undefined ? '' : config.title) +" "+ (config.date == undefined ? '' : config.date) + "\
                    </div>\
                  </div>\
                  \
                  <div style='float:right' class='databox-stat '>\
                    <div class='stat-text'>\
                      <a href='javascript:void(0);'  onclick='ReportTemplateV2.modal(this);' data-title='" + modelTitle + "' data-content='" + config.info + "'>" + "\
                        <span style='' class='qin'></span>\
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
      return "\
      <div class='row tab-part tab-part-" + outerIndex + "'  style='margin-left:0px;margin-right:0px'>\
        <div class='widget'>\
          <div class='widget-body'>\
            <div class='row'>\
              <div class='col-sm-12'  style='padding-left:0px;padding-right:0px'>\
                <h5 class='row-title before-qin'>" + config.text + "</h5>\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>";
    },
    generateBargraph: function(outerIndex, innerIndex, config) {
      var barg_head = [config['xAxis']['name'], config['series']['name'], ''],
          barg_data = [config['xAxis']['data'], config['series']['data'], config['series']['data']];
      this.generateBargraphTableData(barg_head, barg_data,  "bargraph_" + innerIndex);
      return "\
      <div class='row tab-part tab-part-" + outerIndex + "' style='margin-left:0px;margin-right:0px'>\
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
              autoWidth: true,
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
              sScrollX: "100%",
              columnDefs: columnDefs,
              initComplete: function(settings, json){
                //console.log(settings);
                //$("#DTFC_LeftWrapper").width()
                ReportTemplateV2.resetTablev3HeadWidth();
              },
              createdRow: function (row, data, index) {
                  if(ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]] != undefined && ReportTemplateV2.tables[tabIndex]['dataColumns'][data[0]].length > 0){
                    $(row).eq(0).find('td').eq(0).addClass('active');
                    $(row).eq(0).find('td').eq(0).html('<a href="javascript:ReportTemplateV2.relatedTable(\''+tabIndex+'\',\''+$.trim(data[0])+'\');"><img src="/assets/images/bargtab_active_icon.png"  /> '+$(row).eq(0).find('td').eq(0).html()+'</a>')
                  }
              }
          });
    },
    relatedTable: function(tabIndex, index) {
      var childrenTable = {head:[], rows:[]};
      //console.log(tabIndex+'-------'+index);
      childrenTable['head'] = ReportTemplateV2.tables[tabIndex]['headColumns'];
      childrenTable['columnDefs'] = ReportTemplateV2.tables[tabIndex]['columnDefs'];
      childrenTable['rows'] = ReportTemplateV2.tables[tabIndex]['dataColumns'][index];
      var dialog = $("<div class='tabledialog' id='modalTable_"+tabIndex+index+"'><div class='header'>"+index+"<a href='javascript:ReportTemplateV2.closedialogtable(\""+tabIndex+index+"\")' class='close'  type='button'><span> ×</span></button></div><div style='height:"+($(document).height()-40)+"px' class='tablebody' ><table class='display table stripe order-column normal-table' cellspacing='0' width='100%' id='modaltablebody_"+tabIndex+index+"'></table></div></div>").css({width:"100%", height:$(document).height(), 'background-color':'#fff', left:0, top:0, position:'fixed', 'z-index': 9999999+index});
      $("body").append(dialog);

      $('#modaltablebody_'+tabIndex+index).DataTable({
              data: childrenTable['rows'],
              columns: childrenTable['head'],
              scrollY:   ($(window).height()-75)+'px',
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
    resetTablev3HeadWidth: function(cur_id) {
      $('.table_'+cur_id+' .DTFC_LeftHeadWrapper table thead .sorting_desc').trigger('click');
      $('.table_'+cur_id+' .DTFC_LeftHeadWrapper table thead .sorting_asc').trigger('click');
      var loga = '',logb = '',logc = '';
      for (var i = $("#table_"+cur_id+" tbody tr").eq(0).find('td').length - 1; i >= 0; i--) {
        var initW = $("#table_"+cur_id+" tbody tr").eq(0).find('td').eq(i).width();
        if(i == 0) {
          $('.table_'+cur_id+' .DTFC_LeftHeadWrapper table thead tr th').eq(i).width(initW);
          $(".table_"+cur_id+" .DTFC_LeftWrapper").width(initW+31);
        }
        loga += 'initW----W:'+initW+'\r\n';
        logb += 'HeadW----W:'+$(".table_"+cur_id+" .dataTables_scrollHeadInner table thead tr th").eq(i).width()+'\r\n';
        $(".table_"+cur_id+" .dataTables_scrollHeadInner table thead tr th").eq(i).width(initW);
        $(".fixedHeader-floating thead tr th").eq(i).width(initW);
        logc += 'HeadL----W:'+$(".table_"+cur_id+" .dataTables_scrollHeadInner table thead tr th").eq(i).width()+'\r\n';
      }
    }
  }
}).call(this)

window.onerror = function(e) {
  window.alert(e);
}

$(function() {

  // ReportTemplateV2.setSearchItems();
    var selectedItem = null;
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
    ReportTemplateV2.rendertablefunc();
    ReportTemplateV2.renderbarGtablefunc();
    ReportTemplateV2.setTabshidden(window.TemplateData.templates);
    var in_t = 0;
    $.each(ReportTemplateV2.tableIds, function(i, t) {
        t.fixedHeader.enable(in_t == 0 ? true : false); in_t++;
    })

    $(".dashboard-box .box-tabbs .tabbable .nav-tabs li a").bind('click',function() {
        var selindex = $(this).parent('li').index();
        $.each($(this).parent('li').parent('.nav-tabs').siblings('.tab-content').find('.tab-pane'), function(i, that){
          $(that).css({'display': (selindex == i)?'block':'none'})
        })
        var cur_id = $(this).attr('data-id');
        $.each(ReportTemplateV2.tableIds, function(i, t) {
            if(i != cur_id) {
              t.fixedHeader.enable(false);
            } else {
              t.fixedHeader.enable(true);
            }
        })

    })
    $('a.day-container').click(function(el) {
      el.preventDefault();
      $(".day-container").removeClass("highlight");
      $(this).addClass("highlight");
      var tabIndex = $(this).data("index");
      var klass = ".tab-part-" + tabIndex;
      $(".tab-part").addClass("hidden");
      $(klass).removeClass("hidden");
      ReportTemplateV2.resetTablev3HeadWidth();
      ReportTemplateV2.tableActive['activeId'] = klass;
      $.each($(klass+' .nav-tabs'), function(i, t) {
        $(t).find('li.active a').trigger('click');
      });
      //ReportTemplateV2.caculateHeightForTable(klass);
    //});
    });
    $(".bargraph_table tbody tr").click(function(){
      $(".bargraph_table tbody tr").removeClass('active');
      $(this).addClass('active');
      var info = $(this).find('td').eq(0).text();
      layer.open({
        content: info,
        style: 'background-color: rgba(0,0,0,.5);'
        ,skin: 'msg'
        ,time: 2 //2秒后自动关闭
      });
    })

    $(".normal-table tbody tr").click(function(){
      var info = $(this).find('td').eq(0).text();
      layer.open({
        content: info,
        style: 'background-color: rgba(0,0,0,.7);'
        ,skin: 'msg'
        ,time: 2 //2秒后自动关闭
      });
    })

    $(".compareData").click(function(){
        if($('.triangle_b').hasClass('active')){
           $(".triangle_a").addClass('active');
           $(".triangle_b").removeClass('active');
        } else {
          $(".triangle_b").addClass('active');
           $(".triangle_a").removeClass('active');
        }
    })

    $(".dataTables_scrollBody").data('slt',{ sl:this.scrollLeft,st:this.scrollTop}).scroll(function(e) {
      var sl=this.scrollLeft,st=this.scrollTop,d=$(this).data('slt');
      // 左右滚动
      var tableId = $(this).find('table').attr('id')
      if(sl!=d.sl && $(".fixedHeader-floating").length > 0) {

        $(".fixedHeader-floating").css({'left': "-"+($(this).scrollLeft()+"px")});

        if($(".hack-fixedHeader-floating").length < 1){
          $('.fixedHeader-floating').after($('.fixedHeader-floating').eq(0).clone().css({left:0,width:$('.fixedHeader-floating').find('thead tr th').eq(0).width()}).addClass('hack-fixedHeader-floating'));
          for (var i = $(".hack-fixedHeader-floating tr th").length - 1; i >= 0; i--) {
            if(i > 0){
              $(".hack-fixedHeader-floating tr th")[i].remove();
            }
          }
        } else {
          $(".hack-fixedHeader-floating").css({left: 0,width:$('.fixedHeader-floating').find('thead tr th').eq(0).width()})
        }
        //$(".fixedHeader-floating tr th").eq(0).css({'z-index':101,'position':'absolute', 'left':(($(this).scrollLeft()) < 0 ? 0 : ($(this).scrollLeft())+"px")})
      } else if(st!=d.st && $(".fixedHeader-floating").length > 0) {
      } else {
        $("."+tableId+" .dataTables_scrollHeadInner table tr th").eq(0).css({left:'0px'})
        $(".hack-fixedHeader-floating").remove()
      }
      $(this).data('slt',{sl:sl,st:st});
    })

    $(document).data('slt',{ sl:$(document).scrollLeft(),st:$(document).scrollTop()}).scroll(function(e) {
      var sl=$(document).scrollLeft(),st=$(document).scrollTop(),d=$(this).data('slt');
      if(st!=d.st && $(".fixedHeader-floating").length > 0) {
      // 上下滚动
        console.log('up&down');
        var activetab = ReportTemplateV2.tableActive['activeId'];
        var activepane = $(activetab+" .tab-content-v3 div.active");
        var obj_to_top = activepane.offset().top;
        var obj_self_h = activepane.height();
        var doc_h      = $(document).height();
        var obj_left_body = activepane.find('.DTFC_LeftBodyWrapper').height();
        var obj_left_head = activepane.find('.DTFC_LeftHeadWrapper').height();
        var pana_h = activepane.find('.dataTables_scroll').height();
        if(activepane.find('.DTFC_LeftBodyWrapper').attr('old-height') == undefined) {
           activepane.find('.DTFC_LeftBodyWrapper').attr('old-height',obj_left_body);
           activepane.find('.DTFC_LeftBodyWrapper').height(pana_h-obj_left_head)
           activepane.find('.DTFC_LeftBodyLiner').height(pana_h-obj_left_head);
        }
        if($(".fixedHeader-floating").length < 2) {
          $(".hack-fixedHeader-floating").remove()
        }
        setTimeout(function(){
          if($(".fixedHeader-floating").length < 2) {
            $(".hack-fixedHeader-floating").remove()
          }
        }, 200)
      }
      $(this).data('slt',{sl:sl,st:st});
    })

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
});

Array.prototype.sortBy = function() {
    function _sortByAttr(attr) {
        var sortOrder = 1;
        if (attr[0] == "-") {
            sortOrder = -1;
            attr = attr.substr(1);
        }
        return function(a, b) {
            var cp_a = a[attr], cp_b = b[attr];
            cp_a = (typeof cp_a == 'string' && cp_a.substr(-1) == '%')?cp_a.substr(0,cp_a.length-1) * 1:cp_a;
            cp_b = (typeof cp_b == 'string' && cp_b.substr(-1) == '%')?cp_b.substr(0,cp_b.length-1) * 1:cp_b;
            var result = (cp_a < cp_b) ? -1 : (cp_a > cp_b) ? 1 : 0;
            return result * sortOrder;
        }
    }
    function _getSortFunc() {
        if (arguments.length == 0) {
            throw "Zero length arguments not allowed for Array.sortBy()";
        }
        var args = arguments;
        return function(a, b) {
            for (var result = 0, i = 0; result == 0 && i < args.length; i++) {
                result = _sortByAttr(args[i])(a, b);
            }
            return result;
        }
    }
    return this.sort(_getSortFunc.apply(null, arguments));
}


