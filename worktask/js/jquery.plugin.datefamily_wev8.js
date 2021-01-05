/**
 * Created by 三杰lee on 2014/11/21.
 */

(function ($) {
	var languageid = readCookie("languageidweaver");
    //获取当前处于第几周
    Date.prototype.getWeek = function() {
        var onejan = new Date(this.getFullYear(),0,1);
        return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
    }
    
    //日期选择插件
    $.fn.dateSelect = function (options) {
        var currentyear;

        //获取当前处于第几周
        Date.prototype.getWeek = function() {
            var onejan = new Date(this.getFullYear(),0,1);
            return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
        }

        //返回一年所有周
        function getISOWeeks(year)
        {
            var firstDayOfYear = new Date(year, 0, 1);
            var days = firstDayOfYear.getDay() + (isLeapYear(year) ? 366 : 365);

            return Math.ceil(days/7)
        }

        function isLeapYear(year)
        {
            return (year % 4 === 0) && (year % 100 !== 0) || (year % 400 === 0);
        }

        //缓存body变量
        var docbody = $(document.body);
        var that = this;
        var defaultConfig = {
            datepanel: "month",
            yearpercolsize: 5,
            confirm:function(){

            }
        };
        //生成默认的配置信息
        var defaultOption = $.extend(defaultConfig, options);

        var confirmitem = "<div class='dpopbtn'><div class='dpconfirm'>"+SystemEnv.getHtmlNoteName(3451,languageid)+"</div><div class='splitline'></div><div class='dpcancell'>"+SystemEnv.getHtmlNoteName(3516,languageid)+"</div></div>";

        var pickerPanels = {

            getYearPickerPanel: function (startyear, yearnow) {
                var htmlarray = [], yearpicker, percolsize = defaultOption.yearpercolsize;
                htmlarray.push("<div class='picker'>");
                htmlarray.push("<div class='picker_option pagepre'><</div> <div class='picker_option pagenext'> >  </div>");
                htmlarray.push("<div class='picker_item left'></div><div class=' picker_item right'></div>");
                htmlarray.push("</div>");
                yearpicker = $(htmlarray.join(""));
                var leftcon = yearpicker.find(".left");
                var rightcon = yearpicker.find(".right");
                //生成新页
                function generateNewPage(beginyear) {
                    if (beginyear <= 0)
                        return;
                    leftcon.html("");
                    rightcon.html("");
                    for (var i = 0; i < percolsize; i++)
                        leftcon.append("<div class='" + (beginyear + i) + "'>" + (beginyear + i) + "</div>");
                    for (var i = 0; i < percolsize; i++)
                        rightcon.append("<div class='" + (beginyear + percolsize + i) + "'>" + (beginyear + percolsize + i) + "</div>");
                    if (yearnow >= beginyear && yearnow < beginyear + 10)
                        yearpicker.find("." + yearnow).addClass("dpactiveitem");
                    else {
                        yearpicker.find("." + beginyear).addClass("dpactiveitem");
                    }
                    //注册点击事件
                    yearpicker.find(".picker_item div").click(function () {
                        var currentitem = $(this);
                        yearpicker.find(".dpactiveitem").removeClass("dpactiveitem");
                        currentitem.addClass("dpactiveitem");
                    });
                }

                //生成第一页
                generateNewPage(startyear);
                //上一页
                yearpicker.find(".pagepre").click(function () {
                    startyear = startyear - 10;
                    generateNewPage(startyear);
                });
                //下一页
                yearpicker.find(".pagenext").click(function () {
                    startyear = startyear + 10;
                    generateNewPage(startyear);
                });
                return yearpicker;
            },

            showYearPicker: function () {
                //获取年
                var yearnow = new Date().getFullYear();
                var dateitem = that.find(".datevalue");
                if (dateitem.length === 0) {
                    that.append("<span class='datevalue' style='display: none'>" + yearnow + "</span>");
                } else {
                    yearnow = dateitem.html();
                }
                //开始年
                var beginyear = yearnow - ~~(yearnow + "").substring((yearnow + "").length - 1, (yearnow + "").length);
                var htmlarray = [], picker;

                picker = $("<div class='year dp_panel'></div>");
                //添加年面板
                picker.append(this.getYearPickerPanel(beginyear, yearnow));
                //添加操作按钮(确定,取消)
                picker.append($(this.getConfirmPicker()));
                return picker;

            }, showSeasonPicker: function () {
                var yearnow = new Date().getFullYear();
                //获取对应的季度
                var seasonnow =getSeasonNow();
                var dateitem = that.find(".datevalue");
                if (dateitem.length === 0) {
                    that.append("<span class='datevalue' style='display: none'>" + yearnow + "_" + seasonnow + "</span>");
                } else {
                    var datevalue = dateitem.html();
                    yearnow = datevalue.split("_")[0];
                    seasonnow = datevalue.split("_")[1];
                }
                var beginyear = yearnow - ~~(yearnow + "").substring((yearnow + "").length - 1, (yearnow + "").length);

                var seasonel = $(" <div class='season_seasons' ><div class='s1' season='1' >"+SystemEnv.getHtmlNoteName(4018,languageid)+"</div><div class='s2' season='2'>"+SystemEnv.getHtmlNoteName(4019,languageid)+"</div><div class='s3' season='3'>"+SystemEnv.getHtmlNoteName(4020,languageid)+"</div><div class='s4' season='4'>"+SystemEnv.getHtmlNoteName(4021,languageid)+"</div></div>");
                var picker = $("<div class='dpseason dp_panel'  ><div class='yearwrapper'></div></div>");
                var seasonwrapper = picker.find(".yearwrapper");
                var yearpicker = this.getYearPickerPanel(beginyear, yearnow);
                yearpicker.addClass("season_year");
                seasonwrapper.append(yearpicker).append(seasonel);

                seasonel.find(".s" + seasonnow).addClass("dpactiveitem");
                seasonel.find("div").click(function () {
                    var currentitem = $(this);
                    seasonel.find(".dpactiveitem").removeClass("dpactiveitem");
                    currentitem.addClass("dpactiveitem");
                });

                //添加操作按钮(确定,取消)
                picker.append($(this.getConfirmPicker()));
                return picker;
            }, showMonthPicker: function () {
                var cdate=new Date();
                var yearnow = cdate.getFullYear();
                var monthnow = cdate.getMonth()+1;
                var dateitem = that.find(".datevalue");
                if (dateitem.length === 0) {
                    that.append("<span class='datevalue' style='display: none'>" + yearnow + "_" + monthnow + "</span>");
                } else {
                    var datevalue = dateitem.html();
                    yearnow = datevalue.split("_")[0];
                    monthnow = datevalue.split("_")[1];
                }
                var beginyear = yearnow - ~~(yearnow + "").substring((yearnow + "").length - 1, (yearnow + "").length);

                var monthel = $(" <div class='months' ><div class='m1' month='1' >"+SystemEnv.getHtmlNoteName(4026,languageid)+"</div><div class='m7' month='7' >"+SystemEnv.getHtmlNoteName(4032,languageid)+"</div><div class='m2' month='2' >"+SystemEnv.getHtmlNoteName(4027,languageid)+"</div><div class='m8' month='8' >"+SystemEnv.getHtmlNoteName(4033,languageid)+"</div>" +
                "<div class='m3' month='3' >"+SystemEnv.getHtmlNoteName(4028,languageid)+"</div><div class='m9' month='9' >"+SystemEnv.getHtmlNoteName(4034,languageid)+"</div><div class='m4' month='4' >"+SystemEnv.getHtmlNoteName(4029,languageid)+"</div><div class='m10' month='10' >"+SystemEnv.getHtmlNoteName(4035,languageid)+"</div><div class='m5' month='5' >"+SystemEnv.getHtmlNoteName(4030,languageid)+"</div>" +
                "<div class='m11' month='11' >"+SystemEnv.getHtmlNoteName(4036,languageid)+"</div><div class='m6' month='6' >"+SystemEnv.getHtmlNoteName(4031,languageid)+"</div><div class='m12' month='12' >"+SystemEnv.getHtmlNoteName(4037,languageid)+"</div>");
                var picker = $("<div class='dpseason dp_panel'  ><div class='yearwrapper'></div></div>");

                var seasonwrapper = picker.find(".yearwrapper");
                var yearpicker = this.getYearPickerPanel(beginyear, yearnow);
                yearpicker.addClass("season_year");
                seasonwrapper.append(yearpicker).append(monthel);

                monthel.find(".m" + monthnow).addClass("dpactiveitem");
                monthel.find("div").click(function () {
                    var currentitem = $(this);
                    monthel.find(".dpactiveitem").removeClass("dpactiveitem");
                    currentitem.addClass("dpactiveitem");
                });

                //添加操作按钮(确定,取消)
                picker.append($(this.getConfirmPicker()));
                return picker;
                //周面板
            },getWeekPickerPanel:function(startweek,weeknow){
                var htmlarray = [], weekpicker, percolsize = defaultOption.yearpercolsize,leftcolsize,rightcolsize;
                htmlarray.push("<div class='picker  week_year'>");
                htmlarray.push("<div class='picker_option pagepre'><</div> <div class='picker_option pagenext'> >  </div>");
                htmlarray.push("<div class='picker_item left'></div><div class=' picker_item right'></div>");
                htmlarray.push("</div>");
                weekpicker = $(htmlarray.join(""));
                var leftcon = weekpicker.find(".left");
                var rightcon = weekpicker.find(".right");

                //生成新页
                function generateNewPage(beginweek) {
                    //总的周数
                    var weekall=getISOWeeks(currentyear);

                    if (beginweek <= 0 || beginweek>weekall)
                        return;

                    if(beginweek+2*percolsize<=weekall){
                        leftcolsize=percolsize;
                        rightcolsize=percolsize;
                    }else {
                        if(weekall-beginweek>percolsize){
                            leftcolsize=percolsize;
                            rightcolsize=weekall-beginweek+1;
                        }else{
                            leftcolsize=weekall-beginweek+1;
                            rightcolsize=0;
                        }
                    }

                    leftcon.html("");
                    rightcon.html("");
                    for (var i = 0; i < leftcolsize; i++)
                        leftcon.append("<div week='"+(beginweek + i)+"' class='" + (beginweek + i) + "'>" + (beginweek + i) + SystemEnv.getHtmlNoteName(4022,languageid)+"</div>");
                    for (var i = 0; i < rightcolsize; i++)
                        rightcon.append("<div week='"+(beginweek + leftcolsize + i)+"' class='" + (beginweek + leftcolsize + i) + "'>" + (beginweek + leftcolsize + i) + SystemEnv.getHtmlNoteName(4022,languageid)+"</div>");
                    if (weeknow >= beginweek && weeknow < beginweek + 10)
                        weekpicker.find("." + weeknow).addClass("dpactiveitem");
                    else {
                        weekpicker.find("." + beginweek).addClass("dpactiveitem");
                    }
                    //注册点击事件
                    weekpicker.find(".picker_item div").click(function () {
                        var currentitem = $(this);
                        weekpicker.find(".dpactiveitem").removeClass("dpactiveitem");
                        currentitem.addClass("dpactiveitem");
                    });
                }

                //生成第一页
                generateNewPage(startweek);
                //上一页
                weekpicker.find(".pagepre").click(function () {
                    startweek = startweek - 10;
                    generateNewPage(startweek);
                });
                //下一页
                weekpicker.find(".pagenext").click(function () {
                    startweek = startweek + 10;
                    generateNewPage(startweek);
                });
                return weekpicker;


            },showWeekPicker:function(){

                var cdate=new Date();
                var yearnow = cdate.getFullYear();
                var weeknow = cdate.getWeek();
                var dateitem = that.find(".datevalue");
                if (dateitem.length === 0) {
                    that.append("<span class='datevalue' style='display: none'>" + yearnow + "_" + weeknow + "</span>");
                } else {
                    var datevalue = dateitem.html();
                    yearnow = datevalue.split("_")[0];
                    weeknow = datevalue.split("_")[1];
                }
                var beginyear = yearnow - ~~(yearnow + "").substring((yearnow + "").length - 1, (yearnow + "").length);
                var beginweek;
                var weekendstr=(weeknow + "").substring((weeknow + "").length - 1, (weeknow + "").length);
                var weekstartstr=(weeknow + "").substring(0,1);
                if(weekendstr==='0'){
                    beginweek=~~weeknow-10+1;
                }else
                    beginweek = weeknow - ~~weekendstr+1;

                var picker = $("<div class='dpweek dp_panel'  ><div class='yearwrapper'></div></div>");

                var seasonwrapper = picker.find(".yearwrapper");
                var yearpicker = this.getYearPickerPanel(beginyear, yearnow);
                yearpicker.addClass("season_year");
                currentyear=yearnow;

                //周面板
                var weekpicker=this.getWeekPickerPanel(beginweek,weeknow);
                seasonwrapper.append(yearpicker).append(weekpicker);

                //添加操作按钮(确定,取消)
                picker.append($(this.getConfirmPicker()));
                return picker;

            }
            , showDatePicker: function () {

                //按钮操作区域
            }, getConfirmPicker: function () {

                return confirmitem;
            }
        }

        //弹出日期选择面板
        this.bind("click", function (e) {
            var panel;
            switch (defaultOption.datepanel) {
                case "year":
                    panel = pickerPanels.showYearPicker();
                    break;
                case "season":
                    panel = pickerPanels.showSeasonPicker();
                    break;
                case "month":
                    panel = pickerPanels.showMonthPicker();
                    break;
                case "week":
                    panel = pickerPanels.showWeekPicker();
                    break;
                case "day":
                    panel = pickerPanels.showDatePicker();
                    break;
                default :
                    break;
            }
            //根据事件对象进行定位
            var left = e.clientX + docbody.scrollLeft();
            var top = e.clientY + docbody.scrollTop();
            panel.css("left", left);
            panel.css("top", top);

            panel.find(".dpconfirm").click(function () {
                if (defaultOption.datepanel === 'year') {
                    var yearvalue = $(".dp_panel").find(".dpactiveitem").html();
                    that.html(yearvalue + SystemEnv.getHtmlNoteName(3480,languageid) + "<span class='datevalue' style='display: none'>" + yearvalue + "</span>");
                    $(".dp_panel").remove();
                    defaultOption.confirm.call(that,defaultOption.datepanel,yearvalue);
                } else if (defaultOption.datepanel === 'season') {
                    var yearvalue = $(".dp_panel .season_year").find(".dpactiveitem").html();
                    var seasonvalue = $(".dp_panel .season_seasons").find(".dpactiveitem").attr("season");
                    that.html(yearvalue + SystemEnv.getHtmlNoteName(3480,languageid) + seasonvalue +SystemEnv.getHtmlNoteName(4017,languageid)+"<span class='datevalue' style='display: none'>" + yearvalue + "_" + seasonvalue + "</span>");
                    $(".dp_panel").remove();
                    defaultOption.confirm.call(that,defaultOption.datepanel,yearvalue,seasonvalue);
                } else if (defaultOption.datepanel === 'month') {
                    var yearvalue = $(".dp_panel .season_year").find(".dpactiveitem").html();
                    var monthvalue = $(".dp_panel .months").find(".dpactiveitem").attr("month");
                    that.html(yearvalue + SystemEnv.getHtmlNoteName(3480,languageid) + monthvalue + SystemEnv.getHtmlNoteName(3481,languageid)+"<span class='datevalue' style='display: none'>" + yearvalue + "_" + monthvalue + "</span>");
                    $(".dp_panel").remove();
                    defaultOption.confirm.call(that,defaultOption.datepanel,yearvalue,monthvalue);
                }else if (defaultOption.datepanel === 'week') {
                    var yearvalue = $(".dp_panel .season_year").find(".dpactiveitem").html();
                    var weekvalue = $(".dp_panel .week_year").find(".dpactiveitem").attr("week");
                    that.html(yearvalue + SystemEnv.getHtmlNoteName(3480,languageid) + weekvalue + SystemEnv.getHtmlNoteName(4022,languageid)+"<span class='datevalue' style='display: none'>" + yearvalue + "_" + weekvalue + "</span>");
                    $(".dp_panel").remove();
                    defaultOption.confirm.call(that,defaultOption.datepanel,yearvalue,weekvalue);
                }
            });
            panel.find(".dpcancell").click(function () {
                $(".dp_panel").remove();
            });

            docbody.append(panel);
        });

        switch(defaultOption.datepanel){
            case "year":initYear();break;
            case "month":initMonth();break;
            case "season":initSeason();break;
            case "week":initWeek();break;
        }


        docbody.bind('mousedown', function (e) {
            if ($(e.target).parents(".dp_panel").length <= 0 && !$(e.target).hasClass(".dp_panel")) {
                $(".dp_panel").remove();
            }
        })
        //获取当前所属季度
        function getSeasonNow(){
            var seasons="1";
            var monthnow=new Date().getMonth();
            if(monthnow>=0 && monthnow<=2)
                seasons="1";
            else if(monthnow>=3 && monthnow<=5)
                seasons="2";
            else if(monthnow>=6 && monthnow<=8)
                seasons="3";
            else if(monthnow>=9 && monthnow<=11)
                seasons="4";
            return seasons;
        }
        //初始化年
        function initYear(){
            var yearnow=new Date().getFullYear();
            that.html(yearnow + SystemEnv.getHtmlNoteName(3480,languageid) + "<span class='datevalue' style='display: none'>" + yearnow + "</span>");
        }
        //初始化月
        function initMonth(){
            var cdate=new Date();
            var yearnow=cdate.getFullYear();
            var month=cdate.getMonth()+1;
            that.html(yearnow + SystemEnv.getHtmlNoteName(3480,languageid) + month +SystemEnv.getHtmlNoteName(3481,languageid)+"<span class='datevalue' style='display: none'>" + yearnow + "_" + month + "</span>");
        }
        //初始化季度
        function initSeason(){
            var cdate=new Date();
            var yearnow=cdate.getFullYear();
            var seasons=getSeasonNow();
            that.html(yearnow + SystemEnv.getHtmlNoteName(3480,languageid) + seasons + SystemEnv.getHtmlNoteName(4017,languageid)+"<span class='datevalue' style='display: none'>" + yearnow + "_" + seasons + "</span>");
        }
        //初始化周
        function initWeek(){
            var cdate=new Date();
            var yearnow=cdate.getFullYear();
            var weeknow=cdate.getWeek();
            that.html(yearnow + SystemEnv.getHtmlNoteName(3480,languageid)+ weeknow + SystemEnv.getHtmlNoteName(4022,languageid)+"<span class='datevalue' style='display: none'>" + yearnow + "_" + weeknow + "</span>");
        }


    }

})(jQuery);


