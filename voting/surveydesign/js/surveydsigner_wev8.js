/**
 * Created with JetBrains WebStorm.
 * User: lsj
 * Date: 14-8-13
 * Time: 下午2:14
 * To change this template use File | Settings | File Templates.
 */

var surveydsigner = (function () {
    var pageContainer = new Map();
    var pageCount = 1;

    var currentPage;

    var surveytitle = "";
    var clonequestion = null;

    var designerset = {};
    var   BGTHEIGHT=90+"";
    var   BGBHEIGHT=50+"";

    designerset.pagebgset = {index:"0",bgcolor: "#ffffff", bgimg: "",isrepeat:"0","bgpicbottomheight":"90","bgpictopheight":"50"};
    designerset.pagelogoset = {index:"1",bgcolor: "#ffffff", bgimg: "",isrepeat:"0"};
    designerset.pageset = {index:"2",bgcolor: "#ffffff", bgimg: "",isrepeat:"0", pagewidth: "780", fontcolor: "#000000"};
    designerset.pagetitleset = {index:"3",bgcolor: "#ffffff", fontfamily: "", fontsize: "18px", fontcolor: "#19a8ee", fontbold: "", fontitalic: "", fontalign: ""};
    designerset.pagequestionset = {index:"4",bgcolor: "#eff3f9", fontfamily: "", fontsize: "14px", fontcolor: "#616f8f", fontbold: "", fontitalic: "", fontalign: ""};
    designerset.pageoptionset = {index:"5",fontfamily: "", fontsize: "12px", fontcolor: "#000000", fontbold: "", fontitalic: "", fontalign: ""};


    //设置背景图片
    function setBgImage(currentsetitem){
        var bgimg= currentsetitem.bgimg;
		if(currentsetitem.index==='0'){
            if(currentsetitem.bgpictopheight)
            $(".survey_editor").css("margin-top",currentsetitem.bgpictopheight+"px");
            if(currentsetitem.bgpicbottomheight)
            $(".survey_editor").css("margin-bottom",currentsetitem.bgpicbottomheight+"px");
        }
        var container;
        if(bgimg){
            if(currentsetitem.index==='0'){
                container=$(".survey_content");
			 //  $(".survey_editor").css("margin-top",currentsetitem.bgpictopheight+"px");
             //  $(".survey_editor").css("margin-bottom",currentsetitem.bgpicbottomheight+"px");
             //   $(".survey_editor").css("margin-top","200px");
            }else if(currentsetitem.index==='1'){
                container=$(".survey-logo");
            } else if(currentsetitem.index==='2'){
                container= $(".survey_page");
            }
            container.css("background-image","url("+bgimg+")");
            if(currentsetitem.isrepeat==='0'){
                container.css("background-repeat","no-repeat");
            }else{
                container.css("background-repeat","repeat");
            }
            container.css("background-position","50% 0%");
        }

    }


    //背景色
    function showBgColor(currentsetitem){
        var   bgimg=currentsetitem.bgimg;
        //设置页面背景色
        if(currentsetitem.index==='0'){
            $(".survey_content").css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //logo背景色
        }else if(currentsetitem.index==='1'){
            $(".survey-logo").css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //调查页面背景色
        }else if(currentsetitem.index==='2'){
            $(".survey_page").css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //调查标题设置背景色
        }else if(currentsetitem.index==='3'){
            $(".survery_head").css("background",currentsetitem.bgcolor);
            //调查题目设置背景色
        }else if(currentsetitem.index==='4'){
            $(".survery_component").find(".title").css("background",currentsetitem.bgcolor);
        }
    }
    //设置字体及其大小
    function  setFontInfo(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey-title");
            title.css("font-family",currentsetitem.fontfamily);
            title.css("font-size",currentsetitem.fontsize);
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survery_component").find(".subject");
            title.css("font-family",currentsetitem.fontfamily);
            title.css("font-size",currentsetitem.fontsize);
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survery_component");
            var labels=title.find(".options label");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);
            labels=title.find(".optionstable  td");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);
            labels=title.find(".optionstable  th");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);
            labels=title.find(".optionstable  label");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);
        }
    }

    //设置字体颜色
    function  setFontColor(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey-title");
            title.css("color",currentsetitem.fontcolor);
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survery_component").find(".subject");
            title.css("color",currentsetitem.fontcolor);
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survery_component");
            var labels=title.find(".options label");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable  td");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable  th");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable  label");
            labels.css("color",currentsetitem.fontcolor);
        }
    }
    //设置粗体
    function  setFontBold(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey-title");
            if(currentsetitem.fontbold==='1'){
                title.css("font-weight","bold");
            }else{
                title.css("font-weight","normal");
            }
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survery_component").find(".subject");
            if(currentsetitem.fontbold==='1'){
                title.css("font-weight","bold");
            }else{
                title.css("font-weight","normal");
            }
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survery_component");
            var labels=title.find(".options label");
            if(currentsetitem.fontbold==='1'){
                labels.css("font-weight","bold");
            }else{
                labels.css("font-weight","normal");
            }
            labels=title.find(".optionstable  td");
            if(currentsetitem.fontbold==='1'){
                labels.css("font-weight","bold");
            }else{
                labels.css("font-weight","normal");
            }
            labels=title.find(".optionstable  th");
            if(currentsetitem.fontbold==='1'){
                labels.css("font-weight","bold");
            }else{
                labels.css("font-weight","normal");
            }
            labels=title.find(".optionstable  label");
            if(currentsetitem.fontbold==='1'){
                labels.css("font-weight","bold");
            }else{
                labels.css("font-weight","normal");
            }
        }

    }

    //设置斜体
    function  setFontItalic(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey-title");
            if(currentsetitem.fontitalic==='1'){
                title.css("font-style","italic");
            }else{
                title.css("font-style","normal");
            }
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survery_component").find(".subject");
            if(currentsetitem.fontitalic==='1'){
                title.css("font-style","italic");
            }else{
                title.css("font-style","normal");
            }
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survery_component");
            var labels=title.find(".options label");
            if(currentsetitem.fontitalic==='1'){
                labels.css("font-style","italic");
            }else{
                labels.css("font-style","normal");
            }
            labels=title.find(".optionstable  td");
            if(currentsetitem.fontitalic==='1'){
                labels.css("font-style","italic");
            }else{
                labels.css("font-style","normal");
            }
            labels=title.find(".optionstable  th");
            if(currentsetitem.fontitalic==='1'){
                labels.css("font-style","italic");
            }else{
                labels.css("font-style","normal");
            }
            labels=title.find(".optionstable  label");
            if(currentsetitem.fontitalic==='1'){
                labels.css("font-style","italic");
            }else{
                labels.css("font-style","normal");
            }
        }
    }

    //设置对齐方式
    function  setAlign(currentsetitem,direction){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey-title");
            title.css("text-align",direction);
            currentsetitem.fontalign=direction;
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survery_component").find(".title");
            title.css("text-align",direction);
            currentsetitem.fontalign=direction;
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survery_component");
            var labels=title.find(".options li");
            labels.css("text-align",direction);
            labels=title.find(".optionstable  td");
            labels.css("text-align",direction);
            labels=title.find(".optionstable  th");
            labels.css("text-align",direction);
            currentsetitem.fontalign=direction;
        }
    }

    return {
        //首次设计
        firstDesign: function () {
            var pagefirstuuid = new UUID();
            currentPage = new Page(pagefirstuuid, pageCount);
            pageContainer.put(pagefirstuuid, currentPage);
            //选中新页面
            $("#surveytree").find(".current").removeClass("current");
            currentPage.pagemenu.find(".pagenode").addClass("current");

            var surveyhead = new SueveyTitleQuestion();
			surveyhead.setting.title= surveysubject;
            surveyhead.geneartorQuestion();

            surveydsigner.setTitle(surveyhead);
            surveydsigner.getCurrentPage().addTitle(surveyhead);
        },
        //恢复设计器问题选项
        recoverDesign: function (pages) {
            var that = this;
            var page;
            var uuid;
            var questions;
            var question;
            var options;
            var option;
            var setting;
            var questiontype;
            var optiontemp;
            var questiontoadd;
            var hasException=true;
	    var currentPagenum = 0;	    
            for (var pagenum in  pages) {
                hasException=false;
                //第一页
                if (currentPagenum == 0) {
                    uuid = new UUID();
                    currentPage = new Page(uuid, ~~pagenum);
                    pageContainer.put(uuid, currentPage);
                    //选中新页面
                    $("#surveytree").find(".current").removeClass("current");
                    currentPage.pagemenu.find(".pagenode").addClass("current");

                    //添加头标题
                    var surveyhead = new SueveyTitleQuestion();
                    that.setTitle(surveyhead);

					var __key = 0;

					try{


						for(var key in pages[pagenum]){
							if(__key > parseInt(key)){
								__key = key;
							}
						} 


						surveyhead.setting.title = pages[pagenum][__key].surveyname;
					}catch(e){
					}

                    
                    surveyhead.geneartorQuestion();
                    surveyhead.restoreSettingPanel();

                    that.getCurrentPage().addTitle(surveyhead);

                } else {
                    page = that.addNewPage();
                }
                questions = pages[pagenum];
                
                currentPagenum++;
                
                while(currentPagenum != pagenum){
                	page = that.addNewPage();
                	currentPagenum++;
                }
                
                for (var questionorder in  questions) {
                    question = questions[questionorder];
                    questiontype = question.questiontype;
                    setting = {};
                    //选择题
                    setting.qid = question.quesionid;
                    setting.pagenum = pagenum;
                    setting.showorder = question.showorder;
                    if (questiontype === "0") {
                        setting.ismustinput = question.ismustinput;
                        setting.israndomsort = question.israndomsort;
                        setting.limit = question.limit;
                        setting.max = question.max;
                        setting.name = question.name;
                        setting.perrowcols = question.perrowcols;
                        setting.questiontype = question.questiontype;
                        setting.type = question.type;
                        setting.isother=question.isother;
                        setting.options = [];
                        setting.imageWi = question.imageWidth;
                        setting.imageHi = question.imageHeight;
                        //组合选择
                    } else if (questiontype === "1") {
                        setting.ismustinput = question.ismustinput;
                        setting.name = question.name;
                        setting.questiontype = question.questiontype;
                        setting.type = question.type;
                        setting.rows = [];
                        setting.cols = [];
                        //说明
                    } else if (questiontype === "2") {
                        setting.content = question.name;
                        setting.name = question.name;
                        setting.questiontype = questiontype;
                        if(question.options){
                        	//setting.oid = question.options[0].opid;
                        	setting.options = [{
                        		oid : question.options[0].opid
                        	}];
                        }
                       //填空
                    } else if (questiontype === "3") {
                        setting.content = question.name;
                        setting.name = question.name;
                        setting.questiontype = questiontype;
                        if(question.options){
                        	//setting.oid = question.options[0].opid;
                        	setting.options = [{
                        		oid : question.options[0].opid
                        	}];
                        }
                        setting.ismustinput= question.ismustinput;
                    }
                    //设置选项信息
                    for (var optionorder in  question.options) {
                        option = question.options[optionorder];
                        optiontemp = {};
                        optiontemp.oid = option.opid;
                        optiontemp.label = option.oplabel;
                        optiontemp.oinner = option.oinner;
                        if (questiontype === "0") {
                            if(option.images){
                            	optiontemp.images = option.images;
                            }
                            if(option.attrs){
                            	optiontemp.attrs = option.attrs;
                            }
                            if(option.remark){
                            	optiontemp.remark = option.remark;
                            	optiontemp.remarkorder = option.remarkorder;
                            }
                            setting.options.push(optiontemp);
                        } else if (questiontype === "1") {
                            if (option.roworcolumn === '0') {
                                setting.rows.push(optiontemp);
                            } else {
                                setting.cols.push(optiontemp);
                            }
                        }
                    }

                    //添加问题
                    if (questiontype === "0") {
                        questiontoadd = new SignalSelectQuestion(new UUID());
                    } else if (questiontype === "1") {
                        questiontoadd = new MatrixQuestion(new UUID());
                    } else if (questiontype === "2") {
                        questiontoadd = new SueveyIntroduceQuestion(new UUID());
                    } else if(questiontype === "3"){
                        questiontoadd = new BlankfillingQuestion(new UUID());
                    }
                    questiontoadd.setting = setting;
                    //获取当前页,并添加问题
                    that.getCurrentPage().addQuestion(questiontoadd);
                    questiontoadd.geneartorQuestion();
                    questiontoadd.restoreSettingPanel();
                    questiontoadd.refreshQuestionMenu();
                }

            }
            if(hasException) that.firstDesign();
        //恢复样式设置
        },recoverDesignSet:function(viewset){
              if(!viewset)
              return;
              designerset=viewset;
              for(var item in viewset){
                  setBgImage(viewset[item]);
                  setAlign(viewset[item],viewset[item].fontalign);
                  setFontBold(viewset[item]);
                  setFontColor(viewset[item]);
                  setFontInfo(viewset[item]);
                  setFontItalic(viewset[item]);
                  showBgColor(viewset[item]);
              }
        },
        //初始化设计器
        initDesigner: function (flag, pages,viewset) {
        	 var surveyheight = $(window).height() - 30;
            $(".survey_container").css("height", surveyheight + 'px');
            $(".survey_content").css("height", (surveyheight - 60) + 'px');
        
            var that = this;

            //默认间距
            $(".survey_editor").css("margin-top",BGTHEIGHT+"px");
            $(".survey_editor").css("margin-bottom",BGBHEIGHT+"px");

            if (flag === 0) {
                that.firstDesign();
            } else {
                //恢复面板
                that.recoverDesign(pages);
                that.recoverDesignSet(viewset);
            }


            //分页添加可拖拽
            $("#surveytree").sortable({
                stop: function (event, ui) {
                    //刷新页面菜单
                    var pageId = jQuery(ui.item[0]).attr("page-id");
                    var fromPage = surveydsigner.getPageByUuid(pageId).getPageCount();
                    surveydsigner.refreshPageInfos();
                    pageId = jQuery(ui.item[0]).attr("page-id");
                    var toPage = surveydsigner.getPageByUuid(pageId).getPageCount();
                    if(fromPage != toPage){
                    	doDragPage(fromPage,toPage);
                    }
                }
            }).disableSelection();


            //初始化页面背景设置
            function initPagebgset() {
                var pagebgset = designerset.pagebgset;
                var bgcolor = pagebgset.bgcolor;
                var isrepeat = pagebgset.isrepeat;
                $("input[name='viewsetbgcolor']").val(bgcolor);
                $(".survey_bgcolor").css("background", bgcolor);
                if (isrepeat === '1') {
                    $("input[name='isrepeat']").prop("checked", true);
                } else {
                    $("input[name='isrepeat']").prop("checked", false);
                }
                $("input[name='bgpicbottomheight']").val(pagebgset.bgpicbottomheight);
                $("input[name='bgpictopheight']").val(pagebgset.bgpictopheight);
            }

            //初始化页面logo设置
            function initPagelogoset() {
                var pagelogo = designerset.pagelogoset;
                var bgcolor = pagelogo.bgcolor;
                var isrepeat = pagelogo.isrepeat;
                $("input[name='viewsetbgcolor']").val(bgcolor);
                $(".survey_bgcolor").css("background", bgcolor);
                if (isrepeat === '1') {
                    $("input[name='isrepeat']").prop("checked", true);
                } else {
                    $("input[name='isrepeat']").prop("checked", false);
                }
            }

            //初始化调查表设置
            function initPageset() {
                var pageset = designerset.pageset;
                var bgcolor = pageset.bgcolor;
                var isrepeat = pageset.isrepeat;
                var pagewidth = pageset.pagewidth;
                var ftcolor = pageset.fontcolor;
                $("input[name='viewsetbgcolor']").val(bgcolor);
                if (isrepeat === '1') {
                    $("input[name='isrepeat']").prop("checked", true);
                } else {
                    $("input[name='isrepeat']").prop("checked", false);
                }
                $("input[name='pagewidth']").val(pagewidth);
                $("input[name='viewsetftcolor']").val(ftcolor);
                $(".survey_bgcolor").css("background", bgcolor);
                $(".survey_ftcolor").css("background", ftcolor);
            }

            //初始化调查表标题
            function initPagetitleset() {
                var pagetitleset = designerset.pagetitleset;
                var bgcolor = pagetitleset.bgcolor;
                var fontfamily = pagetitleset.fontfamily;
                var fontsize = pagetitleset.fontsize;
                var fontcolor = pagetitleset.fontcolor;
                var fontbold = pagetitleset.fontbold;
                var fontita = pagetitleset.fontitalic;
                var alignset = pagetitleset.fontalign;
                $("input[name='viewsetbgcolor']").val(bgcolor);
                $("select[name='surveyfamily']").val(fontfamily);
                $("select[name='surveyfontsize']").val(fontsize);
                $("input[name='viewsetftcolor']").val(fontcolor);
                $(".survey_bgcolor").css("background", bgcolor);
                $(".survey_ftcolor").css("background", fontcolor);
            }

            //初始化题目标题
            function initPagequestionset() {
                var pagequestionset = designerset.pagequestionset;
                var bgcolor = pagequestionset.bgcolor;
                var fontfamily = pagequestionset.fontfamily;
                var fontsize = pagequestionset.fontsize;
                var fontcolor = pagequestionset.fontcolor;
                var fontbold = pagequestionset.fontbold;
                var fontita = pagequestionset.fontitalic;
                var alignset = pagequestionset.fontalign;
                $("input[name='viewsetbgcolor']").val(bgcolor);
                $("select[name='surveyfamily']").val(fontfamily);
                $("select[name='surveyfontsize']").val(fontsize);
                $("input[name='viewsetftcolor']").val(fontcolor);
                $(".survey_bgcolor").css("background", bgcolor);
                $(".survey_ftcolor").css("background", fontcolor);

            }

            //初始化选项文字
            function initPageoptionset() {
                var pageoptionset = designerset.pageoptionset;
                var fontfamily = pageoptionset.fontfamily;
                var fontsize = pageoptionset.fontsize;
                var fontcolor = pageoptionset.fontcolor;
                var fontbold = pageoptionset.fontbold;
                var fontita = pageoptionset.fontitalic;
                var alignset = pageoptionset.fontalign;
                $("select[name='surveyfamily']").val(fontfamily);
                $("select[name='surveyfontsize']").val(fontsize);
                $("input[name='viewsetftcolor']").val(fontcolor);
                $(".survey_ftcolor").css("background", fontcolor);

            }

            //内容与外观
            $(".survey_opitem").click(function (e) {
                var target = $(e.target);
                target.parent().find(".current").removeClass("current");
                target.addClass("current");
                //编辑内容
                if (target.hasClass("s_content")) {
                    $(".survey_toobar").find(".seditor").show();
                    $(".survey_toobar").find(".sview").hide();
                    $(".survey_viewset").hide();
                } else if (target.hasClass("s_view")) {
                    $(".survey_toobar").find(".seditor").hide();
                    $(".survey_toobar").find(".sview").show();
                    $(".survey_viewset").show();
                    $(".sview").find(".pagebgset").trigger("click");
                }

            });
            //外观设置点击事件
            $(".sview li").click(function () {
                var citem = $(this);
                var viewset = $(".survey_viewset");
                $(".sview").find(".survey_viewsetcurrent").removeClass("survey_viewsetcurrent");
                citem.addClass("survey_viewsetcurrent");
                viewset.find("li").hide();
                //页面背景
                if (citem.hasClass("pagebgset")) {
                    viewset.find(".survey_bgcolorset").show();
                    viewset.find(".survey_bgpicset").show();
					viewset.find(".survey_bgset").show();
                    initPagebgset();
                    //logo
                } else if (citem.hasClass("pagelogoset")) {
                    viewset.find(".survey_bgcolorset").show();
                    viewset.find(".survey_bgpicset").show();
                    initPagelogoset();
                    //页面设置
                } else if (citem.hasClass("pageset")) {
                    viewset.find(".survey_bgcolorset").show();
                    viewset.find(".survey_bgpicset").show();
                    viewset.find(".survey_pagewidthset").show();
                  //  viewset.find(".survey_fontcolorset").show();
                    initPageset();
                    //标题设置
                } else if (citem.hasClass("pagetitleset")) {
                    viewset.find(".survey_bgcolorset").show();
                    viewset.find(".survey_fontset").show();
                    viewset.find(".survey_fontcolorset").show();
                    viewset.find(".survey_fontstyleset").show();
                    viewset.find(".survey_alignset").show();
                    initPagetitleset();
                    //题目标题
                } else if (citem.hasClass("pagequestionset")) {
                    viewset.find(".survey_bgcolorset").show();
                    viewset.find(".survey_fontset").show();
                    viewset.find(".survey_fontcolorset").show();
                    viewset.find(".survey_fontstyleset").show();
                    viewset.find(".survey_alignset").show();
                    initPagequestionset();
                    //选项文字
                } else if (citem.hasClass("pageoptionset")) {
                    viewset.find(".survey_fontset").show();
                    viewset.find(".survey_fontcolorset").show();
                    viewset.find(".survey_fontstyleset").show();
                    viewset.find(".survey_alignset").show();
                    initPageoptionset();
                }

            });

            //获取当前要设置的json对象
            function getCurrentSetItem() {
                var currentsetitem = $(".survey_viewsetcurrent");
                if (currentsetitem.hasClass("pagebgset")) {
                    return  designerset.pagebgset;
                } else if (currentsetitem.hasClass("pagelogoset")) {
                    return   designerset.pagelogoset;
                } else if (currentsetitem.hasClass("pageset")) {
                    return  designerset.pageset;
                } else if (currentsetitem.hasClass("pagetitleset")) {
                    return  designerset.pagetitleset;
                } else if (currentsetitem.hasClass("pagequestionset")) {
                    return  designerset.pagequestionset;
                } else if (currentsetitem.hasClass("pageoptionset")) {
                    return  designerset.pageoptionset;
                }

            }


             //调色板
            var colorpic = $(".surveycolor").spectrum({
                allowEmpty: true,
                showPalette: true,
                showInput: true,
                chooseText: "确定",
                cancelText: "取消",
                palette: [
                    ["#000000", "#434343", "#666666", "#999999", "#b7b7b7", "#cccccc", "#d9d9d9", "#efefef", "#f3f3f3", "#ffffff"],
                    ["#980000", "#ff0000", "#ff9900", "#ffff00", "#00ff00", "#00ffff", "#4a86e8", "#0000ff", "#9900ff", "#ff00ff"],
                    ["#e6b8af", "#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d9ead3", "#c9daf8", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                    ["#dd7e6b", "#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#a4c2f4", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                    ["#cc4125", "#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6d9eeb", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                    ["#a61c00", "#cc0000", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3c78d8", "#3d85c6", "#674ea7", "#a64d79"],
                    ["#85200c", "#990000", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#1155cc", "#0b5394", "#351c75", "#741b47"],
                    ["#5b0f00", "#660000", "#783f04", "#7f6000", "#274e13", "#0c343d", "#1c4587", "#073763", "#20124d", "#4c1130"]
                ],
                show: function () {
                    var that = $(this);
                    $(".sp-container").css("width", "240px");
                    var colornow;
                    //主要有背景色和字体颜色两种
                    if (that.hasClass("survey_bgcolor")) {
                        colornow = $("input[name='viewsetbgcolor']").val();
                    } else if (that.hasClass("survey_ftcolor")) {
                        colornow = $("input[name='viewsetftcolor']").val();
                    }

                    colorpic.spectrum("set", colornow);
                },
                hide: function (color) {
                    //  console.dir($(this));
                    //   $(this).css("background",color.toHexString());

                }, move: function (color) {
                    var that = $(this);
                    var cnow;
                    if(color ==null || color==''){
                        cnow = "transparent";
                    }else{
                        cnow = color.toHexString();
                    }
                    that.css("background", cnow);
                    var currentitem = getCurrentSetItem();
                    if (that.hasClass("survey_bgcolor")) {
                        currentitem.bgcolor = cnow;
                        $("input[name='viewsetbgcolor']").val(cnow);
                        showBgColor(currentitem);
                    } else if (that.hasClass("survey_ftcolor")) {
                        currentitem.fontcolor = cnow;
                        $("input[name='viewsetftcolor']").val(cnow);
                        setFontColor(currentitem);
                    }
                },
                change: function (color) {
                    var that = $(this);
                    var cnow;
                    if(color ==null || color==''){
                        cnow = "transparent";
                    }else{
                        cnow = color.toHexString();
                    }
                    that.css("background", cnow);
                    var currentitem = getCurrentSetItem();
                    if (that.hasClass("survey_bgcolor")) {
                        currentitem.bgcolor = cnow;
                        $("input[name='viewsetbgcolor']").val(cnow);
                        showBgColor(currentitem);
                    } else if (that.hasClass("survey_ftcolor")) {
                        currentitem.fontcolor = cnow;
                        $("input[name='viewsetftcolor']").val(cnow);
                        setFontColor(currentitem);
                    }
                }
            });
            //采用的字体
            $("select[name='surveyfamily']").change(function () {
                var currentitem = getCurrentSetItem();
                currentitem.fontfamily = $(this).val();
                setFontInfo(currentitem);
            });
            //字体大小
            $("select[name='surveyfontsize']").change(function () {
                var currentitem = getCurrentSetItem();
                currentitem.fontsize = $(this).val();
                setFontInfo(currentitem);
            });

            //粗体
            $("button[name='font-weight']").click(function () {
                var currentitem = getCurrentSetItem();
                var fw= currentitem.fontbold;
                if(fw==='1'){
                    currentitem.fontbold='0';
                }else{
                    currentitem.fontbold='1';
                }
                setFontBold(currentitem);
            });

            //斜体
            $("button[name='font-style']").click(function () {
                var currentitem = getCurrentSetItem();
                var fw= currentitem.fontitalic;
                if(fw==='1'){
                    currentitem.fontitalic='0';
                }else{
                    currentitem.fontitalic='1';
                }
                setFontItalic(currentitem);
            });
            //设置左右居中对齐
            $(".survey_alignset button").click(function(){
                  var currentitem = getCurrentSetItem();
                  var datavalue=$(this).attr("data-value");
                  setAlign(currentitem,datavalue);

            });
            //设置调查问卷的宽度
            $("input[name='pagewidth']").blur(function(){
                 var pwidth=$(this).val();
                var currentitem = getCurrentSetItem();
                pwidth= ~~pwidth;
                if(pwidth!==0){
                    currentitem.pagewidth=pwidth;
                    $(".survey_editor").css("width",pwidth+"px");
                }

            });
            //底部高度
            $("input[name='bgpicbottomheight']").blur(function(){
                var bgpicbottomheight=$(this).val();
                var currentitem = getCurrentSetItem();
                bgpicbottomheight= ~~bgpicbottomheight;
                if(bgpicbottomheight!==0){
                    currentitem.bgpicbottomheight=bgpicbottomheight;
                    $(".survey_editor").css("margin-bottom",bgpicbottomheight+"px");
                }
            });

            //顶部高度
            $("input[name='bgpictopheight']").blur(function(){
                var bgpictopheight=$(this).val();
                var currentitem = getCurrentSetItem();
                bgpictopheight= ~~bgpictopheight;
                if(bgpictopheight!==0){
                    currentitem.bgpictopheight=bgpictopheight;
                    $(".survey_editor").css("margin-top",bgpictopheight+"px");
                }
            });


            //设置是否平铺
            $(".survey_bgpicset").find("input[name='isrepeat']").click(function(){
                  var currentitem = getCurrentSetItem();
                  //选中
                  if($(this).is(":checked")){
                      currentitem.isrepeat='1';
                  }else{
                      currentitem.isrepeat='0'
                  }
                  setBgImage(currentitem);
            });

            //背景添加可拖拽
            $( "#imgpopup" ).draggable({ handle: ".head" });

            //添加背景图片
            $(".survey_bgpicset .bgimg-preview-inner").click(function(){

                $("#imgpopup").bPopup({opacity: 0.2,modalClose:false});
                //打开批量设置面板
                $.ajax({
                    data: {},
                    type: "POST",
                    url: "/voting/surveydesign/pages/ThemeInfo.jsp",
                    timeout: 20000,
                    dataType: 'json',
                    success: function(rs){
                       var ul=$(".imgcontainer ul");
                       //清空容器
                       ul.html("");
                       var li;
                       //打开批量设置面板
                       for(var i=0;i<rs.length;i++){
                           li=$("<li> <img src='"+rs[i]+"' ></li>");
                           ul.append(li);
                       }

                    },fail:function(){
                        alert('背景图片资源获取失败!');
                    }
                });
            });
            //点击选中图片
            $(".imgcontainer ul").delegate("li",'click',function(){
                    $(".imgcontainer ul").find("li").removeClass("imgselected");
                    $(this).addClass("imgselected");
            });

            //确认背景图片操作
            $("#imgpopup  .confirm").click(function(){
                //获取当前设置对象
                var currentitem = getCurrentSetItem();
                var selectitem=$(".imgcontainer .imgselected");
                if(selectitem.length<1)
                  return ;
                currentitem.bgimg=selectitem.find("img").attr("src");
                $("#imgpopup .b-close").trigger("click");
                setBgImage(currentitem);

            }) ;
            //取消操作
            $("#imgpopup  .cancel").click(function(){
                $("#imgpopup .b-close").trigger("click");
            }) ;
			 //清除背景图片
            $("#imgpopup  .clearbgimg").click(function(){
                var currentitem = getCurrentSetItem();
                currentitem.bgimg="";
                if(currentitem.index==='0')
                $(".survey_content").css("background-image","url('')");
                else
                $(".survey_page").css("background-image","url('')");
            }) ;



            //保存调查问卷
            $(".surveysave").click(function () {

                surveydsigner.saveSurveyInfo();

            });

            //预览界面
            $(".preview").click(function () {
                //先做存储,再做预览
               // var that = surveydsigner;
                //获取模板设置
              //  var params = that.getSurveyParams();
               // that.addLoadingIcon($(document.body));
                var dlg=new window.top.Dialog();//定义Dialog对象
                dlg.Model=true;
                 dlg.maxiumnable=true;
           　　　dlg.Width=960;//定义长度
                 dlg.Height=800;
                 var votingid=$("input[name='votingid']").val();
           　　　dlg.URL="/voting/surveydesign/pages/surveypreview.jsp?votingid="+votingid;
           　　　dlg.Title="问卷调查";
           　　　dlg.show();
           
           
           
           return;
                $.ajax({
                    data: params,
                    type: "POST",
                    url: "/voting/VotingContentOperation.jsp",
                    timeout: 20000,
                    dataType: 'json',
                    success: function (rs) {
                        if (rs.success === '1') {
                            that.removeLoadingIcon($(document.body));
                            //预览打开窗口
                            var dlg=new window.top.Dialog();//定义Dialog对象
                            var votingid=$("input[name='votingid']").val();
                            // dialog.currentWindow = window;
                      　　　dlg.Model=true;
                            dlg.maxiumnable=true;
                      　　　dlg.Width=960;//定义长度
                            dlg.Height=800;
                      　　　dlg.URL="/voting/surveydesign/pages/surveypreview.jsp?votingid="+votingid;
                      　　　dlg.Title="问卷调查";
                      　　　dlg.show();
                        } else {
                            that.removeLoadingIcon($(document.body));
                            alert('保存失败');
                        }
                    }, fail: function () {
                        that.removeLoadingIcon($(document.body));
                        alert('保存失败');
                    }
                });

            });

            //收缩
            $(".survey_inside").click(function () {
                $(".survey_menu").hide();
                $(".survey_outsidecontainer").show();
                $(".survey_wrapper").css("margin-left", "-21px");
                $(".survey_body").css("margin-left", "21px");
            });
            //展开
            $(".survey_outside").click(function () {
                $(".survey_outsidecontainer").hide();
                $(".survey_menu").show();
                $(".survey_wrapper").css("margin-left", "-231px");
                $(".survey_body").css("margin-left", "231px");
            });

            $(".survery_component").mouseover(function () {

                $(this).addClass("hover");
                $(this).find(".survey_buttons").show();
            }).mouseleave(function () {
                    $(this).removeClass("hover");
                    $(this).find(".survey_buttons").hide();
                });


            //新建一页
            $(".addnewpage").click(function () {

                surveydsigner.addNewPage("clickBtn");

            });

            //添加问题
            $(".survery_question").click(function () {
                var target = $(this);
                var question;
                //单选
                if (target.hasClass("select")) {
                    question = new SignalSelectQuestion(new UUID());
                } else if (target.hasClass("matrix")) {
                    question = new MatrixQuestion(new UUID());
                } else if (target.hasClass("introduce")) {
                    question = new SueveyIntroduceQuestion(new UUID());
                } else  if(target.hasClass("blankfilling")){
                    question = new BlankfillingQuestion(new UUID());
                }
                question.addnew = "1";
                //获取当前页,并添加问题
                surveydsigner.getCurrentPage().addQuestion(question);

            });
            //确认批量选项设置
            $("#popup .confirm").click(function () {
                var qusuuid = $("#popup").find("input[type='hidden'][name='qusuuid']").val();
                var roworcolumn = $("#popup").find("input[type='hidden'][name='roworcolumn']").val();
                //获取问题对象
                var question = surveydsigner.getCurrentPage().getQuestionByKey(qusuuid);

                //设置面板已有的选项
                var optionscurrent = [];
                var lists;
                //选择题
                if (roworcolumn === '-1') {
                    lists = question.questionset.find(".list  li");
                }
                //组合选择  问题
                else if (roworcolumn === '0') {
                    lists = question.questionset.find(".row_options .list  li");
                }
                //组合选择  选项
                else if (roworcolumn === '1') {
                    lists = question.questionset.find(".col_options .list  li");
                }
                var label;
                var optiontemp;
               /* for (var i = 0; i < lists.length; i++) {
                    label = $(lists[i]).find("input[name='label']").val();
                    if ("" !== label) {
                        optiontemp = {};
                        optiontemp.label = label;
                        optionscurrent.push(optiontemp);
                    }
                }*/
                //正则替换,获取每行的条目
                var values = $("textarea[name='options']").val().replace(/\n/g, "<br/>").split('<br/>');
                for (var i = 0; i < values.length; i++) {
                    optiontemp = {};
                    if ("" !== values[i]) {
                        optiontemp.label = values[i];
                        //添加选项
                        optionscurrent.push(optiontemp);
                    }
                }

                question.restoreOptions(optionscurrent, roworcolumn);
                $("#popup .b-close").trigger("click");
            });

            //取消批量设置
            $("#popup .cancel").click(function () {
                $("#popup .b-close").trigger("click");
            });

            //问题清单点击事件
            $("#surveytree").click(function (e) {
                e.stopPropagation();
                e.preventDefault();
                var target = $(e.target);
                //展开
                if (target.hasClass("i_page_open")) {

                    target.parents(".page").find(".parts").hide();
                    target.removeClass("i_page_open").addClass("i_page_close");
                    return;
                }
                //关闭
                if (target.hasClass("i_page_close")) {
                    target.parents(".page").find(".parts").show();
                    target.removeClass("i_page_close").addClass("i_page_open");
                    return;
                }
                //点击页面
                if (target.hasClass("pagenode") || target.parents(".pagenode").length > 0) {
                    var pageid = target.parents(".page").attr("page-id");
                    var currentpage = surveydsigner.getPageByUuid(pageid);
                    //选中当前页
                    $("#surveytree").find(".current").removeClass("current");
                    currentpage.pagemenu.find(".pagenode").addClass("current");
                    //设置当前页
                    surveydsigner.setCurrentPage(currentpage);
                    //展示当前页面
                    surveydsigner.showCurentPage();
                    // alert('pageselected');
                    return;

                }
                //选中问题
                if (target.hasClass("part") || target.parents(".part").length > 0) {
                    var qusid;
                    if (target.parents(".part").length) {
                        qusid = target.parents(".part").attr("id");
                    } else {
                        qusid = target.attr("id");
                    }
                    var pageid = target.parents(".page").attr("page-id");
                    var page = surveydsigner.getPageByUuid(pageid);
                    var question = page.getQuestionByKey(qusid);
                    //设置当前选中页
                    surveydsigner.setCurrentPage(page);
                    //展示当前页
                    surveydsigner.showCurentPage();
                    //转到对应的问题
                    page.toQuestion(question);
                }
            });

            //左边树菜单项点击事件
            //上移
            $(".survey_menu").find(".up").click(function () {
                var currentmenu = $("#surveytree").find(".current");
                var page;
                //页面上移
                if (currentmenu.hasClass("pagenode")) {
                    var pageid = currentmenu.parent().attr("page-id");
                    page = that.getPageByUuid(pageid);
                    page.up();
                   // that.refreshPageInfos();
                } else {
                    //问题上移
                    //存在上个节点
                    var prev = currentmenu.prev();
                    var quesid;
                    var questionnow;
                    quesid = currentmenu.attr("id");
                    questionnow = currentPage.getQuestionByKey(quesid);
                    //本页面移动
                    if (prev.length > 0) {
                        questionnow.questionview.find(".survey_buttons .up").trigger("click");
                    } else {
                        //移到上个页面的最后(存在上个页面)
                        prev = currentPage.pagemenu.prev();
                        if (prev.length > 0) {
	                        var questiontoadd;
				     		var prevpage = that.getPageByUuid(prev.attr("page-id"));
	                        var votingId = jQuery("input[name='votingid']").val();
	                        surveydsigner.addLoadingIcon($(document.body));
							jQuery.ajax({
						     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=order&objType=question",
						     	type : "post",
						     	data : {qid : questionnow.setting.qid,fromPage : currentPage.getPageCount(),toPage : prevpage.getPageCount(),votingId : votingId},
						     	dataType : "json",
						     	success : function(data){
						     		if(!data || data.flag == "0"){
						     			surveydsigner.removeLoadingIcon($(document.body))
						     			window.top.Dialog.alert("移动失败!");
						     			return;
						     		}
		                            var cpage = currentPage;
		                            that.setCurrentPage(prevpage);
		                            that.showCurentPage();
		                            questiontoadd = questionnow.getQuestionCopy();
		                            cpage.removeQuestion(questionnow);
		                            //获取前面页面的所有问题
		                            var prequestions = prevpage.pagemenu.find(".part");
		                            if (prequestions.length > 0) {
		                                var ques = prevpage.getQuestionByKey($(prequestions[prequestions.length - 1]).attr("id"));
		                                prevpage.selectQuestionNow(ques);
		                                that.setCurrentPage(prevpage);
		                            }
		                            prevpage.addQuestion(questiontoadd);
		                            questiontoadd.geneartorQuestion();
		                            questiontoadd.restoreSettingPanel();
		                            questiontoadd.refreshQuestionMenu();
		                            prevpage.selectQuestionNow(questiontoadd);
		                            questiontoadd.setting.pagenum = prevpage.getPageCount();
		                            questiontoadd.setting.showorder = prevpage.getPageQuestions().length - 1;
		                            var questions = cpage.getPageQuestions();
		                            for(var i = 0;i < questions.length;i++){
		                            	if(questions[i].setting && !questions[i].setting.showorder)continue;
		                            	questions[i].setting.showorder -= 1;
		                            }
						     	},
						     	error : function(){
						     		surveydsigner.removeLoadingIcon($(document.body));
						     		window.top.Dialog.alert("移动失败!");
						     	},
						     	complete : function(){
						     		surveydsigner.removeLoadingIcon($(document.body));
						     	}
						     	
						    });
                        }
                    }
                }
            });
            //下移动操作
            $(".survey_menu").find(".down").click(function () {
                var currentmenu = $("#surveytree").find(".current");
                var page;
                //页面上移
                if (currentmenu.hasClass("pagenode")) {
                    var pageid = currentmenu.parent().attr("page-id");
                    page = that.getPageByUuid(pageid);
                    page.down();
                    //that.refreshPageInfos();
                } else {
                    var after = currentmenu.next();
                    var quesid;
                    var questionnow;
                    quesid = currentmenu.attr("id");
                    questionnow = currentPage.getQuestionByKey(quesid);
                    //本页面移动
                    if (after.length > 0) {
                        questionnow.questionview.find(".survey_buttons .down").trigger("click");
                    } else {
                        var questiontoadd;
                        //移到下个页面的最前面
                        after = currentPage.pagemenu.next();
                        //存在下页
                        if (after.length > 0) {
                            var afterpage = that.getPageByUuid(after.attr("page-id"));
                            var votingId = jQuery("input[name='votingid']").val();
                            surveydsigner.addLoadingIcon($(document.body));
							jQuery.ajax({
						     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=order&objType=question",
						     	type : "post",
						     	data : {qid : questionnow.setting.qid,fromPage : currentPage.getPageCount(),toPage : afterpage.getPageCount(),votingId : votingId},
						     	dataType : "json",
						     	success : function(data){
						     		if(!data || data.flag == "0"){
						     			surveydsigner.removeLoadingIcon($(document.body))
						     			window.top.Dialog.alert("移动失败!");
						     			return;
						     		}
						     		//1移除该问题  2.向下个页面添加该问题 3.显示下个页面该问题
		                            questiontoadd = questionnow.getQuestionCopy();
		                            //删除该问题
		                            currentPage.removeQuestion(questionnow);
		                            //该分页下所有的问题节点
		                            var afternodes = after.find(".part");
		                            //添加问题菜单
		                            if (afternodes.length > 0) {
		                                var qid = $(afternodes[0]).attr("id");
		                                var qobj = afterpage.getQuestionByKey(qid);
		                                //将菜单插在该节点之前
		                                questiontoadd.questionmenu.insertBefore($(afternodes[0]));
		                                //将该节点置于第一个
		                                //questiontoadd.up(qobj)
		                                
									    //移动问题
									    questiontoadd.questionview.insertBefore(qobj.questionview);
									    questiontoadd.questionset.insertAfter(questiontoadd.questionview);
									    //移动菜单
									    questiontoadd.questionmenu.insertBefore(qobj.questionmenu);
									    if(questiontoadd.questiontype==='2'){
									        //初始化html编辑器
									        questiontoadd.initHtmlEditor();
									    }
									    //滚动条滚动到响应的问题
									    surveydsigner.getCurrentPage().toQuestion(questiontoadd);
									    
									    var questions = afterpage.getPageQuestions();
									    for(var i = 0 ; i < questions.length;i++){
									    	if(questions[i].setting && !questions[i].setting.showorder)continue;
									    	questions[i].setting.showorder = parseInt(questions[i].setting.showorder) + 1;
									    }
		                            } else {
		                                //下一页无节点
		                                afterpage.pagemenu.find(".parts").append(questiontoadd.questionmenu);
		                                //添加显示和设置面板
		                                var surveypage = $(".survey_page");
		                                surveypage.append(questiontoadd.questionview);
		                                surveypage.append(questiontoadd.questionset);
		                            }
									that.setCurrentPage(afterpage);
		                            that.showCurentPage();
		                            //隐藏其它问题的设置选项
		                            afterpage.hideAllOtherSetting();
		                            //初始化问题设置
		                            questiontoadd.initQuestion();
		
		                            questiontoadd.refreshQuestionMenu();
		                            questiontoadd.geneartorQuestion();
		                            questiontoadd.restoreSettingPanel();
		
		                            //添加问题到容器
		                            afterpage.listcontainer.push(questiontoadd);
		                            //向map里面添加问题
		                            afterpage.container.put(questiontoadd.uuid, questiontoadd);
		                            //选中当前问题
		                            afterpage.selectQuestionNow(questiontoadd);
		                            
		                            questiontoadd.setting.pagenum = afterpage.getPageCount();
		                            questiontoadd.setting.showorder = 1;
						     	},
						     	error : function(){
						     		surveydsigner.removeLoadingIcon($(document.body));
						     		window.top.Dialog.alert("移动失败!");
						     	},
						     	complete : function(){
						     		surveydsigner.removeLoadingIcon($(document.body));
						     	}
						     });

                        }

                    }

                }

            });
            //剪切(针对问题节点)
            $(".survey_menu").find(".cut").click(function () {
                var quesid;
                var question;
                var currentmenu = $("#surveytree").find(".current");
                if (currentmenu.hasClass("part")) {
                    quesid = currentmenu.attr("id");
                    question = currentPage.getQuestionByKey(quesid);
                   // currentPage.removeQuestion(question);
                   // currentPage.pagemenu.find(".pagenode").trigger("click");
                   //$(".survey_menu").find(".delete").click();
                   
                   window.top.Dialog.confirm("确定剪切吗?",function(){
		            	doDelete(question,"cut");
		            });
                }
            });
            //复制(针对问题节点)
            $(".survey_menu").find(".copy").click(function () {
                var quesid;
                var question;
                var currentmenu = $("#surveytree").find(".current");
                if (currentmenu.hasClass("part")) {
                    quesid = currentmenu.attr("id");
                    question = currentPage.getQuestionByKey(quesid);
                    question.questionview.find(".survey_buttons .copy").trigger("click");
                }

            });
            //黏贴(针对问题节点)
            $(".survey_menu").find(".paste").click(function () {
                var quesid;
                var question;
                var currentmenu = $("#surveytree").find(".current");
                if (currentmenu.hasClass("part")) {
                    quesid = currentmenu.attr("id");
                    question = currentPage.getQuestionByKey(quesid);
                    question.questionview.find(".survey_buttons .paste").trigger("click");
                }
            });

            //黏贴(删除问题节点)
            $(".survey_menu").find(".delete").click(function () {
                var quesid;
                var question;
                var pageid;
                var currentmenu = $("#surveytree").find(".current");
                if (currentmenu.hasClass("part")) {
                    quesid = currentmenu.attr("id");
                    question = currentPage.getQuestionByKey(quesid);
                    /*if (currentmenu.prev().length > 0) {
                        currentmenu.prev().trigger("click");
                    } else if (currentmenu.next().length > 0) {
                        currentmenu.next().trigger("click");
                    } else {
                        currentmenu.parents(".page").find(".pagenode").trigger("click");
                    }*/
                   // question.questionview.find(".survey_buttons .remove").trigger("click");
                   window.top.Dialog.confirm("确定删除吗?",function(){
		            	doDelete(question,"delete");
		            });
                } else if (currentmenu.hasClass("pagenode")) {
                    //删除页面
                    var pages = $("#surveytree").find(".page");
                    if (pages.length <= 1)
                        return;
                     window.top.Dialog.confirm("确定删除当前页吗?",function(){
		            	doDeletePage(currentmenu);
		            });    
                }

            });


        },
        setTitle: function (title) {
            surveytitle = title;
        },
        setCurrentPage: function (cpage) {
            currentPage = cpage;
        },
        getCurrentPage: function () {
            return   currentPage;
        }, getPageByUuid: function (uuid) {
            return  pageContainer.get(uuid);
        }, setCloneQuestion: function (question) {
            clonequestion = question;
        }, getQuestionCopy: function () {
            //获取问题副本
            return   clonequestion.getQuestionCopy();
        },
        //删除分页
        removePageByUuid: function (uuid) {
            //先删问题,在删页面信息
            var page = pageContainer.get(uuid);
            var questions = page.listcontainer;
            for (var i = 1; i < questions.length; i++) {
                page.removeQuestion(questions[i]);
            }
            page.page = null;
            page.pagemenu.remove();
            pageContainer.remove(uuid);
        },
        //更新页面信息
        refreshPageInfos: function () {
            var pageitems = $("#surveytree").find(".page");
            var page;
            var pageid;
            for (var i = 0; i < pageitems.length; i++) {
                pageid = $(pageitems[i]).attr("page-id");
                page = surveydsigner.getPageByUuid(pageid);
                page.setPageCount(i + 1);
                //刷新页面信息
                page.refreshPageCount();
                var questions = page.getPageQuestions();
                for(var j = 0;j < questions.length;j++){
                	if(questions[j].setting && !questions[j].setting.pagenum)continue;
                	questions[j].setting.pagenum = page.getPageCount();
                }
            }
        },
        //添加加载图标
        addLoadingIcon: function (container) {
            var width = $(window).width();
            var height = $(window).height();
            var iconleft = width / 2 - 16;
            var icontop = height / 2 - 16;
            var icon = $("<div class='loadingicon' style='position: fixed;z-index: 10;left: 0px;top: 0px;width: " + width + "px;height:" + height + "px'><div  style='z-index: 100;position: absolute;left:" + iconleft + "px;top:" + icontop + "px'><img src='/voting/surveydesign/images/loading_wev8.gif'></div></div>")
            container.append(icon);
        }, removeLoadingIcon: function (container) {
            container.find(".loadingicon").remove();
        }, getSurveyParams: function () {
            var that=this;
            //获取调查设置模板
            var params = {};
            //获取样式设置信息
            params.designerset = JSON.stringify(designerset);
            //获取标题
            params.surveysubject=surveytitle.setting.title;

            //调查id
            var votingid = $("input[name='votingid']").val();
            params.votingid = votingid;
            
            return params;
            
            var pagecount = 0;
            //获取所有的分页信息
            var pages=$("#surveytree").find(".page");
            var questionmunus;
            var page;
            var pagemenu;
            var questionmenu;
            var question;
            var questions;
            var options;
            var questionparam;
            var optionparam;

            for(var i=0;i<pages.length;i++){
                pagemenu=$(pages[i]);
                //获取页面对象
                page= that.getPageByUuid(pagemenu.attr("page-id"));
                questionmunus=pagemenu.find(".parts .part");
                questions = page.getPageQuestions();
                pagecount=i+1;
                //记录页面问题个数
                params["p_" + pagecount + "_qcount"] = questions.length - 1;
                for(var m=0;m<questionmunus.length;m++){
                     questionmenu=$(questionmunus[m]);
                     //获取问题对象
                     question=page.getQuestionByKey(questionmenu.attr("id"));
                     //设置问题信息
                     questionparam = "p_" + pagecount + "_q_" + m;
                    //选择题
                    if (question.questiontype === '0') {
                        params[questionparam + "_subject"] = question.setting.name;
                        params[questionparam + "_ismulti"] = question.setting.type;
                        params[questionparam + "_ismustinput"] = question.setting.ismustinput;
                        params[questionparam + "_limit"] = question.setting.limit;
                        params[questionparam + "_max"] = question.setting.max;
                        params[questionparam + "_perrowcols"] = question.setting.perrowcols;
                        params[questionparam + "_israndomsort"] = question.setting.israndomsort;
                        params[questionparam + "_isother"] = question.setting.isother;
                    } else if (question.questiontype === '1') {
                        params[questionparam + "_subject"] = question.setting.name;
                        params[questionparam + "_ismulti"] = question.setting.type;
                        params[questionparam + "_ismustinput"] = question.setting.ismustinput;
                        params[questionparam + "_limit"] = "-1";
                        params[questionparam + "_max"] = "-1";
                        params[questionparam + "_perrowcols"] = "-1";
                        params[questionparam + "_israndomsort"] = "-1";
                        //说明
                    } else if (question.questiontype === '2') {
                        params[questionparam + "_subject"] = question.setting.content;
                        params[questionparam + "_ismulti"] = "-1";
                        params[questionparam + "_ismustinput"] = "-1";
                        params[questionparam + "_limit"] = "-1";
                        params[questionparam + "_max"] = "-1";
                        params[questionparam + "_perrowcols"] = "-1";
                        params[questionparam + "_israndomsort"] = "-1";
                        //填空
                    } else if (question.questiontype === '3') {
                        params[questionparam + "_subject"] = question.setting.content;
                        params[questionparam + "_ismulti"] = "-1";
                        params[questionparam + "_ismustinput"] =question.setting.ismustinput;
                        params[questionparam + "_limit"] = "-1";
                        params[questionparam + "_max"] = "-1";
                        params[questionparam + "_perrowcols"] = "-1";
                        params[questionparam + "_israndomsort"] = "-1";
                    }
                    params[questionparam + "_showorder"] = m+1;
                    params[questionparam + "_questiontype"] = question.questiontype;
                    params[questionparam + "_pagenum"] = pagecount;
                    params[questionparam + "_questioncount"] = (questions.length - 1);

                    //问题类型=说明类型
                    if ("2" === question.questiontype) {
                        var content = question.setting.content;
                        params[questionparam + "_optioncount"] = "1";
                        optionparam = questionparam + "_o_0";
                        params[optionparam + "_description"] = content;
                        params[optionparam + "_optioncount"] = "1";
                        params[optionparam + "_showorder"] = "0";
                        params[optionparam + "_roworcolumn"] = "-1";
                        //问题类型=填空题
                    }else if ("3" === question.questiontype) {
                        var content = question.setting.content;
                        params[questionparam + "_optioncount"] = "1";
                        optionparam = questionparam + "_o_0";
                        params[optionparam + "_description"] = content;
                        params[optionparam + "_optioncount"] = "1";
                        params[optionparam + "_showorder"] = "0";
                        params[optionparam + "_roworcolumn"] = "-1";
                    } else
                    //问题类型=选择题类型
                    if ("0" === question.questiontype) {
                        options = question.setting.options;
                        //问题选项个数
                        params[questionparam + "_optioncount"] = (options.length);
                        for (var j = 0; j < options.length; j++) {
                            optionparam = questionparam + "_o_" + j;
                            params[optionparam + "_description"] = (options[j].label);
                            params[optionparam + "_optioncount"] = options.length;
                            params[optionparam + "_showorder"] = j;
                            params[optionparam + "_roworcolumn"] = "-1";
                        }
                        //组合类型
                    } else if ("1" === question.questiontype) {
                        options =question.setting.cols;
                        var opcount = 0;
                        var opsum = 0;
                        opsum =question.setting.cols.length +question.setting.rows.length;
                        //问题选项个数
                        params[questionparam + "_optioncount"] = opsum;
                        for (var j = 0; j < options.length; j++) {
                            optionparam = questionparam + "_o_" + j;
                            params[optionparam + "_description"] = (options[j].label);
                            params[optionparam + "_optioncount"] = opsum;
                            params[optionparam + "_showorder"] = j;
                            //列选项
                            params[optionparam + "_roworcolumn"] = "1";
                            opcount++;
                        }
                        options = question.setting.rows;
                        //问题选项个数
                        //  params[questionparam + "_optioncount"] = (options.length);
                        for (var j = 0; j < options.length; j++) {
                            optionparam = questionparam + "_o_" + (j + opcount);
                            params[optionparam + "_description"] = (options[j].label);
                            params[optionparam + "_optioncount"] = opsum;
                            params[optionparam + "_showorder"] = (j + opcount);
                            //行选项
                            params[optionparam + "_roworcolumn"] = "0";
                        }
                       }
                 }
            }
            params["pagecount"] = pagecount;
            return  params;

        },
        //保存调查设置信息
        saveSurveyInfo: function () {
            var that = this;
            var params = that.getSurveyParams();
            //    console.dir(params);
            that.addLoadingIcon($(document.body));
            $.ajax({
                data: params,
                type: "POST",
                url: "/voting/VotingContentOperation.jsp",
                timeout: 20000,
                dataType: 'json',
                success: function (rs) {
            	    if(rs.__msg__){
            	    	that.removeLoadingIcon($(document.body));
            	    	window.top.Dialog.alert(rs.__msg__);
            	    }else if (rs.success === '1') {
                        that.removeLoadingIcon($(document.body));
                        window.top.Dialog.alert("保存成功!");
                    } else {
                        window.top.Dialog.alert("保存失败!");
                    }
                }, fail: function () {
                    window.top.Dialog.alert("保存失败!");
                }
            });

        }, addNewPage: function (ty) {
            //新建分页
            var pagenum = currentPage.getPageCount();
            pagenum++;
            var cuuid = currentPage.uuid;
            var pageel = $("li[page-id='" + cuuid + "']");
            var nextall = pageel.nextAll();
            var uuidtemp;
            var pagetemp;
            for (var i = 0; i < nextall.length; i++) {
                uuidtemp = $(nextall[i]).attr("page-id");
                pagetemp = pageContainer.get(uuidtemp);
                //更新页码
                pagetemp.updatePageCount();
            }
            //新页面
            var pageNow = new Page(new UUID(), pagenum);
            pageContainer.put(pageNow.uuid, pageNow);
            currentPage = pageNow;
            //添加页头
            pageNow.addTitle(surveytitle);
            //选中新页面
            $("#surveytree").find(".current").removeClass("current");
            pageNow.pagemenu.find(".pagenode").addClass("current");
            //展示该页面
            this.showCurentPage();
            if(ty == "clickBtn"){
				var votingId = jQuery("input[name='votingid']").val();
				surveydsigner.addLoadingIcon($(document.body));
				jQuery.ajax({
			     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=addPage",
			     	type : "post",
			     	data : {pagenum : pagenum,votingId : votingId},
			     	dataType : "json",
			     	success : function(data){
			     		if(!data || data.flag == "0"){
			     			surveydsigner.removeLoadingIcon($(document.body))
			     			return;
			     		}
			     	},
			     	error : function(){
			     		surveydsigner.removeLoadingIcon($(document.body));
			     		window.top.Dialog.alert("添加失败!");
			     	},
			     	complete : function(){
			     		surveydsigner.removeLoadingIcon($(document.body));
			     	}
			     });
		     }
            return  pageNow;
        },
        //展示当前页面
        showCurentPage: function () {
            var pagetemp;
            var questions;
            var pcontainer = pageContainer.getContainer();
            for (var uuid in pcontainer) {
                pagetemp = pcontainer[uuid];
                if (currentPage !== pagetemp) {
                    //隐藏所有的问题和设置
                    questions = pagetemp.listcontainer;
                    for (var i = 1; i < questions.length; i++) {
                        //隐藏问题
                        questions[i].hideQuestion();
                        //隐藏问题设置
                        questions[i].hideQuestionSetting();
                    }
                }
            }
            questions = currentPage.listcontainer;
            for (var i = 1; i < questions.length; i++) {
                //隐藏问题
                questions[i].showQuestion();
                //隐藏问题设置
                questions[i].hideQuestionSetting();
            }
        }

    }

})();