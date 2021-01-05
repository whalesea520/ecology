/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 14-8-20
 * Time: 下午5:13
 * To change this template use File | Settings | File Templates.
 */
jQuery.fn.serializeObject = function() {
    var arrayData, objectData;
    arrayData = this.serializeArray();
    objectData = {};

    $.each(arrayData, function() {
        var value;

        if (this.value != null) {
            value = this.value;
        } else {
            value = '';
        }

        if (objectData[this.name] != null) {
            if (!objectData[this.name].push) {
                objectData[this.name] = [objectData[this.name]];
            }

            objectData[this.name].push(value);
        } else {
            objectData[this.name] = value;
        }
    });

    return objectData;
};

var survey = (function () {

    var pagequestions=[];

    //问题序号
    var questionnum=0;

    //不合法提示类
    var S_REMINDINFO="remindinfo";


    //背景色
    function showBgColor(currentsetitem){
        var   bgimg=currentsetitem.bgimg;
        //设置页面背景色
        if(currentsetitem.index==='0'){
            $(document.body).css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //logo背景色
        }else if(currentsetitem.index==='1'){
            $(".survey-logo").css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //调查页面背景色
        }else if(currentsetitem.index==='2'){
            $(".survey_body").css("background",currentsetitem.bgcolor);
            setBgImage(currentsetitem);
            //调查标题设置背景色
        }else if(currentsetitem.index==='3'){
            $(".survey_title").css("background",currentsetitem.bgcolor);
            //调查题目设置背景色
        }else if(currentsetitem.index==='4'){
            $(".survey_question").find(".survey_quesname").css("background",currentsetitem.bgcolor);
        }
    }

    //设置字体及其大小
    function  setFontInfo(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey_title");
            title.css("font-family",currentsetitem.fontfamily);
            title.css("font-size",currentsetitem.fontsize);
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survey_question").find(".survey_quesnamedes");
            title.css("font-family",currentsetitem.fontfamily);
            title.css("font-size",currentsetitem.fontsize);
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survey_question");

            var  labels=title.find(".optionstable  td");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);

            labels=title.find(".optionstable  label");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);

            labels=title.find(".optionstable  th");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);

            labels=title.find(".options label");
            labels.css("font-family",currentsetitem.fontfamily);
            labels.css("font-size",currentsetitem.fontsize);

        }
    }

    //设置字体颜色
    function  setFontColor(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey_title");
            title.css("color",currentsetitem.fontcolor);
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survey_question").find(".survey_quesnamedes");
            title.css("color",currentsetitem.fontcolor);
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survey_question");
            var labels=title.find(".options label");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable  td");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable  th");
            labels.css("color",currentsetitem.fontcolor);
            labels=title.find(".optionstable label");
            labels.css("color",currentsetitem.fontcolor);
        }
    }

    //设置粗体
    function  setFontBold(currentsetitem){
        var title;
        //调查标题设置字体和大小
        if(currentsetitem.index==='3'){
            title=$(".survey_title");
            if(currentsetitem.fontbold==='1'){
                title.css("font-weight","bold");
            }else{
                title.css("font-weight","normal");
            }
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survey_question").find(".survey_quesnamedes");
            if(currentsetitem.fontbold==='1'){
                title.css("font-weight","bold");
            }else{
                title.css("font-weight","normal");
            }
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survey_question");
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
            title=$(".survey_title");
            if(currentsetitem.fontitalic==='1'){
                title.css("font-style","italic");
            }else{
                title.css("font-style","normal");
            }
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survey_question").find(".survey_quesnamedes");
            if(currentsetitem.fontitalic==='1'){
                title.css("font-style","italic");
            }else{
                title.css("font-style","normal");
            }
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survey_question");
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
            title=$(".survey_title");
            title.css("text-align",direction);
            currentsetitem.fontalign=direction;
            //调查题目设置字体和大小
        }else if(currentsetitem.index==='4'){
            title=$(".survey_quesname");
            title.css("text-align",direction);
            currentsetitem.fontalign=direction;
            //选项设置
        }else if(currentsetitem.index==='5'){
            title=$(".survey_question");
            var labels=title.find(".options li");
            labels.css("text-align",direction);
            labels=title.find(".optionstable  td");
            labels.css("text-align",direction);
            labels=title.find(".optionstable  th");
            labels.css("text-align",direction);
            currentsetitem.fontalign=direction;
        }
    }

    //调查背景图片
    function setBgImage(currentsetitem){
        var bgimg= currentsetitem.bgimg;
        var container;
        if(currentsetitem.index==='0'){
            if(currentsetitem.bgpictopheight)
                $(".survey_title").css("margin-top",currentsetitem.bgpictopheight+"px");
            if(currentsetitem.bgpicbottomheight)
                $(".placeholder").css("height",currentsetitem.bgpicbottomheight+"px");
        }
        if(bgimg){
            if(currentsetitem.index==='0'){
                container=$(document.body);
                //  $(".survey-logo").css("margin-top",currentsetitem.+"px");
                //  var sbody= $(".survey_body");
                //   sbody.css("height",(sbody.height()-120)+'px');
                // $(".survey_title").css("margin-top",currentsetitem.bgpictopheight+"px");
                // $(".placeholder").css("height",currentsetitem.bgpicbottomheight+"px");
                //    $(".survey_editor").css("margin-top","200px");
            }else if(currentsetitem.index==='1'){
                container=$(".survey-logo");

            } else if(currentsetitem.index==='2'){
                container= $(".survey_body");
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




    //提交调查时判断合法性
    function   checkIfCurrect(question){
        //移除所有提示信息,每次选中一个
        $(".survey_content").find(".remindinfo").removeClass(S_REMINDINFO);
        var  ismustinput=question.ismustinput;
        var  questiontype=question.questiontype;
        var  type= question.type;
        if(questiontype==='2' || (ismustinput==='0' && question.limit === '-1' && question.max === '-1'))
            return true;
        var container=question.container;
        var checklength;
        //选择题
        if(questiontype==='0'){
            checklength = container.find("input:checked").length;
            //单选
            if ("0" === type){
				var otherinput=container.find(".otherinput");
                if(checklength===0){
                    container.addClass(S_REMINDINFO);
                    return false;
                }else if(checklength>0){
                	if(!(typeof(otherinput)=="undefined")){
                		if((!(otherinput.css("display")=='none'))&&otherinput.val()===""){
                			container.addClass(S_REMINDINFO);
                        	
                        	return false;
                		}
                	}
                		
                }
				
				
                //下拉
            }else if("2" === type){
                var cvalue=container.find("select").val();
                //如果值为-1，则不合法
                if(cvalue==='-1'){
                    container.addClass(S_REMINDINFO);
                    return false;
                }
                //复选
            }else if("1"===type){
                var limit= question.limit;
                var max= question.max;
                if(limit!=='-1' && max!=='-1' ){
                    if(checklength<limit || checklength>max){
                        container.addClass(S_REMINDINFO);
                        return false;
                    }
                }else if(limit==='-1' && max!=="-1"){
                    if(checklength>max){
                        container.addClass(S_REMINDINFO);
                        return false;
                    }
                }else if(limit!=='-1' && max==="-1"){
                    if(checklength<limit){
                        container.addClass(S_REMINDINFO);
                        return false;
                    }
                } else {
                    if(checklength===0) {
                        container.addClass(S_REMINDINFO);
                        return false;
                    }
                }
            }
        } else if(questiontype==='1'){
            var flag=true;
            for (var i = 0; i < question.rows.length; i++) {
                //如果一个未选中,则直接不合法
                if(container.find("input[name='q_"+question.rows[i].quesionid+"_"+question.rows[i].opid+"']:checked").length===0){
                    flag=false;
                    break;
                }
            }
            if(!flag){
                container.addClass(S_REMINDINFO);
                return false;
            }
            //填空题
        }else if(questiontype==='3'){
            var ismustinput=question.ismustinput;
            //必填
            if(ismustinput==='1'){
                if(container.find("textarea").val()==='')    {
                    container.addClass(S_REMINDINFO);
                    return false;
                }
				
            }
			//字符长度不能大于255
			if(realLength(container.find("textarea").val())>4000)
                {
                	window.top.Dialog.alert("您输入的字符过多，请重新输入!");
                    container.addClass(S_REMINDINFO);
                    return false;
                }
        }
        return true;
    }


    return {
        //添加加载图标
        addLoadingIcon:function(container){
            var width=$(window).width();
            var height=$(window).height();
            var iconleft=width/2-16;
            var icontop=height/2-16;
            var icon=$("<div style='position: fixed;z-index: 10;left: 0px;top: 0px;width: "+width+"px;height:"+height+"px' class='loadingicon'><div style='z-index: 100;position: absolute;left:"+iconleft+"px;top:"+icontop+"px'><img src='/voting/surveydesign/images/loading_wev8.gif'></div></div>")
            container.append(icon);
        },
        removeLoadingIcon:function(container){
            container.find(".loadingicon").remove();
        },
        //提交调查
        submitsurvey:function(){
            var that=this;
            var formdata=$("#surveyform").serializeObject();
            var flag=true;
            var questions;
            var uncorrectqus;
            for(var i=0;i<pagequestions.length;i++){
                questions=pagequestions[i].questions;
                for(var j=0;j<questions.length;j++){
                    flag=checkIfCurrect(questions[j]);
                    if(flag===false)
                    {
                        uncorrectqus=questions[j];
                        break;
                    }
                }
                if(flag===false)
                    break;
            }
            if(!flag){
                var offset=uncorrectqus.container.offset();
                var top=offset.top;
                $("html").scrollTop(top);
                $(document.body).scrollTop(top);
            }
            //return;
            if(flag)
            {
                that.addLoadingIcon($(document.body));
                $.ajax({
                    data:formdata,
                   // data: {votingid : jQuery("input[name='votingid']").val(),useranony : jQuery("input[name='useranony']").val()},
                    type: "POST",
                    url: "/voting/surveydesign/pages/savesurvey.jsp",
                    timeout: 20000,
                    dataType: 'json',
                    success: function(rs){
                        if(rs.success=='1'){
                            that.removeLoadingIcon($(document.body));
                            window.top.Dialog.alert("调查完成!");
                            //window.top.votedialog.close();
                            //参与调查提交
                            if(document.surveyform.freshparent.value == '1'){
                                parent.getParentWindow(window)._table.reLoad();
                            }
                            parentDialog.close();
                        }else if(rs.success=='-1'){
                        	 that.removeLoadingIcon($(document.body));
                        	 window.top.Dialog.alert("您已参与过该调查!");
                        	 parentDialog.close();
                        }else{
                        	 window.top.Dialog.alert('调查提交失败');
                        }

                    },fail:function(){
                    	 window.top.Dialog.alert('调查提交失败');
                    }
                });
            }
        },
        generatorIntroduce:function(question){
            var content=question.name;
            var container=$("<div class='survey_question'></div>").html(content===""?"自定义文字":content);
            $(".survey_content").append(container);
            container.show();
            return  container;
        },
        //生成填空题
        generatorBlankfilling:function(question){
            var ismustinput=question.ismustinput;
            var qname=question.name;
            var container = $(".clone").clone();
            container.removeClass("clone");
            var tips="填空";
            //必须
            if(ismustinput==='1'){
                container.find(".require").show();
                tips=tips+",必填";
            }else{
                container.find(".require").hide();
            }
            //添加提示信息
            container.find(".rules").html("("+tips+")");
            //填充标题
            container.find(".survey_quesnamedes").html("<span class='questionnum'>"+questionnum+"、</span>"+(question.name === "" ? "新建问题" : question.name));
            //插入填空区域
            container.find(".survey_options").append("<input type='hidden' name='q_"+question.quesionid+"' value='-100'><textarea onblur='blurBlankfilling(this)' qid='" + question.quesionid + "' name=qother_"+question.quesionid+"  style='width: 100%;height: 200px;' >" + (question.toBeRemark ? question.toBeRemark : "") + "</textarea>");

            $(".survey_content").append(container);

            container.show();

            //将容器和问题关联
            question.container=container;

            return  container;
        },
        //生成组合题
        generatorComposionQuestion: function (question) {
            //单选类型
            var type = question.type;
            //是否必需
            var ismustinput=question.ismustinput;
            //提示信息
            var tips="";
            //列选项
            var cols = [];
            //行选项
            var rows = [];
            var option;
            var optiontemp;
            //设置选项信息
            for (var optionorder in  question.options) {
                option = question.options[optionorder];
                optiontemp = option;
                if (option.roworcolumn === '0') {
                    rows.push(optiontemp);
                } else {
                    cols.push(optiontemp);
                }

            }
            //保存行列信息
            question.rows=rows;
            question.cols=cols;

            var container = $(".clone").clone();
            container.removeClass("clone");

            //生成提示信息
            if(type==='0'){
                tips="单选";
            }else if(type==='1'){
                tips="多选"
            }
            //必须
            if(ismustinput==='1'){
                container.find(".require").show();
                tips=tips+",必填";
            }else{
                container.find(".require").hide();
            }
            //添加提示信息
            container.find(".rules").html("("+tips+")");

            //填充标题
            container.find(".survey_quesnamedes").html("<span class='questionnum'>"+questionnum+"、</span>"+(question.name === "" ? "新建问题" : question.name));
            //内容区域
            var content;
            //单选框(radio)
            if ("0" === type || "1" === type) {
                var inputtype;
                if ("0" === type) {
                    inputtype = "radio";
                }
                else {
                    inputtype = "checkbox";
                }
                var tr;
                var td;
                var th;
                content = $("<table class='optionstable' ></table>");
                var coltr = $("<tr><th></th></tr>");
                //添加列头
                for (var i = 0; i < cols.length; i++) {
                    th = $("<th>" + (cols[i].oplabel === '' ? '选项' : cols[i].oplabel) + "</th>");
                    coltr.append(th);
                }
                content.append(coltr);
                //添加行头
                var rowtr;
                for (var i = 0; i < rows.length; i++) {
                    rowtr = $("<tr align='center'><td align='left'>" + (rows[i].oplabel === '' ? '新建问题' : rows[i].oplabel) + "</td></tr>");
                    for (var j = 0; j < cols.length; j++) {
                    	var flag = "";
                    	if(question.toBeChecked){
                    		flag = question.toBeChecked[rows[i].opid + "_" + cols[j].opid] ? "checked" : "";
                    	}
                        td = $("<td><input " + flag + " type='" + inputtype + "' qid='" + rows[i].quesionid + "' oid='" + rows[i].opid + "_" + cols[j].opid + "' value='"+cols[j].opid+"'  name='q_"+rows[i].quesionid+"_"+rows[i].opid+"' ></td>");
                        rowtr.append(td);
                    }
                    content.append(rowtr);
                }

            }
            container.find(".survey_options").append(content);
            $(".survey_content").append(container);
            container.show();
            //将容器和问题关联
            question.container=container;

            //添加校验信息
            if(ismustinput==='1' || (question.limit !== '-1') || (question.max !== '-1')){

                container.find("input").click(function(){
                    var flag=true;
                    for (var i = 0; i < question.rows.length; i++) {
                        //如果一个未选中,则直接不合法
                        if(container.find("input[name='q_"+question.rows[i].quesionid+"_"+question.rows[i].opid+"']:checked").length===0){
                            flag=false;
                            break;
                        }
                    }
                    if(flag){
                        container.removeClass(S_REMINDINFO);
                    }
                    
                    saveAsTemp(jQuery(this),"1");
                });

            }else{
            	 container.find("input").click(function(){
            	 	saveAsTemp(jQuery(this),"1");
            	 });
            }
            


        },
        //生成选择题
        generatorSelectQuestion: function (question) {
            var column = question.perrowcols;
            //单选类型
            var type = question.type;
            //是否必需
            var ismustinput=question.ismustinput;
            //最少多少项
            var limit= question.limit;
            //做多多少项
            var  max=  question.max;

            //提示信息
            var tips="";

            var options = [];
			var onumArray = new Array();
			for(var optionorder in  question.options){
					onumArray.push(optionorder);
			}
			onumArray.sort(sortNumber);
			for(var i = 0;i < onumArray.length;i++){
			  options.push(question.options[onumArray[i]]);
			}
			
			
            

            var optiontemp=[];
            for(var j=0;j<options.length;j++){
                optiontemp.push(options[j]);
            }
            //其它输入
            if(question.isother==='1'){
                var optemp={};
                optemp.quesionid=options[0].quesionid;
                //其它
                optemp.opid='-100';
                optemp.oplabel='其它';
                optiontemp.push(optemp);
            }

            options=optiontemp;

            var container = $(".clone").clone();
            container.removeClass("clone");
            container.addClass("simpleselect");
            //生成提示信息
            if(type==='0' || type==='2'){
                tips="单选";
            }else if(type==='1'){
                tips="多选";
            }
            //必须
            if(ismustinput==='1'){
                container.find(".require").show();
                tips=tips+",必填";
            }else{
                container.find(".require").hide();
            }
            //至少项数
            if(""!==limit  && "-1"!==limit && limit){
                tips=tips+",至少"+limit+"项";
            }
            //至多项数
            if(""!==max && "-1"!==max && max){
                tips=tips+",至多"+max+"项";
            }

            //添加提示信息
            container.find(".rules").html("("+tips+")");

            //填充标题
            container.find(".survey_quesnamedes").html("<span class='questionnum'>"+questionnum+"、</span>"+(question.name === "" ? "新建问题" : question.name));
            //内容区域
            var content;
            var votingId = jQuery("input[name='votingid']").val();
            question.imageWidth = question.imageWidth ? question.imageWidth : "100";
			question.imageHeight = question.imageHeight ? question.imageHeight : "80";
            //单选框(radio)
            if ("0" === type || "1" === type) {
                var inputtype;
                if ("0" === type) {
                    inputtype = "radio";
                }
                else {
                    inputtype = "checkbox";
                }

                var li;
                content = $("<ul class='options'></ul>");

                //每列显示一个(ul显示)
                if (~~column === 1) {
                    for (var i = 0; i < options.length; i++) {
                        
                        var optionIndex = 4;
				        var imageIndex = 4;
				        var attrIndex = 4;
				        var remarkIndex = 4;  
				        
				        optionIndex = options[i].oinner;    
                        
                        var flag = "";
                    	if(question.toBeChecked){
                    		flag = question.toBeChecked[options[i].opid] ? "checked" : "";
                    	}
                        
                        var _li = "<li class='odd'><div class='voting_question_show'><input " + flag + " qid='" + options[i].quesionid + "' oid='" + options[i].opid + "' type='" + inputtype + "' name='q_"+options[i].quesionid+"' value='"+options[i].opid+"'  ><label>" + (options[i].oplabel === "" ? "选项" : options[i].oplabel) + "</label></div>";
                        if(options[i].images){
		            		var images = options[i].images;
		            		_li += "<div class='voting_image_show'>";
		            		for(var j = 0;j < images.length;j++){
		            			_li += "<div class='image_div_show'>" + 
		            				"<img width=" + question.imageWidth + " height='" + question.imageHeight + "' src='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + images[j].fid + "'/>" +
		            				"</div>";
		            		}
		            		_li +=	"</div>";
		            		imageIndex = images.length > 0 ? images[0].iinner : imageIndex;
		            	}
		            	if(options[i].attrs){
		            		var attrs = options[i].attrs;
		            		_li += "<div class='voting_attr_show'>";
		            		for(var j = 0;j < attrs.length;j++){
		            			_li += "<div class='attr_pdiv_show'>" +
		            				"<div class='attr_div_show'>" + 
		            				"<a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+attrs[j].fid+"\""+
					                " onclick=\"try{openSdoc('"+attrs[j].fid+"',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\"> "+attrs[j].title+
					                " </a>" +
					                "<a class='download' href='javascript:void(0)' style='margin-left:15px' onclick=\"downSdoc('" + attrs[j].fid + "',this)\">下载(" + Math.floor(attrs[j].size/1024) + "KB)</a>" +
		            				"<div class=\"clearboth\"></div>" +
		            				"</div></div>";
		            				
		            		}
		            		_li +=	"</div>";
		            		
		            		attrIndex = attrs.length > 0 ? attrs[0].iinner : attrIndex;
		            	}
		            	if(options[i].remark){
		            		_li += "<div class='voting_remark_show'><pre>" + options[i].remark + "</pre></div>";
            				remarkIndex = options[i].remarkorder;
		            	}
		            	_li += "</li>";
                        li = $(_li);
                        
                        for(var j = 0;j <= 4;j++){
		                	if(optionIndex == j){
		                		li.append(li.find(".voting_question_show"));
		                	}
					        if(imageIndex == j){
					        	li.append(li.find(".voting_image_show"));
		                	}
					        if(attrIndex == j){
					        	li.append(li.find(".voting_attr_show"));
		                	}
					        if(remarkIndex == j){
					        	li.append(li.find(".voting_remark_show"));
		                	} 
		                }
                        
                        content.append(li);
                    }
                    //table展示
                } else {
                    var widthper = (1 / ~~column) * 100;
                    content = $("<table class='optionstable' ></table>");
                    for (var i = 0; i < options.length; i++) {
                        content.append("<col width='" + widthper + "%' />");
                    }
                    var tr;
                    var td;
                    for (var i = 0; i < options.length; i++) {
                        if (i % ~~column === 0) {
                            tr = $("<tr></tr>");
                            content.append(tr);
                        }
                        
                        var optionIndex = 4;
				        var imageIndex = 4;
				        var attrIndex = 4;
				        var remarkIndex = 4;    
				        
				        optionIndex = options[i].oinner;        	
		                
		                var flag = "";
                    	if(question.toBeChecked){
                    		flag = question.toBeChecked[options[i].opid] ? "checked" : "";
                    	}
		                
		                var _tdcontent = "<td style='vertical-align:top'>" 
		                _tdcontent += "<div class='voting_question_show'><input " + flag + " qid='" + options[i].quesionid + "' oid='" + options[i].opid + "' type='" + inputtype + "' name='q_"+options[i].quesionid+"' value='"+options[i].opid+"' ><label>" + (options[i].oplabel === "" ? "选项" : options[i].oplabel) + "</label></div>";
		                if(options[i].images){
		            		var images = options[i].images;
		            		_tdcontent += "<div class='voting_image_show'>";
		            		for(var j = 0;j < images.length;j++){
		            			_tdcontent += "<div class='image_div_show'>" + 
		            				"<img width=" + question.imageWidth + " height='" + question.imageHeight + "' src='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + images[j].fid + "'/>" +
		            				"</div>";
		            		}
		            		_tdcontent +=	"</div>";
		            		
		            		imageIndex = images.length > 0 ? images[0].iinner : imageIndex;
		            	}
		            	if(options[i].attrs){
		            		var attrs = options[i].attrs;
		            		_tdcontent += "<div class='voting_attr_show'>";
		            		for(var j = 0;j < attrs.length;j++){
		            			_tdcontent += "<div class='attr_pdiv_show'>" +
		            				"<div class='attr_div_show'>" + 
		            				"<a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+attrs[j].fid+"\""+
					                " onclick=\"try{openSdoc('"+attrs[j].fid+"',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\"> "+attrs[j].title+
					                " </a>" +
					                "<a class='download' href='javascript:void(0)' style='margin-left:15px' onclick=\"downSdoc('" + attrs[j].fid + "',this)\">下载(" + Math.floor(attrs[j].size/1024) + "KB)</a>" +
		            				"<div class=\"clearboth\"></div>" +
		            				"</div></div>";
		            				
		            		}
		            		_tdcontent +=	"</div>";
		            		
		            		attrIndex = attrs.length > 0 ? attrs[0].iinner : attrIndex;
		            	}
		            	if(options[i].remark){
		            		_tdcontent += "<div class='voting_remark_show'><pre>" + options[i].remark + "</pre></div>";
		            		
		            		remarkIndex = options[i].remarkorder;
		            	}	
		                _tdcontent += "</td>";
		                td = $(_tdcontent);
		                
		                for(var j = 0;j <= 4;j++){
		                	if(optionIndex == j){
		                		td.append(td.find(".voting_question_show"));
		                	}
					        if(imageIndex == j){
					        	td.append(td.find(".voting_image_show"));
		                	}
					        if(attrIndex == j){
					        	td.append(td.find(".voting_attr_show"));
		                	}
					        if(remarkIndex == j){
					        	td.append(td.find(".voting_remark_show"));
		                	} 
		                }
                        tr.append(td);
                    }
                }
            }
            //下拉单选
            else if (type === '2') {
                content = $("<select class='qs_select' qid='" + options[0].quesionid + "' name='q_"+options[0].quesionid+"' ><option value='-1'>--请选择--</option></select>");
                var newop;
                for (var i = 0; i < options.length; i++) {
                	var flag = "";
                   	if(question.toBeChecked){
                   		flag = question.toBeChecked[options[i].opid] ? "selected" : "";
                   	}
                    newop = $("<option " + flag + " value='"+options[i].opid+"' >" + options[i].oplabel + "</option>");
                    content.append(newop);
                }
            }
            container.find(".survey_options").append(content);
            $(".survey_content").append(container);
            container.show();
            //将容器和问题关联
            question.container=container;

            
            //注册文字点击事件
           /* container.find("td").click(function(e){
                   var target=$(e.target);
                   if(target.attr("type")==='radio' ||  target.attr("type")==='checkbox' || target.attr("type")==='text')
                   return;
                   var previnput=$(this).find("input[type='"+inputtype+"']");
                   if(previnput.length===1){
                       if(previnput.is(":checked")){
                           previnput.prop("checked",false);
                           if(inputtype==='radio' || previnput.val()==='-100')
						   container.find("input[type='text']").hide();
						 }
                       else{
					       previnput.prop("checked",true);
						   if(previnput.val()==='-100'){
							   var name=previnput.attr("name"); 
							   name=name.replace(/q/g,'qother');
							   var textcon=container.find("input[name='"+name+"']");
							   if(textcon.length===1)
									textcon.show();
							   else{
							     var opinput=$("<input class='otherinput'  type='text' name='"+name+"' >");
								 previnput.parent().append(opinput);
                                 opinput.click(function(e){
								   e.stopPropagation();
								 });
							   }
									
					        }else{
								 if(inputtype==='radio')
							    container.find("input[type='text']").hide();
							}
					   }
                         
                   }
                 e.preventDefault();
                 e.stopPropagation();
            }) ;*/
            container.find(".voting_question_show").click(function(e){
                var target=$(e.target);
                if(target.attr("type")==='radio' ||  target.attr("type")==='checkbox' ){
                	saveAsTemp(target,"0");
                    return;
                }else if(target.attr("type")==='text'){
                	return;
                }
                var previnput=$(this).find("input[type='"+inputtype+"']");
                if(previnput.length===1){
                    if(previnput.is(":checked")){
                        previnput.prop("checked",false);
						if(inputtype==='radio' || previnput.val()==='-100')
						container.find("input[type='text']").hide();
					}					    
					else{
					   previnput.prop("checked",true);
					   if(previnput.val()==='-100'){
							   var name=previnput.attr("name"); 
							   name=name.replace(/q/g,'qother');
							   var textcon=container.find("input[name='"+name+"']");
							   if(textcon.length===1)
									textcon.show();
							   else{
							     var opinput=$("<input class='otherinput' onblur='blurOtherinput(this)'  type='text' name='"+name+"' >");
								 previnput.parent().append(opinput);
                                 opinput.click(function(e){
									   e.stopPropagation();
								 });
							   }	
					   }else{
						     if(inputtype==='radio')
							 container.find("input[type='text']").hide();
					   }
					}
                }
                saveAsTemp(previnput,"0");
                e.preventDefault();
                e.stopPropagation();
            }) ;

            if(question.isother==='1'){
				
                if(type==='0' || type==='1')    {
                    //单选有填空
                    container.find("input[type='"+inputtype+"']").click(function(e){
                        var target=$(e.target);
                        if(target.val()!=='-1' &&  inputtype!=='checkbox'){
                            container.find("input[type='text']").hide();
                        }
                    });
                    container.find("input[type='"+inputtype+"'][value='-100']").click(function(){
                        var current=$(this);
                        var name=current.attr("name");
                        name=name.replace(/q/g,'qother');
                        var textcon=container.find("input[name='"+name+"']");
                        if(current.is(":checked")){
                            if(textcon.length===1)
                                textcon.show();
                            else
                                current.parent().append("<input class='otherinput' onblur='blurOtherinput(this)'  type='text' name='"+name+"' >");
                        }else{
                            textcon.hide();
                        }
                    });
                    
                     if(container.find("input[type='"+inputtype+"'][value='-100']:checked").length > 0){
                     	container.find("input[type='"+inputtype+"'][value='-100']").parent().append("<input class='otherinput' onblur='blurOtherinput(this)'  type='text' name='"+name+"' value=\"" + question.toBeRemark.replace(/"/g,"&quot;") + "\">")
                     }
                    
                    //下拉其它
                } else if(type==='2'){
                    container.find(".qs_select").change(function(){
                        var current=$(this);
                        var name=current.attr("name");
                        name=name.replace(/q/g,'qother');
                        var textcon=container.find("input[name='"+name+"']");
                        //其它
                        if(current.val()==='-100'){
                            if(textcon.length===1){
                                textcon.show();
                            }else{
                                current.parent().append("<input class='otherinput' onblur='blurOtherinput(this)'  type='text' name='"+name+"' >");
                            }
                        }else{
                            textcon.hide();
                        }
                        

                    });
					
					if(container.find(".qs_select").val() == "-100"){
						var name = container.find(".qs_select").attr("name").replace(/q/g,'qother')
                     	container.find(".qs_select").parent().append("<input class='otherinput' onblur='blurOtherinput(this)'  type='text' name='"+name+"' value='" + question.toBeRemark.replace(/'/g,"\'") + "'>")
                     }
                }
                
            }



            //添加校验信息
            if(ismustinput==='1' || (question.limit !== '-1') || (question.max !== '-1')){
                //单选
                if ("0" === type ){
                    container.find("input").click(function(){
                        if(container.find("input:checked").length===1){
                            //不合法提示信息
                            container.removeClass("remindinfo");
                        }
                    });
                    //多选
                }else if("1" === type){
                    container.find("input").click(function(){
                        var checkedlength=container.find("input:checked").length;
                        if( "-1"!==limit  && "-1"!=max  &&  limit<=max)
                        {
                            if(checkedlength>=limit  &&  checkedlength<=max){
                                //不合法提示信息
                                container.removeClass("remindinfo");
                            }
                        }else if("-1"!==limit  && "-1"===max){
                            if(checkedlength>=limit){
                                //不合法提示信息
                                container.removeClass("remindinfo");
                            }
                        }else if("-1"===limit  && "-1"!==max){
                            if(checkedlength<=max){
                                //不合法提示信息
                                container.removeClass("remindinfo");
                            }
                        }else {
                            if(checkedlength>=1){
                                //不合法提示信息
                                container.removeClass("remindinfo");
                            }
                        }
                    });
                    //下拉框
                }else if(type==='2'){
                    container.find("select").change(function(){
                        var value=$(this).val();
                        if(value!=='-1'){
                            container.removeClass("remindinfo");
                        }
                         saveAsTemp(jQuery(this),"0");
                    });
                }
            }else{
            	if(type==='2'){
            		container.find("select").change(function(){
                         saveAsTemp(jQuery(this),"0");
                    });
            	}
            }

        },
        //生成问题
        generatorQuestion: function (question) {
            var that = this;
            //获取问题类型,根据不同的问题生成对应的选项
            var questiontype = question.questiontype;
            //选择题
            if (questiontype === "0") {
                questionnum++;
                that.generatorSelectQuestion(question);

            } else if (questiontype === '1') {
                //多选题
                questionnum++;
                that.generatorComposionQuestion(question);

            } else if (questiontype === '2') {
                //说明
                that.generatorIntroduce(question);

            } else if (questiontype === '3') {
                //填空
                questionnum++;
                that.generatorBlankfilling(question);

            }



        },
        //初始化调查
        initSurvey: function (pageitems,viewset,surveytitle) {

            var questionheight;

            if($("input[name='ispreview']").length===1)
                questionheight=$(window).height()-105;
            else
                questionheight=$(window).height()-105;

            //  $(".survey_body").css("height",questionheight+"px");
            var that = this;
            var page;
            var question;
            questionnum=0;
            $(".survey_title").html(surveytitle===""?"新建调查":surveytitle);
            var pageinfo;
            var questioninfo;
           for (var pagenum in pageitems) {
                page = pageitems[pagenum];
                pageinfo={};
                pageinfo.pagenum=pagenum;
                pageinfo.questions=[];
                /**for (var quesnum in page) {
                    question = page[quesnum];
                    pageinfo.questions.push(question);
					alert(quesnum);
                    that.generatorQuestion(question);
                    pagequestions.push(pageinfo);
                }**/
				var numArray = new Array();
				for(var quesnum in page){
					numArray.push(quesnum);
				}
				numArray.sort(sortNumber);
				for(var i = 0;i < numArray.length;i++){
					question = page[numArray[i]];
                    pageinfo.questions.push(question);
                    that.generatorQuestion(question);
                    pagequestions.push(pageinfo);
				}

            }
            if(!viewset)
                return;
            for(var item in viewset){
                //  setBgImage(viewset[item]);
                showBgColor(viewset[item]);
                setFontInfo(viewset[item]);
                setFontColor(viewset[item]);
                setFontBold(viewset[item]);
                setFontItalic(viewset[item]);
                setAlign(viewset[item],viewset[item].fontalign);
            }
            //恢复用户输入的调查数据
        },fillUserInput:function(userinputs){
            //填写选择题
            function fillQtype0(vote){
                var qdtype=vote.qdtype;
                var isother=vote.qother;
                var inputname;
                var inputvalue;
                //其它输入
                if(isother==='1' && vote.qvalue == '-100'){
                    inputname="q_"+vote.qid;
                    inputvalue="qother_"+vote.qid
                    if(qdtype == 2){// 下拉
                    	$("select[name='" + inputname + "'] option[value='" + -100 + "']").prop("selected",true).trigger("change");
                    }else{  //单选、多选
                    //选中其它
	                    $("input[name='"+inputname+"'][value='-100']").prop("checked",true);
	                    $("input[name='"+inputname+"'][value='-100']").trigger("click");
	                    if(qdtype == 1){
	                    	$("input[name='"+inputname+"'][value='-100']").prop("checked",true);
	                    }
                    }
                    //赋值
                    $("input[name='"+inputvalue+"']").val(vote.qremark);
                    return;
                }
                //input框名称
                inputname="q_"+vote.qid;
                inputvalue=vote.qvalue;
                //单选或复选(直接设置checked)
                if(qdtype==='0' || qdtype==='1'){
                    //设置选中
                    $("input[name='"+inputname+"'][value='"+inputvalue+"']").prop("checked",true);
                    //下拉
                }else if(qdtype==='2'){
                    $("select[name='"+inputname+"']").val(inputvalue);
                }
            }
            //组合选择
            function fillQtype1(vote){
                var qid=vote.qid;
                var qvalues=vote.qvalue.split("_");
                var inputname="q_"+qid+"_"+qvalues[0];
                var inputvalue=qvalues[1];
                $("input[name='"+inputname+"'][value='"+inputvalue+"']").prop("checked",true);
            }
            //填空选择
            function fillQtype3(vote){
                var inputname="qother_"+vote.qid;
                $("textarea[name='"+inputname+"']").val(vote.qremark);
            }
            var qtype;
            for(var i=0;i<userinputs.length;i++){
                //问题类型
                qtype=userinputs[i].qtype;
                switch (qtype){
                    case '0': fillQtype0(userinputs[i]);break;
                    case '1': fillQtype1(userinputs[i]);break;
                    case '3': fillQtype3(userinputs[i]);break;
                    default :break;
                }
            }
           // var bheight=$(document).height();
           // var cover=$("<div style='position: absolute;width: 100%;height: "+bheight+"px;z-index: 10000;left: 0px;top: 0px'></div>") ;
          //  $(document.body).append(cover);
	  
	  	$("input[type='radio'],input[type='checkbox'],textarea").attr("disabled",true);
        }
    }

})();
function sortNumber(a,b){
	return a - b;
}
//打开应用连接
function openAppLink(obj,linkid){

    var linkType=jQuery(obj).attr("linkType");
    if(linkType=="doc")
        window.open("/docs/docs/DocDsp.jsp?id="+linkid+"&votingId="+votingId);
    else if(linkType=="task")
        window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid);
    else if(linkType=="crm")
        window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid);
    else if(linkType=="workflow")
        window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid);
    else if(linkType=="project")
        window.open("/proj/data/ViewProject.jsp?ProjID="+linkid);
    else if(linkType=="workplan")
        window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid);
    return false;
}

//打开附件
function opendoc1(showid,obj){
    //  var discussid=jQuery(obj).parents(".reportItem").attr("id");
    openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&votingId="+votingId);
}
//下载附件
function downloads(files,obj){
    $.ajax({
        data: {"docId":files},
        type: "POST",
        url: "searchImageFileid.jsp",
        timeout: 20000,
        //dataType: 'json',
        success: function(fileid){
        		fileid=jQuery.trim(fileid);
            jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1&requestid=0&votingId="+votingId);
        },fail:function(){
					alert('附件获取失败');
        }
    });

}

//下载附件(imagefileid)
function downSdoc(imagefileid,obj){
	jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+imagefileid+"&download=1&requestid=0&votingId="+votingId + "&download=1");
}

//打开附件(imagefileid)
function openSdoc(imagefileid,obj){
	openFullWindowHaveBar("/voting/surveydesign/pages/ImageFileView.jsp?fileid="+imagefileid+"&votingId="+votingId);
}

function realLength(str) {
    var j=0;
    for (var i=0;i<=str.length-1;i++) {
        j=j+1;
        if ((str.charCodeAt(i))>127) {
            j=j+2;
        }
    }
    return j;
}


function blurOtherinput(thi){
	saveAsTemp(jQuery(thi),"-1");
}

function blurBlankfilling(thi){
	saveAsTemp(jQuery(thi),"2");
}

function saveAsTemp(target,questiontype){
	if(!this.doOperatorSave || this.doOperatorSave != "1"){
		return;
	}
	var data = {};
    var votingId = jQuery("input[name='votingid']").val();
    data.votingId = votingId;
   	var _qid = target.attr("qid");
    if(questiontype == "0"){ //选择题
    	if(!_qid){
			var _name = target.attr("name");
	   		_qid = _name ? _name.replace("q_","") : "";
	   	}
	   	data.qid = _qid;
	   	if(target[0].tagName == "INPUT"){ //单选、多选
	   		data.oid = target.val();
		   	data.type = target.attr("type");
		   	data.operate = target[0].checked ? "1" : "0";
	   	}else{ //下拉
	   		data.type = "select";
	   		data.operate = "1";
	   		if(target.val() == "-1"){
	   			data.operate = "0";
	   		}
   			data.oid = target.val();
	   	}
	   	if(target.siblings(".otherinput").length > 0 && data.operate == "1"){
	   		data.remark = target.siblings(".otherinput").val();
	   	}
   	}else if(questiontype == "-1"){  //选择题 其他 输入框
   		if(!_qid){
       		_qid = target.attr("name").replace("qother_","");
       	}
       	data.qid = _qid;
       	data.remark = target.val();
       	data.operate = "-1";
   	}else if(questiontype == "1"){ // 组合题
   		if(!_qid){
   			var _name = target.attr("name");
   			_qid = _name.split("_")[1];
   		}
   		var _oid = target.attr("oid");
   		if(!_oid){
   			var _name = target.attr("name");
   			_oid = _name.split("_")[2] + "_" + target.val();
   		}
   		data.qid = _qid;
   		data.oid = _oid;
   		data.type = target.attr("type");
   		data.operate = target[0].checked ? "1" : "0";
   	}else if(questiontype == "2"){ //填空题
   		if(!_qid){
   			var _name = target.attr("name");
   			_qid = _name.split("_")[1];
   		}
   		data.qid = _qid;
   		data.remark = target.val();
   	}
   	data.questiontype = questiontype;
   	survey.addLoadingIcon($(document.body));
	jQuery.ajax({
		url : "/voting/surveydesign/pages/surveyTempSave.jsp",
		data : data,
		type : "post",
		dataType : "json",
		success : function(data){
			if(data && data.flag == "1"){
				survey.removeLoadingIcon($(document.body));
			}else if(data && data.flag == "0"){
				window.top.Dialog.alert('系统异常!');
			}else if(data && data.flag == "-1"){
				window.top.Dialog.alert('没有权限!');
			}else if(data && data.flag == "-2"){
				window.top.Dialog.alert('请求异常!');
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown){
			window.top.Dialog.alert('系统异常，请刷新重试!');
		}
	})
}