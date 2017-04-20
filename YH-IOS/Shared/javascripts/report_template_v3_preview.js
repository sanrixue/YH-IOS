/* jslint plusplus: true */
/* global
     $:false,
     ReportTemplateV1:false,
     TemplateData:false,
     echarts:false
*/
/*
 *  ## change log
 *
 *  ### 161212 1513
 *
 *  cbh modified description
 */
(function() {
    window.KPIColor = {
        // green:'#22ac38',
        // red:'#c13711',
        // yellow:'#f8b551',
        // hgreen:'#00ff29',
        // hred:'#ff3600',
        // hyellow:'#f9d6a1',
        green: '#63A69F',
        gray:' #D3D3D3',
        red: '#F2836B',
        yellow: '#F2E1AC ',
        hgreen: '#4B7D78',
        hred: '#C46A57',
        hyellow: '#C9BB8F',
    }
}).call(this);

(function() {

    //点击次数
    var ClickTimes = 0;

    var GoodsWrapperFlag = 0;

    var HeightLi = 30;

    var StartY;
    var EndY;

    var StartX;
    var EndX;

    var StartTime;
    var EndTime;

    var SortType = 0;

    //1:打开柱状图,0:关闭柱状图
    var ChartFlag = 0;

    //颜色设置
    var KPIColor;

    var KPIData = {};
    //周期索引
    var Period;
    //商品索引
    var GoodsIndex;
    //商品名作为键值
    var GoodsName;

    //指标索引
    var ItemIndex = 0;

    //商品列表指标类型索引，1:指标数值,2:指标变化,3:指标百分比
    var RightIndex = 1;

    //商品列表指标类型展示方式索引，1:图形展示,2:数值展示
    var RightType = 1;

    //指标列表当前的页数
    var PageIndex;

    //柱状图高亮标识
    var HighLightFlag;

    window.KPIParse = {
        //指标列表分页
        mySwiper: new Swiper('.swiper-container', {
            loop: true,
            pagination: '.swiper-pagination',
            height: '251',
        }),
        //柱状图
        myChart: echarts.init(document.getElementById('bar')),


        //初始化

        init: function(kpi, color) {

            KPIData = kpi;
            ItemIndex = 0;
            KPIColor = color;

            $('.goods-list').html('');
            Period = KPIData.length - 1;
            var KPIPeriod = KPIData[Period];

            var products = KPIPeriod.products;
            $('.area-date').attr('data-index', Period);
            $('.area-date').attr('data-time', KPIPeriod.period);
            $('.area-date').html(KPIPeriod.period);

            this.setGoodsWrapper();
            this.setArea(0);

            this.mySwiper.slideTo(1, 0);
            $('.swiper-slide-active .area-item').first().addClass("area-item-active");
            ItemIndex = $('.area-item-active').attr('data-item');

            this.setGoodsListRight();

            $('.area-title').html(products[GoodsIndex].items[ItemIndex].name);
            $('.goods-title').html(KPIPeriod.head);
            $('.goods-wrapper-title-right .rectangle-title').html(products[GoodsIndex].items[ItemIndex].name);

        },
        //设置指标列表
        setArea: function(goods_index) {
            GoodsIndex = goods_index;
            var goods = KPIData[Period].products[GoodsIndex];
            GoodsName = goods.name;
            PageIndex = this.mySwiper.activeIndex;
            var area_count = 6;
            $('.area-goods-category').html(goods.name);


            $('.triangle').removeClass('triangle-up');
            $('.triangle').removeClass('triangle-down');
            $('.area-item-3').html('');
            $('.area-item-4').html('');
            var index = $('.goods-wrapper-title-right').attr('data-index');

            var items = goods.items;
            var swiper_count = Math.ceil(items.length / 6);
            this.mySwiper.removeAllSlides();
            var slides = new Array();
            var str = '';
            for (var i = 0; i < items.length; i++) {

                if (i % area_count == 0 && i != 0) {
                    var str2 = '<div class="swiper-slide"><div class="row">' + str + '</div></div>';
                    str = '';
                    slides.push(str2);
                }

                str += '<div class="col-xs-6">' +
                    '<div class="area-item area-' + Period + '-' + i + '" data-item="' + i + '">' +
                    '<div class="area-item-1">' + items[i].name + '</div>' +
                    '<div class="area-item-2"><span class="triangle"></span></div>' +
                    '<div class="area-item-3"></div><div class="area-item-4"></div>' +
                    '</div></div>';
            }

            if (str != '') {
                var str2 = '<div class="swiper-slide"><div class="row">' + str + '</div></div>';
                slides.push(str2);
            }

            this.mySwiper.appendSlide(slides);
            this.mySwiper.slideTo(PageIndex, 0);

            for (var i = 0; i < items.length; i++) {

                if (items[i].state.arrow == "up") {
                    $('.area-' + Period + '-' + i).find('.area-item-2 .triangle').addClass('triangle-up');
                    $('.area-' + Period + '-' + i).find('.area-item-2 .triangle').css({
                        "border-left": "15px solid transparent",
                        /*cbh*/
                        "border-right": "15px solid transparent",
                        /*cbh*/
                        "border-bottom": "20px solid " + items[i].state.color,
                        /* new cbh*/
                        "margin-right": "5%",
                        /*cbh*/
                        "border-top": "0px"
                    });
                }
                if (items[i].state.arrow == "down") {
                    $('.area-' + Period + '-' + i).find('.area-item-2 .triangle').addClass('triangle-down');
                    $('.area-' + Period + '-' + i).find('.area-item-2 .triangle').css({
                        "border-left": "15px solid transparent",
                        /*new cbh*/
                        "border-right": "15px solid transparent",
                        /*new cbh*/
                        "border-top": "20px solid " + items[i].state.color,
                        /*new cbh*/
                        "margin-right": "5%",
                        /* new cbh*/
                        "border-bottom": "0px"
                    });
                }
                $('.area-' + Period + '-' + i).find('.area-item-3').html(this.formatItem(items[i], 'main_data'));

                if (items[i].sub_data != undefined) {

                    if (RightIndex == 1) {
                        $('.area-' + Period + '-' + i).find('.area-item-4').html(this.formatItem(items[i], 'sub_data'));
                        $('.area-' + Period + '-' + i).find('.area-item-4').css("color", items[i].state.color);
                    } else if (RightIndex == 2) {
                        $('.area-' + Period + '-' + i).find('.area-item-4').html(this.format(Number(items[i].main_data.data) - Number(items[i].sub_data.data), items[i].main_data.format));
                        if (Number(items[i].main_data.data) - Number(items[i].sub_data.data) >= 0) {
                            $('.area-' + Period + '-' + i).find('.area-item-4').css("color", KPIColor.green);
                        } else {
                            $('.area-' + Period + '-' + i).find('.area-item-4').css("color", KPIColor.red);
                        }

                    } else if (RightIndex == 3) {
                        var scale = (Number(items[i].main_data.data) - Number(items[i].sub_data.data)) / items[i].sub_data.data;
                        $('.area-' + Period + '-' + i).find('.area-item-4').html(this.format(scale, 'percentage'));
                        if (scale >= 0) {
                            $('.area-' + Period + '-' + i).find('.area-item-4').css("color", KPIColor.green);
                        } else {
                            $('.area-' + Period + '-' + i).find('.area-item-4').css("color", KPIColor.red);
                        }
                    }

                } else {
                    $('.area-' + Period + '-' + i).find('.area-item-4').html('一');
                    $('.area-' + Period + '-' + i).find('.area-item-4').css("color", KPIColor.yellow);
                }


            }
            this.setAreaItemActive(ItemIndex);

        },
        setAreaItemActive: function(index) {
            $('.area-item-active').removeClass('area-item-active');
            ItemIndex = index;
            $('.area-item[data-item="' + ItemIndex + '"]').addClass('area-item-active');

        },

        setGoodsWrapper: function() {
            $('.goods-list').html('');
            var products = KPIData[Period].products;

            for (var i = 0; i < products.length; i++) {
                $('.goods-list').append(
                    '<li data-id="' + i + '" data-name="' + products[i]['name'] + '"><div class="goods-li-left">' + products[i].name + '</div>' +
                    '<div class="goods-li-right"><div class="rectangle"></div><div class="rectangle-value"></div>' +
                    '<div class="target"></div></div><div class="goods-li-right-2"><div class="rectangle-2"></div><div class="rectangle-2-value"></div></div>' +
                    '<div class="goods-li-right-3"><div class="rectangle-3"></div><div class="rectangle-3-value"></div></div></li>');
            }
            //ItemIndex=$('.area-item-active').attr('data-item');
            this.setGoodsListRight();
        },

        setGoodsListRight: function() {

            var products = KPIData[Period].products;

            var max = 0;
            var bianhua_max = 0;
            var scale_max = 0;
            for (var i = 0; i < products.length; i++) {
                if (Number(products[i].items[ItemIndex].main_data.data) > max) {
                    max = Number(products[i].items[ItemIndex].main_data.data);
                }
                if (products[i].items[ItemIndex].sub_data != undefined) {
                    if (Math.abs(products[i].items[ItemIndex].main_data.data - products[i].items[ItemIndex].sub_data.data) > bianhua_max) {
                        bianhua_max = Math.abs(products[i].items[ItemIndex].main_data.data - products[i].items[ItemIndex].sub_data.data);
                    }
                    if (Math.abs((Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data)) / products[i].items[ItemIndex].sub_data.data) > scale_max) {
                        scale_max = Math.abs((Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data)) / products[i].items[ItemIndex].sub_data.data);
                    }
                }
            }

            var bianhua = new Array();
            var scale = new Array();

            for (var i = 0; i < products.length; i++) {

                var width = Math.abs(Number(products[i].items[ItemIndex].main_data.data)) / max * 100;

                if (Number(products[i].items[ItemIndex].main_data.data) < 0) {

                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle').css({
                        "width": width + "%",
                        "left": "-" + width + "%",
                        "background-color": products[i].items[ItemIndex].state.color,
                    });
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-value').css({
                        "color": products[i].items[ItemIndex].state.color
                    });

                } else {
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle').css({
                        "width": width + "%",
                        "left": -50,
                        "background-color": products[i].items[ItemIndex].state.color,
                    });
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-value').css({
                        "color": products[i].items[ItemIndex].state.color
                    });
                }


                $('.goods-list li[data-id="' + i + '"]').find('.rectangle-value').html(this.formatItem(products[i].items[ItemIndex], 'main_data'));
                $('.goods-list li[data-id="' + i + '"]').attr('data-value', Number(products[i].items[ItemIndex].main_data.data));


                if (products[i].items[ItemIndex].sub_data != undefined) {
                    var width2 = Math.abs(Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data)) / bianhua_max * 100;

                    if (Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data) >= 0) {
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2').css({
                            "width": width2 + "%",
                            "left": "0px",
                            "background-color": KPIColor.green,
                        });
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2-value').css({
                            "color": KPIColor.green
                        });
                    } else {
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2').css({
                            "width": width2 + "%",
                            "left": "-" + width2 + "%",
                            "background-color": KPIColor.red,
                        });
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2-value').css({
                            "color": KPIColor.red
                        });
                    }

                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2-value').html(this.format(Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data), products[i].items[ItemIndex].main_data.format));
                    $('.goods-list li[data-id="' + i + '"]').attr('data-value-2', Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data));

                    var scale = (Number(products[i].items[ItemIndex].main_data.data) - Number(products[i].items[ItemIndex].sub_data.data)) / products[i].items[ItemIndex].sub_data.data;


                    var width3 = Math.abs(scale) / scale_max * 100;

                    if (Number(scale) >= 0) {
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3').css({
                            "width": width3 + "%",
                            "left": "0px",
                            "background-color": KPIColor.green,
                        });
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3-value').css({
                            "color": KPIColor.green
                        });
                    } else {
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3').css({
                            "width": width3 + "%",
                            "left": "-" + width3 + "%",
                            "background-color": KPIColor.red,
                        });
                        $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3-value').css({
                            "color": KPIColor.red
                        });
                    }
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3-value').html(Number(scale * 100).toFixed(2) + '%');
                    $('.goods-list li[data-id="' + i + '"]').attr('data-value-3', Number(scale).toFixed(2));

                } else {
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2').css({
                        "width": "0%",
                        "left": "0px",
                        "background-color": "",
                    });
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2-value').html('一');
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-2-value').css("color", KPIColor.yellow);

                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3').css({
                        "width": "0%",
                        "left": "0px",
                        "background-color": "",
                    });

                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3-value').html('一');
                    $('.goods-list li[data-id="' + i + '"]').find('.rectangle-3-value').css("color", KPIColor.yellow);
                }

            }
            this.setGoodsRight(RightIndex, RightType);
        },
        //设置周期
        setPeriod: function(val) {
            Period = val;
        },
        //设置格式
        formatItem: function(item, type) {

            if (item[type].format == 'percentage') {
                return Number(Number(item[type].data) * 100).toFixed(2) + '%';
            } else if (item[type].format == 'float') {
                return toThousands(Number(item[type].data).toFixed(2));
            } else {
                return Number(item[type].data).toFixed(0);
            }
        },
        format: function(val, type) {
            if (type == 'percentage') {
                return Number(Number(val) * 100).toFixed(2) + '%';
            } else if (type == 'float') {
                return Number(val).toFixed(2);
            } else {
                return Number(val).toFixed(0);
            }
        },
        setGoodsRight: function(index, type) {
            RightIndex = index;
            RightType = type;

            $('.goods-li-right').css('display', "none");
            $('.goods-li-right-2').css('display', "none");
            $('.goods-li-right-3').css('display', "none");

            $('.rectangle').css("display", "none");
            $('.rectangle-value').css("display", "none");
            $('.rectangle-2').css("display", "none");
            $('.rectangle-2-value').css("display", "none");
            $('.rectangle-3').css("display", "none");
            $('.rectangle-3-value').css("display", "none");

            if (RightIndex == 3) {
                $('.rectangle-title').html('%');
                $('.goods-li-right-3').css('display', "block");
                if (RightType == 2) {
                    $('.rectangle-3-value').css("display", "block");
                } else {
                    $('.rectangle-3').css("display", "block");
                }
            } else if (RightIndex == 2) {
                $('.rectangle-title').html('变化');
                $('.goods-li-right-2').css('display', "block");
                if (RightType == 2) {
                    $('.rectangle-2-value').css("display", "block");
                } else {
                    $('.rectangle-2').css("display", "block");
                }
            } else {
                $('.rectangle-title').html($('.area-item-active .area-item-1').html());
                $('.goods-li-right').css('display', "block");
                if (RightType == 2) {
                    $('.rectangle-value').css("display", "block");
                } else {
                    $('.rectangle').css("display", "block");
                }
            }

        },
        //返回RightIndex
        getRightIndex: function() {
            return RightIndex;
        },
        //返回RightType
        getRightType: function() {
            return RightType;
        },
        setPosition: function() {
            $this = this;
            $('.goods-list li').each(function(i) {

                if ($(this).position().top == 0) {

                    $('.area-goods-category').html($(this).attr('data-name'));
                    $this.setArea($(this).attr('data-id'));

                    if ($('#bar-container').height() > 0) {
                        KPIParse.setChart();
                    }
                }
            });
        },
        //返回Period
        getPeriod: function() {
            return Period;
        },
        //返回GoodsIndex
        getGoodsIndex: function() {
            return GoodsIndex;
        },
        //设置GoodsIndex
        setGoodsIndex: function(val) {
            GoodsIndex = Number(val);
        },
        getKPIData: function() {
            return KPIData;
        },
        getItemIndex: function() {
            return ItemIndex;
        },
        setHighLight: function() {
            for (var i = 0; i < KPIData.length; i++) {
                this.myChart.dispatchAction({
                    type: 'downplay',
                    dataIndex: i,
                });
            }

            this.myChart.dispatchAction({
                type: 'highlight',
                name: KPIData[Period].period,
            });
        },

        setChart: function() {

            var item = KPIData[Period].products[GoodsIndex].items[ItemIndex];
            var goods = KPIData[Period].products[GoodsIndex];
            GoodsName = goods.name;
            $('.area-title').html(item.name);
            var xAxis = {
                data: new Array(),
            };
            var series = new Array();
            var y = new Array();
            var xaxis_order = new Array();

            var max = 0;
            //var scale=(Number(item.main_data.data)-Number(item.sub_data.data))/item.sub_data.data;

            for (var i = 0; i < KPIData.length; i++) {
                for (var j = 0; j < KPIData[i].products.length; j++) {
                    if (KPIData[i].products[j]['name'] == goods.name) {
                        var item_temp = KPIData[i].products[j].items[ItemIndex];
                        if (RightIndex == 1) {
                            if (Number(item_temp.main_data.data) >= 0) {
                                if (Number(item_temp.main_data.data) < Number(item_temp.sub_data.data)) {
                                    y.push({
                                        "value": Number(item_temp.main_data.data).toFixed(2),
                                        "itemStyle": {
                                            "normal": {
                                                "color": KPIColor.gray,                                            },
                                            "emphasis": {
                                                // "color": KPIColor.hred,
                                                 "color":item_temp.state.color,                                            }
                                        }
                                    });
                                } else {
                                    y.push({
                                        "value": Number(item_temp.main_data.data).toFixed(2),
                                        "itemStyle": {
                                            "normal": {
                                                "color": KPIColor.gray,
                                            },
                                            "emphasis": {
                                                // "color": KPIColor.hgreen,
                                                "color":item_temp.state.color,

                                            }
                                        }
                                    });
                                }

                            } else {
                                y.push({
                                    "value": Number(item_temp.main_data.data).toFixed(2),
                                    "itemStyle": {
                                        "normal": {
                                            "color": KPIColor.red,
                                        },
                                        "emphasis": {
                                            "color": KPIColor.hred,
                                        }
                                    }
                                });
                            }
                        }
                        if (RightIndex == 2) {
                            if (Number(item_temp.main_data.data) - Number(item_temp.sub_data.data) >= 0) {
                                y.push({
                                    "value": Number(Number(item_temp.main_data.data) - Number(item_temp.sub_data.data)).toFixed(2),
                                    "itemStyle": {
                                        "normal": {
                                            "color": KPIColor.gray,
                                        },
                                        "emphasis": {
                                            "color": KPIColor.hgreen,
                                        }
                                    }
                                });
                            } else {
                                y.push({
                                    "value": Number(Number(item_temp.main_data.data) - Number(item_temp.sub_data.data)).toFixed(2),
                                    "itemStyle": {
                                        "normal": {
                                            "color": KPIColor.gray,
                                        },
                                        "emphasis": {
                                            "color": KPIColor.hred,
                                        }
                                    }
                                });
                            }
                        }

                        if (RightIndex == 3) {
                            var scale_temp = (Number(item_temp.main_data.data) - Number(item_temp.sub_data.data)) / Number(item_temp.sub_data.data);
                            if (scale_temp >= 0) {
                                y.push({
                                    "value": scale_temp.toFixed(2) * 100,
                                    "itemStyle": {
                                        "normal": {
                                            "color": KPIColor.gray,
                                        },
                                        "emphasis": {
                                            "color": KPIColor.hgreen,
                                        }
                                    }
                                });
                            } else {
                                y.push({
                                    "value": scale_temp.toFixed(2) * 100,
                                    "itemStyle": {
                                        "normal": {
                                            "color": KPIColor.gray,
                                        },
                                        "emphasis": {
                                            "color": KPIColor.hred,
                                        }
                                    }
                                });
                            }
                        }

                   // $('bar-time').on('click',function(){
                   //  xaxis_order.sort(function(a,b){return a-b});

                   // });
                        xAxis.data.push(KPIData[i].period);

                        if (Math.abs(Number(item.main_data.data)) > max) {
                            max = Math.abs(item.main_data.data);
                        }

                    }
                }
            }

            series[0] = {
                "name": item.name,
                "type": "bar",
                "data": y,
                "barMaxWidth": 20
            }

            var option = {
                title: {},
                tooltip: {
                    showContent: false
                },
                xAxis: {
                    data: xAxis.data,
                    axisLine: {
                        lineStyle: {
                            color: '#969696'
                        }
                    },
                    axisTick: {
                        show: false
                    },
                    axisLabel:{
                        interval:0,
                        rotate:45
                    }
                },
                grid: {
                    y: 10,
                    y2: 85,
                    x2: 20,
                    x: 60
                },
                yAxis: {
                    splitNumber: 2,
                    axisLine: {
                        lineStyle: {
                            color: '#969696'
                        }
                    },
                    splitLine: {
                        show: false
                    },
                    axisTick: {
                        show: false
                    }
                },
                series: series,
            };
            this.myChart.clear();
            this.myChart.setOption(option);
            //设置当前柱状图高亮
            this.setHighLight();
            this.setChartInfo(item);
            $('#bar-container').animate({
                "height": 310 /*new cbh*/
            });

        },
        setChartInfo: function(item) {
            var goods = KPIData[Period].products[GoodsIndex];
            var scale = (Number(item.main_data.data) - Number(item.sub_data.data)) / item.sub_data.data;


            if (RightIndex == 1) {
                // var subtext=goods.name+item.name+item.main_data.data;
                var subtext = goods.name;
            }

            if (RightIndex == 2) {
                var subtext = goods.name;
            }
            if (RightIndex == 3) {
                var subtext = goods.name;
            }


            $('#bar-index-1').html(this.format(item.main_data.data, item.main_data.format));
            $('#bar-index-2').html(this.format(Number(item.main_data.data) - Number(item.sub_data.data), item.main_data.format));
            $('#bar-index-3').html(this.format(scale, 'percentage'));

            $('#bar-index-1').css("color", "#333333");
            $('#bar-index-2').css("color", "#333333");
            $('#bar-index-3').css("color", "#333333");

            if (RightIndex == 1) {
                if (Number(item.main_data.data) >= 0) {
                    if (Number(item.main_data.data) >= Number(item.sub_data.data)) {
                        $('#bar-index-1').css({
                            "color": KPIColor.green
                        });
                    } else {
                        $('#bar-index-1').css({
                            "color": KPIColor.red
                        });
                    }
                } else {
                    $('#bar-index-1').css({
                        "color": KPIColor.red
                    });
                }
            }
            if (RightIndex == 2) {
                if (Number(item.main_data.data) - Number(item.sub_data.data) >= 0) {
                    $('#bar-index-2').css({
                        "color": KPIColor.green
                    });

                } else {
                    $('#bar-index-2').css({
                        "color": KPIColor.red
                    });
                }
            }
            if (RightIndex == 3) {
                if (scale >= 0) {
                    $('#bar-index-3').css({
                        "color": KPIColor.green
                    });

                } else {
                    $('#bar-index-3').css({
                        "color": KPIColor.red
                    });
                }
            }

            $('#bar-title').html(item.name);
            $('#bar-time').html(KPIData[Period].period);
            $('#bar-sub-title').html(subtext);

        },
        getHeightLi: function() {
            return getHeightLi;
        },
        SortRight: function(sort) {
            SortType = 2;
            var $lis = $('.goods-list li');
            $('.goods-list').html('');


            if (sort == 'down') {
                $('.goods-wrapper-title-right').find('.triangle-xs').addClass('triangle-down-xs');
                $('.goods-wrapper-title-right').find('.triangle-xs').removeClass('triangle-up-xs');

                var max;
                var temp;
                var scale;
                var scale_max;

                for (var i = 0; i < $lis.length; i++) {
                    max = i;

                    for (var j = i + 1; j < $lis.length; j++) {
                        if (RightIndex == 1) {
                            if (Number($($lis[j]).attr('data-value')) > Number($($lis[max]).attr('data-value'))) {
                                max = j;
                            }
                        }
                        if (RightIndex == 2) {
                            if (Number($($lis[j]).attr('data-value-2')) > Number($($lis[max]).attr('data-value-2'))) {
                                max = j;
                            }
                        }
                        if (RightIndex == 3) {
                            if (Number($($lis[j]).attr('data-value-3')) > Number($($lis[max]).attr('data-value-3'))) {
                                max = j;
                            }
                        }
                    }
                    temp = $lis[i];
                    $lis[i] = $lis[max];
                    $lis[max] = temp;
                    $('.goods-list').append($lis[i].outerHTML);
                }


            } else {
                $('.goods-wrapper-title-right').find('.triangle-down-xs').addClass('triangle-up-xs');
                $('.goods-wrapper-title-right').find('.triangle-down-xs').removeClass('triangle-down-xs');

                var min;
                var temp;
                var scale;
                var scale_min;
                for (var i = 0; i < $lis.length; i++) {
                    min = i;
                    for (var j = i + 1; j < $lis.length; j++) {

                        if (RightIndex == 1) {
                            if (Number($($lis[j]).attr('data-value')) < Number($($lis[min]).attr('data-value'))) {
                                min = j;
                            }
                        }
                        if (RightIndex == 2) {
                            if (Number($($lis[j]).attr('data-value-2')) < Number($($lis[min]).attr('data-value-2'))) {
                                min = j;
                            }
                        }
                        if (RightIndex == 3) {
                            if (Number($($lis[j]).attr('data-value-3')) < Number($($lis[min]).attr('data-value-3'))) {
                                min = j;
                            }
                        }
                    }
                    temp = $lis[i];
                    $lis[i] = $lis[min];
                    $lis[min] = temp;
                    $('.goods-list').append($lis[i].outerHTML);
                }
            }

            $('.goods-list li').each(function(i) {

                if ($(this).position().top == 0) {
                    KPIParse.setArea($(this).attr('data-id'));
                    if ($('#bar-container').height() > 0) {
                        KPIParse.setChart();
                    }
                }
            });
        },
        SortLeft: function(sort) {
            SortType = 1;
            if (sort == 'down') {
                $('.goods-wrapper-title-left').find('.triangle-xs').addClass('triangle-down-xs');
                $('.goods-wrapper-title-left').find('.triangle-xs').removeClass('triangle-up-xs');

                var $lis = $('.goods-list li');
                $('.goods-list').html('');

                var arr = new Array();
                for (var i = 0; i < $lis.length; i++) {
                    arr.push($($lis[i]).attr('data-name'));
                }

                var arr2 = arr.sort(function(a, b) {
                    return a.localeCompare(b);
                });

                for (var i = arr2.length - 1; i >= 0; i--) {
                    for (var j = 0; j < $lis.length; j++) {
                        if ($($lis[j]).attr('data-name') == arr2[i]) {
                            $('.goods-list').append($lis[j].outerHTML);
                        }
                    }
                }
            } else {
                $('.goods-wrapper-title-left').find('.triangle-down-xs').addClass('triangle-up-xs');
                $('.goods-wrapper-title-left').find('.triangle-down-xs').removeClass('triangle-down-xs');

                var $lis = $('.goods-list li');
                $('.goods-list').html('');


                var arr = new Array();
                for (var i = 0; i < $lis.length; i++) {
                    arr.push($($lis[i]).attr('data-name'));
                }
                var arr2 = arr.sort(function(a, b) {
                    return a.localeCompare(b);
                });

                for (var i = 0; i < arr2.length; i++) {
                    for (var j = 0; j < $lis.length; j++) {
                        if ($($lis[j]).attr('data-name') == arr2[i]) {
                            $('.goods-list').append($lis[j].outerHTML);
                        }
                    }
                }
            }

            $('.goods-list li').each(function(i) {
                if ($(this).position().top == 0) {
                    KPIParse.setArea($(this).attr('data-id'));
                    if ($('#bar-container').height() > 0) {
                        KPIParse.setChart();
                    }
                }
            });
        }
    };

    $('.goods-wrapper').bind("touchstart", function(event) {

        var e = event.originalEvent;
        StartY = e.touches[0].clientY;
        StartX = e.touches[0].clientX;
        StartTime = new Date().getTime();
        GoodsWrapperFlag = 1;
    });

    $('.area').bind("touchend", function(event) {

        event.stopPropagation();
        var e = event.originalEvent;
        var EndY = e.changedTouches[0].clientY;
        var EndX = e.changedTouches[0].clientX;
        var EndTime = new Date().getTime();

        if (GoodsWrapperFlag == 1) {
            var e = event.originalEvent;
            var EndY = e.changedTouches[0].clientY;

            if (GoodsWrapperFlag == 1 && EndY - StartY < 0) {

                var new_top = ($('.goods-list li').length - 1) * HeightLi;
                $('.goods-list').animate({
                    "scrollTop": new_top,
                }, "normal", function() {
                    KPIParse.setPosition();
                });
            }
        }

    });
    $('.goods-wrapper').bind("touchend", function(event) {

        GoodsWrapperFlag = 0;
        event.stopPropagation();
        var e = event.originalEvent;
        var EndY = e.changedTouches[0].clientY;
        var EndX = e.changedTouches[0].clientX;
        var EndTime = new Date().getTime();

        if (Math.abs(EndX - StartX) > 30) {
            return;
        }

        if (Math.abs(EndY - StartY) > HeightLi && EndTime - StartTime > HeightLi * 2 && EndTime - StartTime < 400) {

            var a = EndY - StartY;
            var b = EndTime - StartTime;

            var top = $('.goods-list').scrollTop();
            var new_top = 0;
            if (EndY - StartY < 0) {
                new_top = top + HeightLi * 2;
                new_top = Math.ceil(new_top / HeightLi) * HeightLi;

                var max_top = ($('.goods-list').find('li').length - 1) * HeightLi;
                if (new_top > max_top) {
                    new_top = max_top;
                }
                $('.goods-list').animate({
                    "scrollTop": new_top,
                }, "normal", function() {
                    KPIParse.setPosition();
                });
            } else {
                new_top = top - HeightLi * 2;
                new_top = Math.ceil(new_top / HeightLi) * HeightLi;
                if (new_top < 0) {
                    new_top = 0;
                }
                $('.goods-list').animate({
                    "scrollTop": new_top,
                }, "normal", function() {
                    KPIParse.setPosition();
                });
            }
        } else if (Math.abs(EndY - StartY) > 0) {

            var new_top = $('.goods-list').scrollTop();
            if (new_top % HeightLi > HeightLi / 2) {
                new_top = Math.ceil(new_top / HeightLi) * HeightLi;
            } else {
                new_top = Math.floor(new_top / HeightLi) * HeightLi;
            }

            if (new_top > (($('.goods-list li').length - 1) * HeightLi)) {
                new_top = ($('.goods-list li').length - 1) * HeightLi;
            }

            $('.goods-list').animate({
                "scrollTop": new_top,
            }, "fast", function() {
                KPIParse.setPosition();
            });

        }

    });

    $('.goods-wrapper').on('touchend', ".goods-list", function(ev) {
        ClickTimes++;
        setTimeout(function() {
            if (ClickTimes > 1) {
                var right_index = KPIParse.getRightIndex();
                var right_type = KPIParse.getRightType();

                if (right_type == 1) {
                    right_type = 2;
                } else {
                    right_type = 1;
                }
                KPIParse.setGoodsRight(right_index, right_type);
            }
            ClickTimes = 0;
        }, 100);
    });

    $('.area-body').on('touchstart', '.area-item', function(event) {
        event.stopPropagation();
        ClickTimes++;
        var $this = $(this);
        setTimeout(function() {
            if (ClickTimes > 1) { //双击事件
                KPIParse.setAreaItemActive($this.attr('data-item'));

                $('.area-title').html($this.find('.area-item-1').html());
                KPIParse.setGoodsWrapper();

                KPIParse.setChart();

                ChartFlag = 1;
            } else if (ClickTimes == 1) { //单击事件
                KPIParse.setAreaItemActive($this.attr('data-item'));
                $('.area-title').html($this.find('.area-item-1').html());
                KPIParse.setGoodsWrapper();
            }
            ClickTimes = 0;
        }, 200);

    });

    $('.goods-wrapper-title-right').on('touchend', function() {
        if ($(this).find('.triangle-down-xs').length == 1) {
            KPIParse.SortRight('up');
        } else {
            KPIParse.SortRight('down');
        }

    });

    $('.goods-wrapper-title-left').on('touchend', function() {
        if ($(this).find('.triangle-down-xs').length == 1) {
            KPIParse.SortLeft('up');
        } else {
            KPIParse.SortLeft('down');
        }
    });

    $('#bar-container').on('touchstart', function(event) {
        var $this = $(this);
        ClickTimes++;
        setTimeout(function() {
            if (ClickTimes > 1) {
                $this.animate({
                    "height": 0,
                });
            }
            ClickTimes = 0;
        }, 200);

    });

    $('.goods-wrapper-body').on('touchstart', function(event) {
        var e = event.originalEvent;
        StartX = e.touches[0].clientX;
        StarTime = new Date().getTime();
        StartY = e.touches[0].clientY;
    });

    //商品表左右切换
    $('.goods-wrapper-body').on('touchend', function(event) {

        $('.goods-li-right').removeClass('li-right');
        $('.goods-li-right-2').removeClass('li-right');
        $('.goods-li-right-3').removeClass('li-right');

        $('.goods-li-right').removeClass('li-left');
        $('.goods-li-right-2').removeClass('li-left');
        $('.goods-li-right-3').removeClass('li-left');

        var e = event.originalEvent;
        var EndX = e.changedTouches[0].clientX;
        var EndY = e.changedTouches[0].clientY;
        var EndTime = new Date().getTime();

        if (Math.abs(EndX - StartX) > 30 && EndTime - StarTime < 300 && Math.abs(EndY - StartY) < HeightLi) {
            if (EndX - StartX > 0) {
                RightIndex--;
                if (RightIndex < 1) {
                    RightIndex = 3;
                }

                if (RightIndex == 3) {

                    if (RightType == 1) {
                        $('.rectangle-3-value').css("display", "none");
                        $('.rectangle-3').css("display", "inline-block");
                    } else {

                        $('.rectangle-3-value').css("display", "inline-block");
                        $('.rectangle-3').css("display", "none");
                    }
                    $('.goods-li-right').hide();
                    $('.goods-li-right-3').show();
                    $('.rectangle-title').html('%');
                }
                if (RightIndex == 2) {
                    if (RightType == 1) {
                        $('.rectangle-2-value').css("display", "none");
                        $('.rectangle-2').css("display", "inline-block");
                    } else {
                        $('.rectangle-2-value').css("display", "inline-block");
                        $('.rectangle-2').css("display", "none");
                    }
                    $('.goods-li-right-3').hide();
                    $('.goods-li-right-2').show();
                    $('.rectangle-title').html('变化');
                }
                if (RightIndex == 1) {
                    if (RightType == 1) {
                        $('.rectangle-value').css("display", "none");
                        $('.rectangle').css("display", "inline-block");
                    } else {
                        $('.rectangle-value').css("display", "inline-block");
                        $('.rectangle').css("display", "none");
                    }
                    $('.goods-li-right-2').hide();
                    $('.goods-li-right').show();
                    $('.rectangle-title').html($('.area-item-active .area-item-1').html());
                }
                $('.goods-li-right').addClass('li-left');
                $('.goods-li-right-2').addClass('li-left');
                $('.goods-li-right-3').addClass('li-left');
            } else {
                RightIndex++;
                if (RightIndex > 3) {
                    RightIndex = 1;
                }
                if (RightIndex == 3) {
                    if (RightType == 1) {
                        $('.rectangle-3-value').css("display", "none");
                        $('.rectangle-3').css("display", "inline-block");
                    } else {
                        $('.rectangle-3-value').css("display", "inline-block");
                        $('.rectangle-3').css("display", "none");
                    }
                    $('.goods-li-right-2').hide();
                    $('.goods-li-right-3').show();
                    $('.rectangle-title').html('%');
                }
                if (RightIndex == 2) {
                    if (RightType == 1) {
                        $('.rectangle-2-value').css("display", "none");
                        $('.rectangle-2').css("display", "inline-block");
                    } else {
                        $('.rectangle-2-value').css("display", "inline-block");
                        $('.rectangle-2').css("display", "none");
                    }
                    $('.goods-li-right').hide();
                    $('.goods-li-right-2').show();
                    $('.rectangle-title').html('变化');
                }
                if (RightIndex == 1) {
                    if (RightType == 1) {
                        $('.rectangle-value').css("display", "none");
                        $('.rectangle').css("display", "inline-block");
                    } else {
                        $('.rectangle-value').css("display", "inline-block");
                        $('.rectangle').css("display", "none");
                    }
                    $('.goods-li-right-3').hide();
                    $('.goods-li-right').show();
                    $('.rectangle-title').html($('.area-item-active .area-item-1').html());
                }

                $('.goods-li-right').addClass('li-right');
                $('.goods-li-right-2').addClass('li-right');
                $('.goods-li-right-3').addClass('li-right');
            }
            KPIParse.setArea(KPIParse.getGoodsIndex());
            if ($('#bar-container').height() > 0) {
                KPIParse.setChart();
            }
        }
    });

    window.KPIParse.myChart.on('click', function(params) {

        $('.area-date').html(params.name);
        $('.goods-list').html('');
        for (var i = 0; i < KPIData.length; i++) {
            if (params.name == KPIData[i].period) {
                Period = i;
                break;
            }
        }

        for (var i = 0; i < KPIData[Period].products.length; i++) {
            if (KPIData[Period].products[i].name == GoodsName) {
                GoodsIndex = i;
                break;
            }
        }

        //设置商品列表
        KPIParse.setGoodsWrapper();
        KPIParse.setArea(KPIParse.getGoodsIndex());

        $('.area-date').attr('data-index', Period);
        $('.area-date').attr('data-time', params.name);

        $('.goods-list li').each(function(i) {
            if ($(this).attr('data-name') == GoodsName) {
                var top = i * HeightLi;
                $('.goods-list').scrollTop(top);
                var item = KPIData[Period].products[GoodsIndex].items[ItemIndex];
                KPIParse.setChartInfo(item);
            }
        });

        KPIParse.setHighLight();
    });

})(jQuery);

function toThousands(num) {
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
}

//商品列表 li的高度
$(function() {
    // sort xAxis data with xaxis_order
    window.TemplateData.sort(function(a, b) {
        var a_value = a.period,
            b_value = b.period;

        if(typeof(a.xaxis_order) !== 'undefined' && typeof(b.xaxis_order) !== 'undefined') {
            a_value = a.xaxis_order;
            b_value = b.xaxis_order;
        }

        if(a_value == b_value) {
            return 0;
        }

        return (a_value > b_value ? 1 : -1);
    });

    KPIParse.init(window.TemplateData, window.KPIColor);
});
