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
    generateTableV3: function(tableId, heads, rows, outerApi) {
      var tmpArray = [],
          isOuterAapi = (typeof(outerApi) !== 'undefined'),
          htmlString;

      var largeArea = [],     //大区数据
          store = [],         //门店数据
          storedetails = [];  //门店明细数据
      for(var item of rows){
        if(item[0] == 1){
          tem&&store.push(tem);
          largeArea.push(item);
          var tem = [];
          //门店数组加入条目
          tem.push([0,0,0].concat(heads.slice(2, heads.length)));//,"商行－门店","销售额(万)","销售占比","客流"]);
        }
        if(item[0] == 2){
          tem.push(item);
          tem1&&storedetails.push(tem1);
          var tem1 = [];
          //门店明细数组加入条目
          tem1.push([0,0,0].concat(heads.slice(2, heads.length)));//,"商行－门店","销售额(万)","销售占比","客流"]);
        }
        if(item[0] == 3){
          tem1.push(item);
        }
      }
      //大区数组加入条目shijun
      largeArea.splice(0,0,[0,0,0].concat(heads.slice(2, heads.length)));//,"商行－门店","销售额(万)","销售占比","客流"]);
      tmpArray = [largeArea, store, storedetails];
      htmlString = '\
      <div class="table-v3-wrapper">\
        <div class="header">\
        </div>\
        <div id="' + tableId + '">\
          <largearea-list :large-area="largeArea"></largearea-list>\
          <store-list :store="store" ></store-list>\
          <storedetails-list :storedetails="storedetails" ></storedetails-list>\
        </div>\
      </div>';

      return [htmlString, tableId, tmpArray];
    },
    generateTablesV3: function(outerIndex, innerIndex, tabs) {
      var tabIndex = (new Date()).valueOf() + outerIndex * 1000 + innerIndex,
          tmpArray = [],
          htmlString, i, len, tableId;

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
      var table_v3_configs = [], temp_config = [];
      for(i = 0, len = tabs.length; i < len; i ++) {
        tableId = 'table_v3_' + tabIndex + "_" + i;
        temp_config = ReportTemplateV2.generateTableV3(tableId, tabs[i].table.head, tabs[i].table.data, tabs[i].outer_api);
        table_v3_configs.push(temp_config.slice(1, 3));
        tmpArray.push("<div id='tab_" + tabIndex + "_" + i + "' class='tab-pane animated fadeInUp " + (i === 0 ? "active" : "") + "'>\
                        <div class='row'  style='margin-left:0px;margin-right:0px'>\
                          <div class='col-lg-12' style='padding-left:0px;padding-right:0px'>"
                              + temp_config[0] + "\
                          </div>\
                        </div>\
                      </div>");
      }
      htmlString += "<div class='tab-content tabs-flat no-padding'>" +
                      tmpArray.join("") +
                    "</div>";

      return ["\
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
      </div>", table_v3_configs];
    },

    // after require echart.js
    // `innerIndex` = outerIndex * index
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
       // console.log(JSON.stringify(chart_option));
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
                  <div class='databox-stat radius-bordered bg-qin' style='color:#fff;left:7px;right:initial;'>\
                    <div class='stat-text'>"
                      + config.date + "\
                    </div>\
                  </div>\
                  <span class='databox-number lightcarbon'> "
                    + config.title + "\
                  </span>\
                  <span class='databox-number sonic-silver no-margin'>"
                    + config.subtitle + "\
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
      var part_trend_value_diff = config.main_data.data - config.sub_data.data;
      var part_trend_value_perc = part_trend_value_diff / config.main_data.data;

      return "\
        <div class='row tab-part tab-part-" + outerIndex + "' style='margin-left:0px;margin-right:0px'>\
          <div class='container-fluid area'>\
            <div class='row'>\
              <div class='col-xs-12'>\
                <div class='block'>\
                  <header data-part-id='block-title' class='block-header'>\
                    <div class='triangle triangle-" + config.state.arrow + "' style='color:" + config.state.color +"'>\
                    </div>\
                    <div class='block-title'>"
                      + config.title + "\
                    </div>\
                  </header>\
                  <div class='body-content-wrapper'>\
                    <div class='labels-container block-body'>\
                      <div class='tap-area-1' style='display:block;'>\
                        <div class='field-label' style='color:" + config.state.color +"'>"
                          + config.main_data.name + "\
                        </div>\
                        <div class='total-label'>"
                          + config.sub_data.name +"\
                        </div>\
                      </div>\
                      <div class='tap-area-2' style='display:block;'>\
                        <div class='field-value-label' style='color:" + config.state.color +"'>"
                          + ReportTemplateV2.toThousands(config.main_data.data) +"\
                        </div>\
                        <div class='total-value-label' style='color:" + config.state.color +"'>"
                          + ReportTemplateV2.toThousands(config.sub_data.data) + "\
                        </div>\
                      </div>\
                      <div class='field-percent-label'>\
                        <div class='trent-wrapper' style='display:inline-block'>\
                          <span class='part-trent-value' style='color:" + config.state.color +"'>"
                            + ReportTemplateV2.toThousands(part_trend_value_diff) +"\
                          </span>\
                        </div>\
                      </div>\
                    </div>\
                  </div>\
                </div>\
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

      return "<h5 class='row-title before-qin'>" + config.text + "</h5>";
    },
    generateTemplate: function(outerIndex, template) {
      var parts = template.parts,
          htmlString = "",
          i, len, innerIndex,
          table_v3_configs = [];
      for(i = 0, len = parts.length; i < len; i ++) {
        var part_type = parts[i].type;
        innerIndex = outerIndex * 1000 + i;
        if(part_type === 'banner') {
          htmlString += ReportTemplateV2.generateBanner(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'single_value') {
          htmlString += ReportTemplateV2.generateSingleValue(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'tables') {
          htmlString += ReportTemplateV2.generateTables(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'tables#v3') {
          table_v3_configs = ReportTemplateV2.generateTablesV3(outerIndex, innerIndex, parts[i].config);
          htmlString += table_v3_configs[0];
        }
        else if(part_type === 'chart') {
          htmlString += ReportTemplateV2.generateChart(outerIndex, innerIndex, parts[i].config);
        }
        else if(part_type === 'info') {
          htmlString += ReportTemplateV2.generateInfo(outerIndex, innerIndex, parts[i].config);
        }
      }
      return [htmlString, table_v3_configs[1]];
    },
    generateTemplates: function(templates) {
      var tabNav = document.getElementById("tabNav"),
          tabContent = document.getElementById("tabContent"),
          colNum = parseInt(12 / templates.length),
          template,
          i, len,
          table_v3_configs = [],
          temp_config = [];

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

        temp_config = ReportTemplateV2.generateTemplate(i, template);
        tabContent.innerHTML += temp_config[0];
        if(temp_config[1].length) {
          table_v3_configs.push(temp_config[1]);
        }
      }

      // step2: render with vue.js
      var templateTmpArray = [],
          tabTmpArray = [];
      for(var templateIndex = 0, tlen = table_v3_configs.length; templateIndex < tlen; templateIndex ++) {
        templateTmpArray =  table_v3_configs[templateIndex];
        for(var tabIndex = 0, tabLen = templateTmpArray.length; tabIndex < tabLen; tabIndex ++) {
          tabTmpArray = templateTmpArray[tabIndex];
          //console.log(tabTmpArray);
          if(tabTmpArray.length >= 0) {
            window.ReportTemplateV2.tableV3RenderWithVue(tabTmpArray[0], tabTmpArray[1]);
          }
        }
      }

      var chartOptions = ReportTemplateV2.charts, chart, chart_id;
      for(i = 0, len = chartOptions.length; i < len; i ++) {
        chart_id = document.getElementById("template_chart_" + chartOptions[i].index);
        if(/3\.1\.\d+/.test(echarts.version)) {
          chart = echarts.init(chart_id, 'macarons');
          console.log('tempalte engine v2: echart ~> 3.1+');
        }
        // "2.2.7"
        else {
          chart = echarts.init(chart_id);
          chart.setTheme('macarons');
          console.log('tempalte engine v2: echart <~ 3.1+');
        }
        chart.setOption(chartOptions[i].options);
      }

      // echarts will not work when its container has 'hidden' class
      for(i = 1, len = templates.length; i < len; i ++) {
        $('.tab-part-' + i).addClass('hidden');
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

      // fixed: tab 下表格内容过长而导致样式上的屏幕溢出
      $(".tab-pane table").css({
        "table-layout": "fixed",
        "word-break": "break-all",
        "max-width": ReportTemplateV2.screen().width + "px"
      });
    },
    setSearchItems: function() {
      var items = [];
      for(var i = 0, len = window.TemplateDatas.length; i < len; i++) {
        items.push(window.TemplateDatas[i].name);
      }

      window.MobileBridge.setSearchItems(items);
    },
    tableV3RenderWithVue: function(tableId, data) {
      if(typeof(Vue) === 'undefined') { return false; }

        /*主大区table*/
        Vue.component('largearea-list',{
            props:['largeArea'],
            methods:{
                sortList:function(index){
                    if(index>3){
                        this.largeArea.sort(function(a,b){
                            return parseFloat(b[index]) -  parseFloat(a[index]);
                        })
                    }
                }
            },
            template:`<div>
						<table class="content-tbl">
							<largearea-tr
							v-for="(item,index) in largeArea"
							:fdata="item"
							v-if="index == 0"
							v-on:sort="sortList"
							>
							</largearea-tr>
							<largearea-tr1
							v-for="(item,index) in largeArea"
							:fdata="item"
							v-if="index != 0"
							>
							</largearea-tr1>
						</table>
					</div>`
        });
        /*大区表格第一行tr*/
        Vue.component('largearea-tr',{
            props:['fdata'],
            methods:{
                sort:function(index){
                    this.$emit('sort',index);
                }
            },
            template:`<tr>
						<td
						class="sfiexd"
						:class="{fixed:index == 3,myIndex:index == 3}"
						v-on:touchend="sort(index)"
						v-for="(item,index) in fdata"
						v-if="index != 0 && index != 1 && index != 2"
						>{{item}}</td>
					</tr>`
        });

        /*大区表格其他tr*/
        Vue.component('largearea-tr1',{
            props:['fdata'],
            template:`<tr>
						<largearea-td
						v-for="(item,index) in fdata"
						v-if="index != 0 && index != 1 && index != 2 && index == 3"
						:con-rend="index"
						:con-item="item"
						:class="{fixed:index == 3}"
						></largearea-td>

						<largearea-td1
						v-for="(item,index) in fdata"
						v-if="index != 0 && index != 1 && index != 2 && index != 3"
						:con-rend="index"
						:con-item="item"
						></largearea-td1>
					</tr>`
        });


        /*大区表格第一列td*/
        Vue.component('largearea-td',{
            props:['conRend','conItem'],
            methods:{
                myEmit:function(e){
                    Hub.$emit('conrend',e.target.innerText);
                    vm.domEle = new Date().getTime();
                }
            },
            template:`<td v-on:touchend="myEmit">
						{{conItem}}
					</td>`
        });
        /*大区表格其他td*/
        Vue.component('largearea-td1',{
            props:['conRend','conItem'],
            template:`<td>
						{{conItem}}
					</td>`
        });
        /*门店div*/
        Vue.component('store-list',{
            props:['store'],
            data:function(){
                return {myrender:[]}
            },
            created:function(){
                var _this = this;
                Hub.$on('conrend',function(data){
                    for(var i of _this.store){
                        if(typeof i[1] !== 'undefined' && i[1][2] === data){
                            var a = [];
                            a.push(i);
                            _this.myrender = a;
                        }
                    }
                })

            },
            template:`<div>
						<store-tab
						v-for="(item,index) in myrender"
						:list="item"
						>
						</store-tab>
					</div>
					`
        });


        /*门店table*/
        Vue.component('store-tab',{
            props:['list'],
            methods:{
                sortList:function(index){
                    if(index>3){
                        this.list.sort(function(a,b){
                            return  parseFloat(b[index]) - parseFloat(a[index]);
                        })
                    }
                }
            },
            template:`<table class="content-tbl" style="z-index:22">
						<store-tr
						v-for="(item,index) in list"
						:list="item"
						v-if="index == 0"
						v-on:sort="sortList($event)"
						></store-tr>

						<store-tr1
						v-for="(item,index) in list"
						:list="item"
						v-if="index != 0"

						></store-tr1>
					</table>
					`
        });
        /*门店tr第一列*/
        Vue.component('store-tr',{
            props:['list'],
            methods:{
                sort:function(index){
                    this.$emit('sort',index);
                }
            },
            template:`<tr>
						<td
						class="sfiexd"
						v-for="(item,index) in list"
						v-if="index != 0 && index != 1 && index != 2"
						v-on:touchend="sort(index)"
						:class="{fixed:index == 3,myIndex:index == 3}"
						>{{item}}</td>
					</tr>
					`
        });
        /*门店tr1*/
        Vue.component('store-tr1',{
            props:['list'],
            template:`<tr>
						<store-td
						v-for="(item,index) in list"
						v-if="index != 0 && index != 1 && index != 2 && index == 3"
						:list="item"
						:class="{fixed:index == 3}"
						>
						</store-td>

						<store-td1
						v-for="(item,index) in list"
						v-if="index != 0 && index != 1 && index != 2 && index != 3"
						:list="item"
						>
						</store-td1>
					</tr>`
        });

        /*门店td*/
        Vue.component('store-td',{
            props:['list'],
            methods:{
                myEmit:function(e){
                    Hub.$emit('thconrend', e.target.innerText);
                    vm.domEle = new Date().getTime();
                }
            },
            template:`<td v-on:touchend="myEmit">{{list}}</td>`
        });
        Vue.component('store-td1',{
            props:['list'],
            template:`<td>{{list}}</td>
					`
        });

        /*门店清单div*/

        Vue.component('storedetails-list',{
            props:['storedetails'],
            data:function(){
                return {myrender:[]}
            },
            created:function(){
                var _this = this;
                Hub.$on('thconrend',function(data){
                    for(var i of _this.storedetails){
                       if(typeof i[1] !== 'undefined' && data == i[1][2]){
                            var a = [];
                            a.push(i);
                            _this.myrender = a;
                        }
                   }
                })
            },
            template:`<div>
						<storedetails-tab
						v-for="(item,index) in myrender"
						:list="item"
						></storedetails-tab>
					</div>`
        });

        /*门店清单table*/
        Vue.component('storedetails-tab',{
            props:['list'],
            methods:{
                sortList:function(index){
                    if(index>3){
                       this.list.sort(function(a,b){
                           return  parseFloat(b[index]) -  parseFloat(a[index]);
                       })
                    }
                }
            },
            template:`<table class="content-tbl" style="z-index:33">
						<storedetails-tr
						v-for="(item,index) in list"
						:list="item"
						v-if="index == 0"
						v-on:sort="sortList"
						></storedetails-tr>

						<storedetails-tr1
						v-for="(item,index) in list"
						:list="item"
						v-if="index != 0"
						></storedetails-tr1>
					</table>`
        });
        /*门店清单tr第一行*/
        Vue.component('storedetails-tr',{
            props:['list'],
            methods:{
                sort:function(index){
                    this.$emit('sort',index)
                }
            },
            template:`<tr>
						<td
						v-on:touchend="sort(index)"
						v-for="(item,index) in list"
						v-if="index != 0 && index != 1 && index != 2"
						:class="{fixed:index == 3,myIndex:index == 3}"
						class="sfiexd"
						>{{item}}</td>
					</tr>
					`
        });
        /*门店清单其他tr*/
        Vue.component('storedetails-tr1',{
            props:['list'],
            template:`<tr>
						<td
						v-for="(item,index) in list"
						v-if="index != 0 && index != 1 && index != 2"
						:class="{fixed:index == 3}"
						>{{item}}</td>
					</tr>
					`
        });
      /*vm实例*/
      var Hub = new Vue();
      var vm = new Vue({
        el:'#' + tableId,
        data:{
          largeArea: data[0],
          store: data[1],
          storedetails: data[2],
          domEle:'',
          scrollEle:null,
          myScroll:function (){
            var contenttbl =  document.getElementsByClassName('content-tbl');
            for(var i=0;i<contenttbl.length;i++){
              contenttbl[i].onoff = true;
              contenttbl[i].addEventListener('touchstart',function(e){
                var original = parseFloat(getComputedStyle(this).left);
                var star = e.targetTouches[0].pageX;
                this.addEventListener('touchmove',function(e){
                  var distance = e.targetTouches[0].pageX - star;
                  var result = original + distance;
                  if(result <= 0){
                    this.style.left = result + 'px';
                    for(var i=0;i<this.getElementsByClassName('fixed').length;i++){
                      this.getElementsByClassName('fixed')[i].style.left = -result + 'px';
                    }
                  }else{
                    this.style.left = 0;
                    for(var i=0;i<this.getElementsByClassName('fixed').length;i++){
                      this.getElementsByClassName('fixed')[i].style.left = 0;
                    }
                  }
                });
              })
            }
          }
        },
        created: function () {
            var positionHeight = document.getElementsByClassName('main-container')[0].offsetHeight ;
            var _this = this;
          window.onscroll = function(e){
            var winTop = document.documentElement.scrollTop || document.body.scrollTop;
            if(winTop > positionHeight){
                for(var i=0;i<_this.scrollEle.length;i++){
                    _this.scrollEle[i].style.top = winTop - positionHeight + 'px';
                }
            }else{
                for(var i=0;i<_this.scrollEle.length;i++){
                    _this.scrollEle[i].style.top = 0 + 'px';
                }
            }
          };

        },
        mounted:function(){   // 什么周期尾期。
          this.myScroll();
          this.scrollEle = document.getElementsByClassName('sfiexd ');
        },
        watch:{
          domEle:function(){
            var _this = this;
            setTimeout(function(){
              _this.myScroll();
              _this.scrollEle = document.getElementsByClassName('sfiexd ');
            });
          }
        }
      });
    }
  }
}).call(this,window,Vue);

window.onerror = function(e) {
  window.alert(e);
}
$(function() {
  ReportTemplateV2.setSearchItems();
   MobileBridge.getReportSelectedItem(function(selectedItem) {
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

    //ReportTemplateV2.caculateHeightForTable(".tab-part-0");

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

      //ReportTemplateV2.caculateHeightForTable(klass);
    });
  });
});
