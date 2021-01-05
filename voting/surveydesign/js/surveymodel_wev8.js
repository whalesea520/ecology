/**
 * Created with JetBrains WebStorm.
 * User: lsj(三杰lee)
 * Date: 14-8-14
 * Time: 上午9:08
 * To change this template use File | Settings | File Templates.
 */
//自定义数据结构  MAP
function Map() {
    this.items = {};
}
//添加条目
Map.prototype.put = function (key, value) {
    this.items[key] = value;
}
//移除条目
Map.prototype.remove = function (key) {
    delete  this.items[key];
}
//获取条目
Map.prototype.get = function (key) {
    if(key in this.items)
    return this.items[key];
    return null;
}
//获取所有条目
Map.prototype.getContainer = function () {
    return this.items;
}


//页面对象
function Page(uuid,pagecount) {
    //页面唯一标识
    this.uuid = uuid;
    this.container = new Map();
    this.listcontainer=[];
    this.title="";
    this.pageCount=pagecount;
    this.pagemenu="";
    this.initPageMenu();
}
//设置页码
Page.prototype.setPageCount=function(pageCount){
     this.pageCount=pageCount;
}
//获取页码
Page.prototype.getPageCount=function(){
     return this.pageCount;
}
//获取页面的所有问题
Page.prototype.getPageQuestions=function(){
    return this.listcontainer;
}
//更新页码
Page.prototype.updatePageCount=function(){
      this.pageCount++;
      this.pagemenu.find(".pagenode  .label").html("第"+(this.pageCount)+"页");
}
//页面上移
Page.prototype.up=function(){
    var prepage=this.pagemenu.prev();
    //如果存在上一页则直接移动
    if(prepage.length>0){
        //this.pagemenu.insertBefore(prepage);
        doUpDown(this,prepage,"page","up");
    }
}
//页面下移
Page.prototype.down=function(){
    var afterpage=this.pagemenu.next();
    //如果存在上一页则直接移动
    if(afterpage.length>0){
        //this.pagemenu.insertAfter(afterpage);
        doUpDown(this,afterpage,"page","down")
    }
}
//刷新分页信息
Page.prototype.refreshPageCount=function(){
    this.pagemenu.find(".pagenode .label").html("第"+this.pageCount+"页");
}

//初始化页面菜单
Page.prototype.initPageMenu=function(){
      //分页信息容器
      if($(".surveytree .page").length===0)  {
         this.pagemenu=$("<li class='page' page-id='"+this.uuid+"'><div class='node pagenode'> <span class='i i_page_open'></span><span class='label'>第"+this.pageCount+"页</span></div><ul class='parts ui-sortable'></ul></li>");
         $("#surveytree").append(this.pagemenu);
      }else{
          this.pagemenu=$("<li class='page' page-id='"+this.uuid+"'><div class='node pagenode'> <span class='i i_page_open'></span><span class='label'>第"+this.pageCount+"页</span></div><ul class='parts ui-sortable'></ul></li>");
          this.pagemenu.insertAfter(surveydsigner.getCurrentPage().pagemenu);
      }

      var pagebefore;
      var pageafter;
      //拖动排序
      $(".parts").sortable({
            connectWith: ".parts",
            start: function( event, ui ) {
                var pid=ui.item.parent().parent().attr("page-id");
                pagebefore=surveydsigner.getPageByUuid(pid);
            } ,
            stop: function( event, ui ) {
                var pid=ui.item.parent().parent().attr("page-id");
                pageafter=surveydsigner.getPageByUuid(pid);
                var quesid=ui.item.attr("id");
                var questionnow;
                var questiontoadd;
                if(pagebefore===pageafter)
                    questionnow=pageafter.getQuestionByKey(quesid);
                else
                    questionnow=pagebefore.getQuestionByKey(quesid);

                //选中该几点要插入的前节点或后节点
                if(ui.item.prev().length>0){
                    var pre=ui.item.prev().attr("id");
                    pageafter.selectQuestionNow(pageafter.getQuestionByKey(pre));
                }else  if(ui.item.next().length>0){
                    var next=ui.item.next().attr("id");
                    pageafter.selectQuestionNow(pageafter.getQuestionByKey(next));
                }

                surveydsigner.setCurrentPage(pageafter);
                surveydsigner.showCurentPage();
                //同个页面 ,做问题移动操作
                if(pagebefore!==pageafter){
                 //pagebefore删除该问题,pageafter添加该问题
                    questiontoadd=questionnow.getQuestionCopy();
                    pagebefore.removeQuestion(questionnow);
                    pageafter.addQuestion(questiontoadd);
                    questiontoadd.geneartorQuestion();
                    questiontoadd.restoreSettingPanel();
                    questiontoadd.refreshQuestionMenu();
                } else{
                    questiontoadd=questionnow;
                }
                
                var fromPage = pagebefore.getPageCount();
                var toPage = pageafter.getPageCount();
                var fromOrder = questiontoadd.setting.showorder;
                var toOrder = "1";
                
               	 var questions = pagebefore.getPageQuestions();
		   		 for(var i = 0;i < questions.length;i++){
			    	if(questions[i].setting && questions[i].setting.showorder){
			    		questions[i].setting.showorder = parseInt(questions[i].questionmenu.index()) + 1;
			    	}
			     }
                if(fromPage != toPage){
                	 questions = pageafter.getPageQuestions();
			   		 for(var i = 0;i < questions.length;i++){
				    	if(questions[i].setting && questions[i].setting.showorder){
				    		questions[i].setting.showorder = parseInt(questions[i].questionmenu.index()) + 1;
				    	}
				     }
                }
                
			    toOrder = questiontoadd.setting.showorder;
                
                
                questiontoadd.setting.pagenum = toPage; 
                
                
                if(ui.item.prev().length>0){
                    var pre=ui.item.prev().attr("id");
                    //questiontoadd.down(pageafter.getQuestionByKey(pre));
                    
                    var toQuestion = pageafter.getQuestionByKey(pre);
				    //移动问题
				    questiontoadd.questionview.insertAfter(toQuestion.questionview.next());
				    questiontoadd.questionset.insertAfter(questiontoadd.questionview);
				    //移动菜单
				    questiontoadd.questionmenu.insertAfter(toQuestion.questionmenu);
				
				    if(questiontoadd.questiontype==='2'){
				        //初始化html编辑器
				         questiontoadd.initHtmlEditor();
				    }
				
				    //滚动条滚动到响应的问题
				    surveydsigner.getCurrentPage().toQuestion(questiontoadd);
				    
					/*questions = pageafter.getPageQuestions();
				    j = 1;
				    for(var i = 0;i < questions.length;i++){
				    	if(questions[i].setting && questions[i].setting.showorder){
				    		questions[i].setting.showorder = j;
				    		j++;
				    	}
				    }
				    
				    toOrder = questiontoadd.setting.showorder;
                    */
                }else if(ui.item.next().length>0){
                    var next=ui.item.next().attr("id");
                    //questiontoadd.up(pageafter.getQuestionByKey(next));
				    //移动问题
				    var toquestion = pageafter.getQuestionByKey(next);
				    questiontoadd.questionview.insertBefore(toquestion.questionview);
				    questiontoadd.questionset.insertBefore(questiontoadd.questionview);
				    //移动菜单
				    questiontoadd.questionmenu.insertBefore(toquestion.questionmenu);
				    if(questiontoadd.questiontype==='2'){
				        //初始化html编辑器
				        questiontoadd.initHtmlEditor();
				    }
				    //滚动条滚动到响应的问题
				    surveydsigner.getCurrentPage().toQuestion(questiontoadd);
				    
				    /*questions = pageafter.getPageQuestions();
				    j = 1;
				    for(var i = 0;i < questions.length;i++){
				    	if(questions[i].setting && questions[i].setting.showorder){
				    		questions[i].setting.showorder = j;
				    		j++;
				    	}
				    }
				    
				    toOrder = questiontoadd.setting.showorder;*/
                }
                pageafter.selectQuestionNow(questiontoadd);
                
                doDragQuestion(questiontoadd.setting.qid,fromOrder,toOrder,fromPage,toPage);
            }
      });
 //    this.pagemenu.find(".ui-sortable").sortable();

}
//获取分页容器
Page.prototype.getPageMenu=function()
{
      return this.pagemenu;
}

//获取标识
Page.prototype.getUuid = function () {
    return this.uuid;
}
//设置调查标题
Page.prototype.addTitle=function(title){
    this.title=title;
    title.showQuestion();
    title.hideQuestionSetting();
    //添加问题到容器
    this.listcontainer.push(title);
}

//添加问题
Page.prototype.addQuestion = function (question) {

    //获取当前页
    var currentpage=surveydsigner.getCurrentPage();
    var pagemenu=currentpage.pagemenu;

    //有节点的情况(将新增的问题插入至选中节点之后) 后一个条件主要用于判断拖拽情况
    if(pagemenu.find(".part").length>0 && pagemenu.find(".current").length>0 && this.listcontainer.length===(pagemenu.find(".part").length+1)){
        var currentquestionid=pagemenu.find(".current").attr("id");
        var currentquestion=currentpage.getQuestionByKey(currentquestionid);
        question.down(currentquestion,"load");
        var questions = currentpage.getPageQuestions();
        for(var i = 0; i < questions.length;i++){
        	if(questions[i].setting && questions[i].setting.showorder > currentquestion.setting.showorder){
        		questions[i].setting.showorder = parseInt(questions[i].setting.showorder) + 1;
        	}
        }
        if(question.setting && !question.setting.showorder){
        	question.setting.showorder = parseInt(currentquestion.setting.showorder) + 1;
        }
    } else{
        //直接附加问题
        var surveypage=$(".survey_page");
        surveypage.append(question.questionview);
        surveypage.append(question.questionset);
        if(question.setting && !question.setting.showorder){
        	question.setting.showorder = surveydsigner.getCurrentPage().getPageQuestions().length;
        }
    }

    //设置必填选中
    question.questionset.find("input[name='isrequest']").trigger("click");
    
    //再次点击单选、组合选项中的 类型
    if(question.setting && question.setting.type){
    	question.questionset.find("input[name='type'][value='" + question.setting.type + "']").trigger("click");
	}
	
     //隐藏其它问题的设置选项
     this.hideAllOtherSetting();
      //初始化问题设置
      question.initQuestion();
     //添加问题到容器
     this.listcontainer.push(question);
     //向map里面添加问题
     this.container.put(question.uuid,question);
     //初始化菜单(当当前页面只有标题和一道问题时，则需新建菜单)
     if(this.listcontainer.length===2){
         this.pagemenu.find(".current").removeClass("current");
         this.pagemenu.find(".parts").append(question.getQuestionMenu().addClass("current"));
     }
    //如果是说明,则需添加html编辑器
    if(question.questiontype==='2'){
        question.initHtmlEditor();
    }else if(question.questiontype == "0"){
    	question.addUpload();
    }
    
    if(!question.setting || !question.setting.pagenum){
    	question.setting.pagenum = surveydsigner.getCurrentPage().getPageCount();
    }
    
    if(question.addnew == "1"){
    	question.setting.questiontype = question.questiontype;
    	doSaveQuestion(question);
    }

}


//隐藏所有其他的设置面板
Page.prototype.hideAllOtherSetting=function(){
    surveydsigner.showCurentPage();
    for(var i=0;i<this.listcontainer.length;i++)
    {
        this.listcontainer[i].showQuestion();
        this.listcontainer[i].hideQuestionSetting();
    }
}

//选中当前问题
Page.prototype.selectQuestionNow=function(question){
    var pagequesmenu=$("li[page-id='"+this.uuid+"']");
    $("#surveytree").find(".current").removeClass("current");
    question.questionmenu.addClass("current");
    question.addUpload();
}

//滚动到当前页面选中的问题
Page.prototype.toQuestion=function(question){
    question.hideQuestionSetting();
    question.showQuestion();
    this.selectQuestionNow(question);
    var position=question.questionview.position();
    $(".survey_content").scrollTop(position.top-115);

}

//移除问题
Page.prototype.removeQuestion = function (question) {
     //先移除这个容器里面该问题的引用
     var uuid=question.uuid;
     this.container.remove(uuid) ;
     var index=-1;
     for(var i=0;i<this.listcontainer.length;i++){
         if(question===this.listcontainer[i]){
             index=i;
             break;
         }
     }
     if(index>-1){
         this.listcontainer.splice(index,1);
     }
    question.questionview.remove();
    question.questionset.remove();
    var questionmenu= question.questionmenu;
    //优先选中下一个
    if(questionmenu.next().length===1){
        questionmenu.next().trigger("click");
    }else if(questionmenu.prev().length===1){
        questionmenu.prev().trigger("click");
    }
    questionmenu.remove();

}
//根据问题uuid获取问题
Page.prototype.getQuestionByKey=function(key){

         return  this.container.get(key);

}

//问题对象(所有问题的基类)
function Question() {


}
//展示问题
Question.prototype.showQuestion = function () {
    this.questionview.show();
}
//隐藏问题
Question.prototype.hideQuestion = function () {
    this.questionview.hide();
}
//显示问题设置
Question.prototype.showQuestionSetting = function () {
    this.questionset.show();
}
//隐藏问题设置
Question.prototype.hideQuestionSetting = function () {
    this.questionset.hide();
}
//初始化问题
Question.prototype.initQuestion = function () {
    //隐藏问题
    this.hideQuestion();
    //显示问题设置
    this.showQuestionSetting();
}

//上移操作
Question.prototype.up=function(toPage){
	doUpDown(this,toPage,"question","up");
}

//下移操作
Question.prototype.down=function(toPage,flag){
	if(flag == "load"){
	    var toquestionview=toPage.questionview;
	    //移动问题
	    this.questionview.insertAfter(toquestionview.next());
	    this.questionset.insertAfter(this.questionview);
	    //移动菜单
	    this.questionmenu.insertAfter(toPage.questionmenu);
	
	    if(this.questiontype==='2'){
	        //初始化html编辑器
	         this.initHtmlEditor();
	    }
	
	    //滚动条滚动到响应的问题
	    surveydsigner.getCurrentPage().toQuestion(this);
    }else{
    	doUpDown(this,toPage,"question","down");
    }
}

//初始化html编辑器
Question.prototype.initHtmlEditor=function(){


    var kindid="kid"+this.uuid;

    //移除已有的编辑器
    this.questionset.find(".ke-container").remove();

    this.questionset.find("textarea[name='contentdata']").attr("id",kindid);

    var  items=[
        'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist',
        'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable','fullscreen'
    ];
    KE.init({
        id :kindid,
        height :150+'px',
        width:'auto',
        resizeMode:1,
        imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
        allowFileManager : false,
        newlineTag:'br',
        jsPath:'http://www.e-cology.com.cn/express/js/require/require-jquery_wev8.js',
        cssPath:'http://www.e-cology.com.cn/express/css/jquery.fuzzyquery_wev8.css',
        items : items,
        afterCreate : function(id) {
            KE.util.focus(id);
        }
    });
    KE.create(kindid);

   //判断是否添加附件
    if(typeof(votingconfig) !== undefined  && votingconfig.annex==='on'){
        //初始化编辑器附件上传按钮
        var placehoder=this.questionset.find(".holder").attr("id");
        var process= this.questionset.find(".process").attr("id");
        var mainid= votingconfig.mainid;
         var subid=  votingconfig.subid;
         var seccateid= votingconfig.seccateid;
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            post_params: {
                "mainId":mainid,
                "subId":subid,
                "secId":seccateid,
                "logintype":1,
                "comefrom" : "VotingAttachment",
                "language":'7'

            },
            upload_url: "/voting/surveydesign/pages/fileUpload.jsp",
            file_size_limit :"50MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : "50",
            file_queue_limit : "0",
            custom_settings : {
                progressTarget : process
            },
            debug: false,

            //button_image_url : "/cowork/images/add_wev8.png",	// Relative to the SWF file
            button_placeholder_id : placehoder,

            button_width: 125,
            button_height: 18,
            //   button_image_url : "/voting/surveydesign/images/app-attach_wev8.png",
            button_text : '<span class="button">附件</span>',
            button_text_style : '.button { font-size: 12pt;color:#929393;background-color:blue } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 3,
            button_text_left_padding: 0,

            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){
                if (numFilesSelected > 0) {

                    jQuery("#fsUploadProgressannexuploadSimple").show();
                    this.startUpload();
                }

            },
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            queue_complete_handler : queueComplete,

            upload_success_handler : function (file, server_data) {
                var id=$.trim(server_data);
                var size=Math.floor(file.size/1024);
                var item="<div class=\"introduceAttr\"><a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+id+"\""+
                    " onclick=\"try{openSdoc('"+id+"',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\"> "+file.name+
                    " </a><a class=\"download\" href=\"javascript:void(0)\" style='margin-left:15px' unselectable=\"off\" contenteditable=\"false\" linkid=\""+id+"\" "+
                    " onclick=\"try{downSdoc('"+id+"',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\">下载("+size+"K)</a><div class=\"clearboth\"></div></div>";
                KE.insertHtml(kindid,item);
            },

            upload_complete_handler : function(file){
                if(this.getStats().files_queued==0){
                    //清空上传进度条
                    jQuery("#"+process).html("");
                }
            }
        };

        try {
            new SWFUpload(settings);
        } catch(e) {
            // alert(e)
        }


    }


}

Question.prototype.initRemarkEditor = function(option){
	if(option.find("textarea[name='remark']").length == 0)return;
	
	var kindid="kid"+new UUID();
	
	var content = option.find("textarea[name='remark']").html();
	
    //移除已有的编辑器
   // this.questionset.find(".ke-container").remove();
    option.find(".ke-container").remove();

    option.find("textarea[name='remark']").attr("id",kindid);

    var  items=[
        'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist',
        'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough'
    ];
    KE.init({
        id :kindid,
        height :150+'px',
        width:'auto',
        resizeMode:1,
        imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
        allowFileManager : false,
        newlineTag:'br',
        jsPath:'http://www.e-cology.com.cn/express/js/require/require-jquery_wev8.js',
        cssPath:'http://www.e-cology.com.cn/express/css/jquery.fuzzyquery_wev8.css',
        items : items,
        afterCreate : function(id) {
            KE.util.focus(id);
        }
    });
    KE.create(kindid);
   // KE.text(content);
}


//黏贴问题
Question.prototype.pasteQuestionCopy=function(){

    //获取复制的问题
     var _questioncopy=surveydsigner.getQuestionCopy();
     
     var questioncopy;
     if(_questioncopy.questiontype == "0"){
       questioncopy = new  SignalSelectQuestion(new UUID());
     }else if(_questioncopy.questiontype == "1"){
     	questioncopy = new  MatrixQuestion(new UUID());
     }else if(_questioncopy.questiontype == "2"){
     	questioncopy = new  SueveyIntroduceQuestion(new UUID());
     }else if(_questioncopy.questiontype == "3"){
     	questioncopy = new  BlankfillingQuestion(new UUID());
     }else{
     	return;
     }
     
    var _setting = JSON.parse(JSON.stringify(_questioncopy.setting));
    questioncopy.setting= $.extend({},_setting);
   
    //获取当前页
    var currentpage=surveydsigner.getCurrentPage();
    //将标题赋值
    surveydsigner.addLoadingIcon($(document.body));
	var that = this;
	var votingId = jQuery("input[name='votingid']").val();
	
	questioncopy.setting.qid = "";
	questioncopy.setting.showorder = parseInt(this.setting.showorder) + 1;
	if(questioncopy.setting.options){
		var options = questioncopy.setting.options;
		for(var i = 0 ;i < options.length;i++){
			options[i].oid = "";
			if(options.attrs){
				for(var j = 0;j < options.attrs.length;j++){
					options.attrs[j].oid = "";
					options.attrs[j].aid = "";
				}
			}
			if(options.images){
				for(var j = 0;j < options.images.length;j++){
					options.images[j].oid = "";
					options.images[j].aid = "";
				}
			}
		}
	}
	
	questioncopy.setting.pagenum = currentpage.getPageCount();
	
	jQuery.ajax({
     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=save&votingId=" + votingId,
     	type : "post",
     	data : questioncopy.setting,
     	dataType : "json",
     	success : function(data){
     		if(!data || data.flag == "0"){
     			surveydsigner.removeLoadingIcon($(document.body))
     			window.top.Dialog.alert("粘贴失败!");
     			return;
     		}
     		
     		replaceQuestionIds(questioncopy,data.returnData);
     		
     		var surveytitle=questioncopy.setting.name;
		    if(surveytitle && that.questiontype != '2'){
		        questioncopy.questionmenu.find(".label").html(surveytitle);
		        questioncopy.questionmenu.find(".part").attr("title",surveytitle);
		    }else{
		       if(that.questiontype==='0' || that.questiontype==='1'){
		           surveytitle="新建问题";
		       }else if(that.questiontype==='2'){
		           surveytitle="自定义文字";
		       }
		        questioncopy.questionmenu.find(".label").html(surveytitle);
		        questioncopy.questionmenu.find(".part").attr("title",surveytitle);
		    }
		    //将复制的问题置于该问题之下
		    questioncopy.down(that,"load");
		    //隐藏其它问题的设置选项
		    currentpage.hideAllOtherSetting();
		    //初始化问题设置
		    questioncopy.initQuestion();
		    //初始化html编辑器
		    if(this.questiontype==='2'){
		        //初始化html编辑器
		        questioncopy.initHtmlEditor();
		    }
		    //展示问题
		    questioncopy.geneartorQuestion();
		    //展示设置面板
		    questioncopy.restoreSettingPanel();
		    //添加问题到容器
		    currentpage.listcontainer.push(questioncopy);
		    //向map里面添加问题
		    currentpage.container.put(questioncopy.uuid,questioncopy);
		    
		    
		    //重新排序
		    var questions = currentpage.getPageQuestions();
		    for(var i = 0; i < questions.length;i++){
		    	if(questions[i].setting && questions[i].setting.showorder){
		    		questions[i].setting.showorder = parseInt(questions[i].questionmenu.index()) + 1;
		    	}
		    }
     	},
     	error : function(){
     		surveydsigner.removeLoadingIcon($(document.body));
     		window.top.Dialog.alert("粘贴失败!");
     	},
     	complete : function(){
     		surveydsigner.removeLoadingIcon($(document.body));
     	}
     });    
}

//问题对应的菜单选项
Question.prototype.getQuestionMenu=function(){
    return  this.questionmenu;
}
//问题提示信息(选择 多选使用)
Question.prototype.showTip=function(){
    var   isrequest = this.setting.ismustinput;
    var  type = this.setting.type;
    var  typestr="";
    if(isrequest==="1"){
        this.questionview.find(".require").show();
        typestr="必填,";
    }else if(isrequest==="0"){
        this.questionview.find(".require").hide();
    }
    //radio 和 select
    if(type==='0' || type==='2'){
        typestr=typestr+"单选";
    }else if(type='1'){
        typestr=typestr+"多选"
    }
    this.questionview.find(".rules").html("("+typestr+")");
}


//单选问题
function SignalSelectQuestion(uuid) {

    //问题类型
    this.questiontype="0";

    //问题标识
    this.uuid=uuid;
    this.setting = {type: "0", name: "", options: [{label:""},{label:""},{label:""}], ismustinput: "0",isother:"0", declare: "", limit: "-1", max: "-1", perrowcols: "1", israndomsort: "0"};
    //问题容器(jq对象)
    this.questionview = $(".survey_template_select").clone();
    this.questionview.removeClass("survey_template_select");
    this.questionview.attr("qusid",this.uuid);

    //问题设置容器(jq对象)
    this.questionset = $(".survey_template_selectset").clone();
    this.questionset.removeClass("survey_template_selectset");
    this.questionset.attr("qussetid",this.uuid);

	this.setting.imageHi = "80";
	this.setting.imageWi = "100";


   //添加可拖拽
    this.questionset.find(".ui-sortable").sortable({ handle: '.i_handle' });


    //默认单选
    this.questionset.find("input[name='type'][value='0']").trigger("click");
    //问题菜单
    this.questionmenu=$("<li class='part node current' id='"+this.uuid+"' title='新建问题'><span class='i i_select'></span><span class='label'>新建问题</span></li>");

    this.geneartorQuestion();
    this.restoreSettingPanel();

   //绑定事件
    this.bindEvent();
}

//继承中间过渡层,主要存放问题原型自身的一些方法
function QuestionMiddle() {

}
QuestionMiddle.prototype = new Question();


SignalSelectQuestion.prototype = new QuestionMiddle();



//复制问题
SignalSelectQuestion.prototype.getQuestionCopy=function(){
       var questionclone=new  SignalSelectQuestion(new UUID());
       //克隆操作数据
       questionclone.setting= $.extend({},this.setting);
       return   questionclone;
}


//恢复options选项设置(批量设置)
SignalSelectQuestion.prototype.restoreOptions=function(options){

    if(options.length>0){
            //恢复所有选项
            var lilist = this.questionset.find(".list");
         //   lilist.html("");
            var newop;
            for (var i = 0; i < options.length; i++) {
                newop = this.questionset.find(".clone .option").clone();
                newop.find("input[name='label']").val(options[i].label);
                lilist.append(newop);
            }
            lilist.find(".uploader").each(function(){
            	var _uuid = new UUID();
		    	jQuery(this).attr("id",_uuid).parent().attr("uploadData",_uuid);
		    });
		    this.addUpload();
    }
}


//恢复设置面板
SignalSelectQuestion.prototype.restoreSettingPanel = function () {

    var options = this.setting.options;
    if (options.length > 0) {
        var type = this.setting.type;
        //恢复类型设置选项
        this.questionset.find("input[name='type'][value='" + type + "']").trigger("click");
        //恢复必填设置
        var ismust = this.setting.ismustinput;
        if (ismust === '1') {
            this.questionset.find("input[name='isrequest']").prop("checked", true);
        } else {
            this.questionset.find("input[name='isrequest']").prop("checked", false);
        }
        //其它输入
        var isother = this.setting.isother;
        if (isother === '1') {
            this.questionset.find("input[name='isother']").prop("checked", true);
        } else {
            this.questionset.find("input[name='isother']").prop("checked", false);
        }
        var limit = this.setting.limit;
        var max = this.setting.max;
        var columns = this.setting.perrowcols;
        if ("" !== limit &&  "-1"!==limit) {   //恢复最小选项
            this.questionset.find("input[name='limit']").val(limit);
        }
        if ("" !== max &&  "-1"!==max) {   //恢复最大选项
            this.questionset.find("input[name='max']").val(max);
        }
        //设置每行多少列
        this.questionset.find("select[name='column']").val(columns);
        //随机排序
        if (this.setting.israndomsort === '1') {
            this.questionset.find("input[name='shuffle']").prop("checked", true);
        } else {
            this.questionset.find("input[name='shuffle']").prop("checked", false);
        }
        
        this.questionset.find("input[name='qid']").val(this.setting.qid);
        
        //恢复标题
        this.questionset.find("input[name='subject']").val(this.setting.name);
        //恢复所有选项
        var lilist = this.questionset.find(".list");
        //lilist.html("");
        lilist[0].innerHTML = "";
        //恢复图片宽
        var wi = this.setting.imageWi;
        if(wi){
        	this.questionset.find("input[name='imageWidth']").val(wi);
        }
        //恢复图片高
        var hi = this.setting.imageHi;
        if(hi){
        	this.questionset.find("input[name='imageHeight']").val(hi);
        }
        var newop;
        
        
        for (var i = 0; i < options.length; i++) {
	        var optionIndex = 4;
	        var imageIndex = 4;
	        var attrIndex = 4;
	        var remarkIndex = 4;
            newop = this.questionset.find(".clone .option").clone();
            newop.find("input[name='oid']").val(options[i].oid);
            newop.find("input[name='label']").val(options[i].label);
            newop.find("input[name='oinner']").val(options[i].oinner);
            optionIndex = options[i].oinner;
            if(options[i].images){
            	var images = options[i].images;
            	for(var j = 0;j < images.length;j++){
            		newop.find(".voting_image")
            			.append(getImageDiv({
            				wi : wi,
            				hi : hi,
            				fid : images[j].fid,
            				aid : images[j].aid,
            				order : images[j].iinner
            			})).addClass("has_data");
            	}
            	imageIndex = images.length > 0 ? images[0].iinner : imageIndex;
            }
            if(options[i].attrs){
            	var attrs = options[i].attrs;
            	for(var j = 0;j < attrs.length;j++){
            		newop.find(".voting_attr")
            			.append(getAttrDiv({
            				title : attrs[j].title,
            				fid : attrs[j].fid,
            				size : attrs[j].size,
            				aid : attrs[j].aid,
            				order : attrs[j].iinner
            			})).addClass("has_data");
            	}
            	attrIndex = attrs.length > 0 ? attrs[0].iinner : attrIndex;
            }
            if(options[i].remark){
            	newop.find(".voting_remark")
            			.append(getRemarkText({
            				text : options[i].remark,
            				order : options[i].remarkorder
            			})).addClass("has_data");
            	newop.find(".i_remark").addClass("i_remark_edit");	
            	remarkIndex = options[i].remarkorder;	
            }
            
            for(var j = 0;j <= 4;j++){
            	if(optionIndex == j){
            		newop.append(newop.find(".voting_question"));
            	}
            	if(imageIndex == j){
            		newop.append(newop.find(".voting_image"));
            	}
            	if(attrIndex == j){
            		newop.append(newop.find(".voting_attr"));
            	}
            	if(remarkIndex == j){
            		newop.append(newop.find(".voting_remark"));
            	}
            }
            
            
            lilist.append(newop);
            
            var that = this;
		    lilist.find(".uploader").each(function(i){
		    	jQuery(this).attr("id",that.uuid + i).parent().attr("uploadData",that.uuid + i);
		    });
		    lilist.closest(".part_set").children(".process").attr("id",that.uuid + "process");
		    this.initRemarkEditor(newop);
		    showOrHideOperator(newop);
        }
        
        bindImageEvent(lilist);
        bindAttrEvent(lilist);
    }
    else{
        //在未设置时,默认为单选框
        this.questionset.find("input[name='type'][value='0']").trigger("click")
    }


}

//生成问题面板
SignalSelectQuestion.prototype.geneartorQuestion = function () {
	var votingId = jQuery("input[name='votingid']").val();
    //单选类型
    var type = this.setting.type;
    //每列个数
    var column = this.setting.perrowcols;
    //所有选项
    var options = this.setting.options;
    //填充标题
    this.questionview.find(".subject").html(this.setting.name === "" ? "新建标题" : this.setting.name);
    //问题提示信息
    this.showTip();
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

        var li;
        content = $("<ul class='options'></ul>");
        //每列显示一个(ul显示)
        if (~~column === 1) {
            for (var i = 0; i < options.length; i++) {
            	var _li = "<li ><div class='voting_question_show'><input type='" + inputtype + "' /><label>" + (options[i].label === "" ? "选项" : options[i].label) + "</label></div>";
            	
				var optionIndex = 4;
		        var imageIndex = 4;
		        var attrIndex = 4;
		        var remarkIndex = 4;    
		        
		        optionIndex = options[i].oinner;        	
            	if(options[i].images){
            		var images = options[i].images;
            		_li += "<div class='voting_image_show'>";
            		for(var j = 0;j < images.length;j++){
            			_li += "<div class='image_div_show'>" + 
            				"<img width=" + this.setting.imageWi + " height='" + this.setting.imageHi + "' src='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + images[j].fid + "'/>" +
            				"<input type='hidden' name='aid' value='" + images[j].aid + "'/>" +
            				"<input type='hidden' name='fid' value='" + images[j].fid + "'/>" +
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
            				"<a href='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + attrs[j].fid + "'><label>" + attrs[j].title + "</label></a>" +
            				"<a class='download' target='_blank' style='margin-left:15px' href='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + attrs[j].fid + "'>下载(" + Math.floor(attrs[j].size/1024) + "KB)</a>" +
            				"<div class=\"clearboth\"></div>" +
            				"<input type='hidden' name='aid' value='" + attrs[j].aid + "'/>" +
            				"<input type='hidden' name='fid' value='" + attrs[j].fid + "'/>" +
            				"<input type='hidden' name='size' value='" + attrs[j].size + "'/>" +
            				"<input type='hidden' name='title' value='" + attrs[j].title + "'/>" +
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
            //其它选项
            if(this.setting.isother==='1'){
                li = $("<li ><input type='" + inputtype + "' ><label>其它</label><input style='display: none'></li>");
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
            var optionstemp=[];
            for(var i=0;i<options.length;i++){
                optionstemp.push(options[i]);
            }
            //其它选项
            if(this.setting.isother==='1'){
                var othertemp={};
                othertemp.label="其它";
                optionstemp.push(othertemp);
            }
            for (var i = 0; i < optionstemp.length; i++) {
                if (i % ~~column === 0) {
                    tr = $("<tr></tr>");
                    content.append(tr);
                }
                
                var optionIndex = 4;
		        var imageIndex = 4;
		        var attrIndex = 4;
		        var remarkIndex = 4;    
		        
		        optionIndex = optionstemp[i].oinner;        	
                
                var _tdcontent = "<td style='vertical-align:top'>" 
                _tdcontent += "<div class='voting_question_show'><input type='" + inputtype + "' ><label>" + (optionstemp[i].label === "" ? "选项" : optionstemp[i].label) + "</label></div>";
                if(optionstemp[i].images){
            		var images = optionstemp[i].images;
            		_tdcontent += "<div class='voting_image_show'>";
            		for(var j = 0;j < images.length;j++){
            			_tdcontent += "<div class='image_div_show'>" + 
            				"<img width=" + this.setting.imageWi + " height='" + this.setting.imageHi + "' src='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + images[j].fid + "'/>" +
            				"<input type='hidden' name='aid' value='" + images[j].aid + "'/>" +
            				"<input type='hidden' name='fid' value='" + images[j].fid + "'/>" +
            				"</div>";
            		}
            		_tdcontent +=	"</div>";
            		
            		imageIndex = images.length > 0 ? images[0].iinner : imageIndex;
            	}
            	if(optionstemp[i].attrs){
            		var attrs = optionstemp[i].attrs;
            		_tdcontent += "<div class='voting_attr_show'>";
            		for(var j = 0;j < attrs.length;j++){
            			_tdcontent += "<div class='attr_pdiv_show'>" +
            				"<div class='attr_div_show'>" + 
            				"<a href='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + attrs[j].fid + "'><label>" + attrs[j].title + "</label></a>" +
            				"<a class='download' target='_blank' style='margin-left:15px' href='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + attrs[j].fid + "'>下载(" + Math.floor(attrs[j].size/1024) + "KB)</a>" +
            				"<div class=\"clearboth\"></div>" +
            				"<input type='hidden' name='aid' value='" + attrs[j].aid + "'/>" +
            				"<input type='hidden' name='fid' value='" + attrs[j].fid + "'/>" +
            				"<input type='hidden' name='size' value='" + attrs[j].size + "'/>" +
            				"</div></div>";
            				
            		}
            		_tdcontent +=	"</div>";
            		
            		attrIndex = attrs.length > 0 ? attrs[0].iinner : attrIndex;
            	}
            	if(optionstemp[i].remark){
            		_tdcontent += "<div class='voting_remark_show'><pre>" + optionstemp[i].remark + "</pre></div>";
            		
            		remarkIndex = optionstemp[i].remarkorder;
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
         content = $("<select class='qs_select'><option>--请选择--</option></select>");
         var newop;
        for (var i = 0; i < options.length; i++) {
              newop=$("<option >"+options[i].label+"</option>");
              content.append(newop);
        }
    }

    var intro = this.questionview.find(".intro");
    intro.next().remove();
    content.insertAfter(intro);

}

//刷新问题菜单
SignalSelectQuestion.prototype.refreshQuestionMenu=function(){
      var questionmenu=this.getQuestionMenu();
      var label=this.setting.name;
      var type=this.setting.type;
      if(type==='0' || type==='2'){
          questionmenu.find('.i').removeClass().addClass('i i_select');
      }else if(type==='1'){
          questionmenu.find('.i').removeClass().addClass('i i_mselect');
      }
    questionmenu.find('.label').html(label===""?"新建问题":label);
    questionmenu.attr("title",label===""?"新建问题":label);
}

//绑定事件处理
SignalSelectQuestion.prototype.bindEvent = function () {
    var that = this;

    //注册鼠标移动事件
    that.questionview.mouseover(function () {
        $(this).addClass("hover");
        $(this).find(".survey_buttons").show();
    }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find(".survey_buttons").hide();
        });
    //注册问题点击事件
    that.questionview.click(function (e) {

        var target = $(e.target);
        //向上移动
        if(target.hasClass("i_up") || target.hasClass("up")){
            var compnents=target.parents(".survery_component").prevAll(".survery_component");
            if(compnents.length>1)
            {
                 var fromuuid=target.parents(".survery_component").attr("qusid");
                 var touuid=$(compnents[0]).attr("qusid");
                 var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                 var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                 fromQuestion.up(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //向下移动
        if(target.hasClass("i_down") || target.hasClass("down")){

            var compnents=target.parents(".survery_component").nextAll(".survery_component");
            if(compnents.length>0)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.down(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }
        //复制操作
        if(target.hasClass("i_copy") || target.hasClass("copy")){

            //获取用户要复制的问题
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            surveydsigner.setCloneQuestion(question);
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //黏贴操作
        if(target.hasClass("i_paste") || target.hasClass("paste")){
           //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
            question.pasteQuestionCopy();
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //删除操作
        if(target.hasClass("i_editor_del") || target.hasClass("remove")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
           /* surveydsigner.getCurrentPage().removeQuestion(question);
            e.stopPropagation();
            e.preventDefault();*/
             window.top.Dialog.confirm("确定删除吗?",function(){
            	doDelete(question,"delete",e);
            });
            return;
        }

        //隐藏其它设置面板
        surveydsigner.getCurrentPage().hideAllOtherSetting();
        //恢复设置面板
        that.restoreSettingPanel();
        that.hideQuestion();
        that.showQuestionSetting();
        //选中当前问题
        surveydsigner.getCurrentPage().selectQuestionNow(that);
        
        if(that.questiontype == "0"){
	    	that.addUpload();
	    }
    });

    //设置按钮点击事件(采用事件代理方式处理)
    that.questionset.click(function (e) {
        var questionset = $(this);
        var target = $(e.target);
        //图片上传
        if(target.hasClass("i_image")){
			/*var path = "../images/survey_save_wev8.png";
			var wi = target.closest(".part_set").find(".imageWidth").val();
			wi = wi == "" ? "100" : wi;
			var hi = target.closest(".part_set").find(".imageHeight").val();
			hi = hi == "" ? "80" : hi;
			target.closest("li").find(".voting_image").append(getImageDiv({
				fid : fid,
				aid : "",
				wi : wi,
				hi : hi
			}));
			bindImageEvent(target.closest("li"));
	*/
        }
        //附件上传
        if(target.hasClass("i_attr")){
			/*var path = "";
			var title = "新增附件";
			target.closest("li").find(".voting_attr").append(getAttrDiv({
				path : path,
				title : title
			}));
			bindAttrEvent(target.closest("li"));*/
			//target.next(".swfupload").click();
        }
        //说明
        if(target.hasClass("i_remark")){
        	if(target.hasClass("i_remark_edit")){
	        	//target.removeClass("i_remark_edit").closest("li").find(".voting_remark remark").remove();
	        	//target.closest("li").find(".voting_remark .innerorder").remove();
	        	window.top.Dialog.confirm("确定删除吗?",function(){
		        	target.removeClass("i_remark_edit").closest("li").find(".voting_remark .voting_operator").siblings().remove();
		        	target.closest("li").find(".voting_remark").removeClass("has_data");
		        	showOrHideOperator(target.closest("li"));
	            });
        	}else{
        		target.addClass("i_remark_edit").closest("li").find(".voting_remark").append(getRemarkText({
        				text : '',
        				order : target.closest("li").find(".voting_remark").index()
        			})).addClass("has_data");
        		that.initRemarkEditor(target.closest("li"));	
        		showOrHideOperator(target.closest("li"));
        	}
        }
        
        //上移
        if(target.hasClass("voting_up")){
        	var $obj = target.closest(".voting_operator").parent();
        	if($obj.prevAll(".has_data").length > 0){
        		var _parentClass = $obj.attr("class");
        		var $toObj = $obj.prevAll(".has_data").first();
        		if(_parentClass.indexOf("voting_remark") >= 0){  //如果是备注（富文本），则移动目标，（如果移动富文本导致富文本无法编辑）
        			$toObj.insertAfter($obj);
        		}else{
        			$obj.insertBefore($toObj);
        		}
        		$obj.find(".innerorder").val($obj.index());
        		$toObj.find(".innerorder").val($toObj.index());
	        	showOrHideOperator(target.closest("li"));
        	}
        }
        //下移
 		if(target.hasClass("voting_down")){
 			var $obj = target.closest(".voting_operator").parent();
 			if($obj.nextAll(".has_data").length > 0){
 				var _parentClass = $obj.attr("class");
 				var $toObj = $obj.nextAll(".has_data").first();
 				if(_parentClass.indexOf("voting_remark") >= 0){  //如果是备注（富文本），则移动目标，（如果移动富文本导致富文本无法编辑）
        			$toObj.insertBefore($obj);
        		}else{
        			$obj.insertAfter($toObj);
        		}
        		$obj.find(".innerorder").val($obj.index());
        		$toObj.find(".innerorder").val($toObj.index());
	        	showOrHideOperator(target.closest("li"));
        	}
 		}
 		       
        //新增选项
        if (target.hasClass("i_create")) {
            var newop = questionset.find(".clone .option").clone();
            newop.insertAfter(target.closest("li"));
            newop.find(".uploader").each(function(){
            	var _uuid = new UUID();
            	jQuery(this).attr("id",_uuid).parent().attr("uploadData",_uuid);
            });
            that.addUpload();
        }
        //删除选项
        if (target.hasClass("i_del")) {
            if (questionset.find(".options .option").length > 2) {
                target.closest("li").remove();
            }
        }
        //选中下拉框
        if (target.attr("name") === 'type') {

            if (target.attr("value") === '2' && target.is(":checked")) {
                questionset.find(".setting  .container").hide();
            } else if (target.attr("value") === '1') {
                questionset.find(".setting  .container").show();
            } else if (target.attr("value") === '0') {
                questionset.find(".setting  .container").hide();
                questionset.find(".setting  .percolumns").show();
            }

        }
        //批量设置
        if (target.attr("name") === 'batch'){
            var uuid=that.uuid;
            //设置uuid
            $("#popup").find("input[type='hidden'][name='qusuuid']").val(uuid);
            //非行列 默认为-1
            $("#popup").find("input[type='hidden'][name='roworcolumn']").val("-1");
            //清空设置内容区域
            $("textarea[name='options']").val("");
             //打开批量设置面板
             $("#popup").bPopup({opacity: 0.2});
        }
        //取消按钮
        if (target.hasClass("cancel")) {
            that.hideQuestionSetting();
            that.showQuestion();
        }
        //确认按钮
        if (target.hasClass("confirm")) {
            var type = questionset.find("input[name='type']:checked").val();
            var limit = questionset.find("input[name='limit']").val();
            var max = questionset.find("input[name='max']").val();
            var column = questionset.find("select[name='column']").val();
            var name = questionset.find("input[name='subject']").val();
            var imageWi = questionset.find("input[name='imageWidth']").val();
            var imageHi = questionset.find("input[name='imageHeight']").val();
            
            imageWi = imageWi.replace(/ /g,"");
            imageHi = imageHi.replace(/ /g,"");
            
            imageWi = imageWi == "" ? "100" : imageWi;
            imageHi = imageHi == "" ? "80" : imageHi;
            if(!/^\d+$/.test(imageWi) || !/^\d+$/.test(imageHi)){
            	window.top.Dialog.alert("图片的【宽】【高】必须为【正整数】！");
            	return;
            }
            
            that.setting.type = type;
            that.setting.limit = limit;
            that.setting.max = max;
            that.setting.perrowcols = column;
            that.setting.name = name;
            that.setting.imageWi = imageWi;
            that.setting.imageHi = imageHi;
            that.setting.questiontype = that.questiontype;
            //是否必填
            if (questionset.find("input[name='isrequest']").is(":checked")) {
                that.setting.ismustinput = "1";
            } else {
                that.setting.ismustinput = "0";
            }
            //其它输入
            if (questionset.find("input[name='isother']").is(":checked")) {
                that.setting.isother = "1";
            } else {
                that.setting.isother = "0";
            }

            if (questionset.find("input[name='shuffle']").is(":checked")) {
                that.setting.israndomsort = "1";
            } else {
                that.setting.israndomsort = "0";
            }
            that.setting.options = [];
            var options = questionset.find(".options .option");
            var label;
            for (var i = 0; i < options.length; i++) {
                var option = {};
                label = $(options[i]).find("input[name='label']").val();
                option.label = label;
                option.remark = $(options[i]).find("textarea[name='remark']").val();
                option.oid = $(options[i]).find("input[name='oid']").val();
                option.oinner = $(options[i]).find("input[name='oinner']").val();
                option.remarkorder = $(options[i]).find("input[name='remarkorder']").val();
                var $imgs = [];
                $(options[i]).find(".image_div").each(function(){
                	var $img = {};
                	//$img.path = jQuery(this).find("img").attr("src");
                	$img.fid = jQuery(this).find("input[name='fid']").val();
                	$img.aid = jQuery(this).find("input[name='aid']").val();
                	$img.iinner = jQuery(this).find("input[name='iinner']").val();
                	$imgs.push($img);
                });
                option.images = $imgs;
                var $attrs = []
                $(options[i]).find(".attr_div").each(function(){
                	var $attr = {};
                	$attr.fid = jQuery(this).find("input[name='fid']").val();
                	$attr.title = jQuery(this).find("input[name='title']").val();
                	$attr.aid = jQuery(this).find("input[name='aid']").val();
                	$attr.size = jQuery(this).find("input[name='size']").val();
                	$attr.iinner = jQuery(this).find("input[name='iinner']").val();
                	$attrs.push($attr);
                });
                option.attrs = $attrs;
                //添加标签选项
                that.setting.options.push(option);
            }
            
            doSaveQuestion(that)
        }

    });
}






//调查标题
function SueveyTitleQuestion(){

    this.setting = {title:"",describe:""};
    //问题容器(jq对象)
    this.questionview = $(".survey_template_header").clone();
    this.questionview.removeClass("survey_template_header");

    //问题设置容器(jq对象)
    this.questionset = $(".survey_template_headerset").clone();
    this.questionset.removeClass("survey_template_headerset");

    $(".survey_page").append(this.questionview);
    $(".survey_page").append(this.questionset);

    //绑定事件
    this.bindEvent();

}

//集成question对象
SueveyTitleQuestion.prototype = new QuestionMiddle();
//绑定事件
SueveyTitleQuestion.prototype.bindEvent=function(){

     var that=this;
     var questionview=this.questionview;
     var questionset=this.questionset;
      //注册鼠标事件
      questionview.mouseover(function () {
            $(this).addClass("hover");
            $(this).find(".survey_buttons").show();
       }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find(".survey_buttons").hide();
         });
        //标题点击进入编辑状态
        questionview.click(function(){
            //隐藏其它设置面板
            surveydsigner.getCurrentPage().hideAllOtherSetting();
            that.restoreSettingPanel();
            that.hideQuestion();
            that.showQuestionSetting();
        });
      //设置面板操作(采用事件代理)
        questionset.click(function(e){
            var target=$(e.target);
            //确认
            if(target.hasClass("confirm")){
                var title=questionset.find("input[name='title']").val();
                that.setting.title=title;
                doSaveQuestion(that);
            }
            //取消
            if(target.hasClass("cancel")){
                that.hideQuestionSetting();
                that.showQuestion();
            }

        });


}
//生成具体的标题
SueveyTitleQuestion.prototype.geneartorQuestion=function(){

       var title=this.setting.title;
       var questionview=this.questionview;
       questionview.find(".survey-title").html(title===''?'新建调查表':title);

}
//恢复标题设置面板
SueveyTitleQuestion.prototype.restoreSettingPanel=function(){
       var title=this.setting.title;
       var questionset=this.questionset;
      questionset.find("input[name='title']").val(title);
      questionset.find("input[name='qid']").val(this.setting.qid);
}


//组合选项(矩阵问题)
function MatrixQuestion(uuid){

    //组合类型
    this.questiontype="1";
    //问题标识
    this.uuid=uuid;
    this.setting = {type: "0", name: "",rows:[{label:""},{label:""},{label:""}],cols:[{label:""},{label:""},{label:""},{label:""}],options: [], ismustinput: "0", declare: "", limit: "-1", max: "-1", perrowcols: "1", israndomsort: "0"};
    //问题容器(jq对象)
    this.questionview = $(".survey_template_matrix").clone();
    this.questionview.removeClass("survey_template_matrix");
    this.questionview.attr("qusid",this.uuid);

    //问题设置容器(jq对象)
    this.questionset = $(".survey_template_matrixset").clone();
    this.questionset.removeClass("survey_template_matrixset");
    this.questionset.attr("qussetid",this.uuid);

    //添加问题拖拽
    this.questionset.find(".row_options .ui-sortable").sortable({ handle: '.i_handle' });
    //添加选项拖拽
    this.questionset.find(".col_options .ui-sortable").sortable({ handle: '.i_handle' });

    //默认单选
    this.questionset.find("input[name='type'][value='0']").trigger("click");
    //问题菜单
    this.questionmenu=$("<li class='part node current' id='"+this.uuid+"' title='新建问题'><span class='i i_matrix'></span><span class='label'>新建问题</span></li>");

    this.geneartorQuestion();
    this.restoreSettingPanel();

    //绑定事件
    this.bindEvent();


}
MatrixQuestion.prototype=new QuestionMiddle();


//恢复options选项设置(批量设置)
MatrixQuestion.prototype.restoreOptions=function(options,isroworcolumn){

    if(options.length>0){
        //恢复所有选项
        var lilist;
        if(isroworcolumn==='0')
            lilist = this.questionset.find(".row_options .list");
        else
            lilist = this.questionset.find(".col_options .list");
      //  lilist.html("");
        var newop;
        for (var i = 0; i < options.length; i++) {
            if(isroworcolumn==='0')
            newop = this.questionset.find(".clone .row").clone();
            else
            newop = this.questionset.find(".clone .col").clone();
            newop.find("input[name='label']").val(options[i].label);
            lilist.append(newop);
        }
    }
}

//绑定事件
MatrixQuestion.prototype.bindEvent=function(){

    var that=this;
    var questionview=this.questionview;
    var questionset=this.questionset;
    //注册鼠标事件
    questionview.mouseover(function () {
        $(this).addClass("hover");
        $(this).find(".survey_buttons").show();
    }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find(".survey_buttons").hide();
     });

    //点击问题,进入设置面板
    questionview.click(function(e){
        var   target=$(e.target);

        //向上移动
        if(target.hasClass("i_up") || target.hasClass("up")){

            var compnents=target.parents(".survery_component").prevAll(".survery_component");
            if(compnents.length>1)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.up(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //向下移动
        if(target.hasClass("i_down") || target.hasClass("down")){

            var compnents=target.parents(".survery_component").nextAll(".survery_component");
            if(compnents.length>0)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.down(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //复制操作
        if(target.hasClass("i_copy") || target.hasClass("copy")){

            //获取用户要复制的问题
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            surveydsigner.setCloneQuestion(question);
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //黏贴操作
        if(target.hasClass("i_paste") || target.hasClass("paste")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
            question.pasteQuestionCopy();
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //删除操作
        if(target.hasClass("i_editor_del") || target.hasClass("remove")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
            /*surveydsigner.getCurrentPage().removeQuestion(question);
            e.stopPropagation();
            e.preventDefault();*/
             window.top.Dialog.confirm("确定删除吗?",function(){
            	doDelete(question,"delete",e);
            });
            return;
        }

        //隐藏其它设置面板
        surveydsigner.getCurrentPage().hideAllOtherSetting();
        that.hideQuestion();
        that.restoreSettingPanel();
        that.showQuestionSetting();
        //选中当前问题
        surveydsigner.getCurrentPage().selectQuestionNow(that);
    });

    //设置面板点击事件
    questionset.click(function(e){
         var target=$(e.target);
         //取消按钮
         if(target.hasClass("cancel")){
             questionset.hide();
             questionview.show();
         }
        //确认按钮
         if(target.hasClass("confirm")){
             //清空行列选项
             that.setting.cols=[];
             that.setting.rows=[];
             //类型
             var type=questionset.find("input[type='radio'][name='type']:checked").val();
             that.setting.type=type;
             that.setting.questiontype = that.questiontype;
             var isrequest="0";
             //是否必填
             if(questionset.find("input[type='checkbox'][name='isrequest']").is(":checked")) {
                 isrequest="1";
             }
             that.setting.ismustinput=isrequest;

			// that.setting.qid = questionset.find("input[name='qid']").val();
             //获取标题
             var subject=questionset.find("input[name='subject']").val();
             that.setting.name=subject;

             //获取行标签
             var rowops=questionset.find(".row_options .list li");
             var label;
             var option;
             for(var i=0;i<rowops.length;i++){
                 option={};
                 label= $(rowops[i]).find("input[name='label']").val();
                 option.oid = $(rowops[i]).find("input[name='oid']").val();
                 option.label=label;
                 that.setting.rows.push(option);
             }
            //添加列标签
             var colops=questionset.find(".col_options .list li");
             for(var i=0;i<colops.length;i++){
                 option={};
                 label= $(colops[i]).find("input[name='label']").val();
                 option.oid = $(colops[i]).find("input[name='oid']").val();
                 option.label=label;
                 that.setting.cols.push(option);
             }
             doSaveQuestion(that)
         }

        //问题批量设置
        if (target.attr("name") === 'batch'  &&  target.parents(".row_options").length>0){
            var uuid=that.uuid;
            //设置uuid
            $("#popup").find("input[type='hidden'][name='qusuuid']").val(uuid);
            //标识行或列
            $("#popup").find("input[type='hidden'][name='roworcolumn']").val("0");
            //清空设置内容区域
            $("textarea[name='options']").val("");
            //打开批量设置面板
            $("#popup").bPopup({opacity: 0.2});
        }

        //选项批量设置
        if (target.attr("name") === 'batch'  &&  target.parents(".col_options").length>0){
            var uuid=that.uuid;
            //设置uuid
            $("#popup").find("input[type='hidden'][name='qusuuid']").val(uuid);
            //标识行或列
            $("#popup").find("input[type='hidden'][name='roworcolumn']").val("1");
            //清空设置内容区域
            $("textarea[name='options']").val("");
            //打开批量设置面板
            $("#popup").bPopup({opacity: 0.2});
        }

         //新建行问题
        if( (target.hasClass("i_create") || target.hasClass("create") )  && target.parents(".row_options").length>0 ){
               var  newop = that.questionset.find(".clone .row").clone();
               var  opnow=target.parents(".option");
               newop.insertAfter(opnow);
        }
        //删除行问题
        if( (target.hasClass("i_del") || target.hasClass("remove") )  && target.parents(".row_options").length>0 ){
            if(target.parents(".row_options").find(".list li").length>1){
                var  opnow=target.parents(".option");
                opnow.remove();
            }
        }
        //新建列选项
        if( (target.hasClass("i_create") || target.hasClass("create") )  && target.parents(".col_options").length>0 ){
            var  newop = that.questionset.find(".clone .col").clone();
            var  opnow=target.parents(".option");
            newop.insertAfter(opnow);
        }
        //删除列问题
        if( (target.hasClass("i_del") || target.hasClass("remove") )  && target.parents(".col_options").length>0 ){
            if(target.parents(".col_options").find(".list li").length>2){
                var  opnow=target.parents(".option");
                opnow.remove();
            }
        }
    });
}


//复制问题
MatrixQuestion.prototype.getQuestionCopy=function(){
    var questionclone=new  MatrixQuestion(new UUID());
    //克隆操作数据
    questionclone.setting= $.extend({},this.setting);
    return   questionclone;
}

//生成问题面板
MatrixQuestion.prototype.geneartorQuestion = function () {
    //单选类型
    var type = this.setting.type;
    //列选项
    var cols = this.setting.cols;
    //行选项
    var rows = this.setting.rows;
    //填充标题
    this.questionview.find(".subject").html(this.setting.name === "" ? "新建标题" : this.setting.name);
    //问题提示信息
    this.showTip();
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
        var coltr=$("<tr><th></th></tr>");
        //添加列头
        for(var i=0;i<cols.length;i++){
            th=$("<th>"+(cols[i].label===''?'选项':cols[i].label)+"</th>");
            coltr.append(th);
        }
        content.append(coltr);
        //添加行头
        var rowtr;
        for(var i=0;i<rows.length;i++)
        {
            rowtr=$("<tr align='center'><td align='left'>"+(rows[i].label===''?'新建问题':rows[i].label)+"</td></tr>") ;
             for(var j=0;j<cols.length;j++)
            {
                td=$("<td><input type='"+inputtype+"' name='3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]'></td>");
                rowtr.append(td);
            }
            content.append(rowtr);
        }

    }

    var intro = this.questionview.find(".intro");
    intro.next().remove();
    content.insertAfter(intro);

}

//刷新问题菜单
MatrixQuestion.prototype.refreshQuestionMenu=function(){
    var questionmenu=this.getQuestionMenu();
    var label=this.setting.name;
    questionmenu.find('.label').html(label===""?"新建问题":label);
    questionmenu.attr("title",label===""?"新建问题":label);
}

//恢复多选设置面板
MatrixQuestion.prototype.restoreSettingPanel = function () {

    var type = this.setting.type;
    //恢复类型设置选项
    this.questionset.find("input[name='type'][value='" + type + "']").trigger("click");
    //恢复必填设置
    var ismust = this.setting.ismustinput;
    if (ismust === '1') {
        this.questionset.find("input[name='isrequest']").prop("checked", true);
    } else {
        this.questionset.find("input[name='isrequest']").prop("checked", false);
    }
    
    this.questionset.find("input[name='qid']").val(this.setting.qid);
    
    //恢复标题
    this.questionset.find("input[name='subject']").val(this.setting.name);

    //列标签
    var cols = this.setting.cols;
    var rows = this.setting.rows;
    var newop;
    var lilist;

    //恢复行选项
    if (rows.length > 0) {
        lilist = this.questionset.find(".row_options .list");
        lilist.html("");
        for (var i = 0; i < rows.length; i++) {
            newop = this.questionset.find(".clone .row").clone();
            newop.find("input[name='oid']").val(rows[i].oid);
            newop.find("input[name='label']").val(rows[i].label);
            lilist.append(newop);
        }
    }
    //恢复列选项
    if (cols.length > 0) {
        lilist = this.questionset.find(".col_options .list");
        lilist.html("");
        for (var i = 0; i < cols.length; i++) {
            newop = this.questionset.find(".clone .col").clone();
            newop.find("input[name='oid']").val(cols[i].oid);
            newop.find("input[name='label']").val(cols[i].label);
            lilist.append(newop);
        }
    }

}

//说明
function SueveyIntroduceQuestion(uuid){

    //说明类型
    this.questiontype="2";
    //问题标识
    this.uuid=uuid;
    this.setting = {title:"",content:""};
    this.setting.options = {};
    //问题容器(jq对象)
    this.questionview = $(".survey_template_introduce").clone();
    this.questionview.removeClass("survey_template_introduce");
    this.questionview.attr("qusid",this.uuid);

    //问题设置容器(jq对象)
    this.questionset = $(".survey_template_introduceset").clone();
    this.questionset.removeClass("survey_template_introduceset");
    this.questionset.attr("qussetid",this.uuid);

    //上传按钮占位符
    this.questionset.find(".holder").attr("id","ph"+this.uuid);
    //进度条
    this.questionset.find(".process").attr("id","ps"+this.uuid);

    //问题菜单
    this.questionmenu=$("<li class='part node current' id='"+this.uuid+"' title='自定义文字'><span class='i i_matrix'></span><span class='label'>自定义文字</span></li>");

    //说明配置(文档,流程等)
    if(typeof(votingconfig)!==undefined){
        if(votingconfig.doc!=='on'){
            this.questionset.find(".doc").remove();
        }
        if(votingconfig.flow!=='on')  {
            this.questionset.find(".flow").remove();
        }
        if(votingconfig.customer!=='on')  {
            this.questionset.find(".customer").remove();
        }
        if(votingconfig.project!=='on')  {
            this.questionset.find(".project").remove();
        }
        if(votingconfig.annex!=='on')  {
            this.questionset.find(".annex").remove();
        }
    }



    //绑定事件
    this.bindEvent();

}

//集成question对象
SueveyIntroduceQuestion.prototype = new QuestionMiddle();
//绑定事件
SueveyIntroduceQuestion.prototype.bindEvent=function(){

    var that=this;
    var questionview=this.questionview;
    var questionset=this.questionset;
    //注册鼠标事件
    questionview.mouseover(function () {
        $(this).addClass("hover");
        $(this).find(".survey_buttons").show();
    }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find(".survey_buttons").hide();
        });
    //标题点击进入编辑状态
    questionview.click(function(e){

        var   target=$(e.target);

        //向上移动
        if(target.hasClass("i_up") || target.hasClass("up")){
            var compnents=target.parents(".survery_component").prevAll(".survery_component");
            if(compnents.length>1)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.up(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //向下移动
        if(target.hasClass("i_down") || target.hasClass("down")){

            var compnents=target.parents(".survery_component").nextAll(".survery_component");
            if(compnents.length>0)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.down(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //复制操作
        if(target.hasClass("i_copy") || target.hasClass("copy")){

            //获取用户要复制的问题
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            surveydsigner.setCloneQuestion(question);
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //黏贴操作
        if(target.hasClass("i_paste") || target.hasClass("paste")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
            question.pasteQuestionCopy();
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //删除操作
        if(target.hasClass("i_editor_del") || target.hasClass("remove")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
           /* surveydsigner.getCurrentPage().removeQuestion(question);
            e.stopPropagation();
            e.preventDefault();*/
             window.top.Dialog.confirm("确定删除吗?",function(){
            	doDelete(question,"delete",e);
            });
            return;
        }


        //隐藏其它设置面板
        surveydsigner.getCurrentPage().hideAllOtherSetting();
        that.hideQuestion();
        that.showQuestionSetting();
        that.restoreSettingPanel();
        that.refreshQuestionMenu();
        //选中当前问题
        surveydsigner.getCurrentPage().selectQuestionNow(that);


    });
    //设置面板操作(采用事件代理)
    questionset.click(function(e){
        var target=$(e.target);
        //确认
        if(target.hasClass("confirm")){
            var kid="#kid"+that.uuid;
            var cdata = KE.html("kid"+that.uuid);
            var content=questionset.find(kid).text();
            that.setting.content=cdata;
            that.setting.questiontype = that.questiontype;
            that.setting.name = cdata;
            that.setting.options= [{oid : questionset.find("input[name='oid']").val()}];
          	doSaveQuestion(that);
        }
        //取消
        if(target.hasClass("cancel")){

            that.hideQuestionSetting();
            that.showQuestion();
            that.geneartorQuestion();
        }

    });

}

//刷新问题菜单
SueveyIntroduceQuestion.prototype.refreshQuestionMenu=function(){
    var questionmenu=this.getQuestionMenu();
    questionmenu.find('.label').html("自定义文字");
    questionmenu.attr("title","自定义文字");
}

//生成具体的标题
SueveyIntroduceQuestion.prototype.geneartorQuestion=function(){

    var content=this.setting.content;
    var questionview=this.questionview;
    questionview.find(".code").html(content===""?"自定义文字":content);

}
//恢复说明设置面板
SueveyIntroduceQuestion.prototype.restoreSettingPanel=function(){
    this.questionset.find("input[name='qid']").val(this.setting.qid);
    this.questionset.find("input[name='oid']").val(this.setting.options[0].oid);
    var kid="kid"+this.uuid;
   // KE.focus(kid);
   //  alert(333);
   // KE.html(kid, '');
    var content=this.setting.content;
   // alert(content);
    KE.html(kid, content);
 //   KE.insertHtml(kid,content);
  //  alert(KE.html("kid"+this.uuid));
}

//复制说明
SueveyIntroduceQuestion.prototype.getQuestionCopy=function(){
    var questionclone=new  SueveyIntroduceQuestion(new UUID());
    //克隆操作数据
    questionclone.setting= $.extend({},this.setting);
    return   questionclone;
}


//填空题
function BlankfillingQuestion(uuid){

    //填空类型
    this.questiontype="3";
    //问题标识
    this.uuid=uuid;
    this.setting = {title:"",content:"",ismustinput:"1"};
    //问题容器(jq对象)
    this.questionview = $(".survey_template_blankfilling").clone();
    this.questionview.removeClass("survey_template_blankfilling");
    this.questionview.attr("qusid",this.uuid);

    //问题设置容器(jq对象)
    this.questionset = $(".survey_template_blankfillingset").clone();
    this.questionset.removeClass("survey_template_blankfillingset");
    this.questionset.attr("qussetid",this.uuid);
    this.setting.options = {};

    //问题菜单
    this.questionmenu=$("<li class='part node current' id='"+this.uuid+"' title='填空'><span class='i i_matrix'></span><span class='label'>填空</span></li>");
    //绑定事件
    this.bindEvent();

}

//集成question对象
BlankfillingQuestion.prototype = new QuestionMiddle();
//绑定事件
BlankfillingQuestion.prototype.bindEvent=function(){

    var that=this;
    var questionview=this.questionview;
    var questionset=this.questionset;
    //注册鼠标事件
    questionview.mouseover(function () {
        $(this).addClass("hover");
        $(this).find(".survey_buttons").show();
    }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find(".survey_buttons").hide();
        });
    //标题点击进入编辑状态
    questionview.click(function(e){

        var   target=$(e.target);

        //向上移动
        if(target.hasClass("i_up") || target.hasClass("up")){
            var compnents=target.parents(".survery_component").prevAll(".survery_component");
            if(compnents.length>1)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.up(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //向下移动
        if(target.hasClass("i_down") || target.hasClass("down")){

            var compnents=target.parents(".survery_component").nextAll(".survery_component");
            if(compnents.length>0)
            {
                var fromuuid=target.parents(".survery_component").attr("qusid");
                var touuid=$(compnents[0]).attr("qusid");
                var fromQuestion=surveydsigner.getCurrentPage().getQuestionByKey(fromuuid);
                var toQuestion=surveydsigner.getCurrentPage().getQuestionByKey(touuid);
                fromQuestion.down(toQuestion);
            }
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //复制操作
        if(target.hasClass("i_copy") || target.hasClass("copy")){

            //获取用户要复制的问题
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            surveydsigner.setCloneQuestion(question);
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //黏贴操作
        if(target.hasClass("i_paste") || target.hasClass("paste")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
            var uuid=target.parents(".survery_component").attr("qusid");
            var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            //黏贴
            question.pasteQuestionCopy();
            e.stopPropagation();
            e.preventDefault();
            return;
        }

        //删除操作
        if(target.hasClass("i_editor_del") || target.hasClass("remove")){
            //获取当前问题,并将复制的问题黏贴在该问题之下
             var uuid=target.parents(".survery_component").attr("qusid");
	         var question=surveydsigner.getCurrentPage().getQuestionByKey(uuid);
            window.top.Dialog.confirm("确定删除吗?",function(){
            	doDelete(question,"delete",e);
            });
            return;
        }


        //隐藏其它设置面板
        surveydsigner.getCurrentPage().hideAllOtherSetting();
        that.hideQuestion();
        that.showQuestionSetting();
        that.restoreSettingPanel();
        that.refreshQuestionMenu();
        //选中当前问题
        surveydsigner.getCurrentPage().selectQuestionNow(that);


    });
    //设置面板操作(采用事件代理)
    questionset.click(function(e){
        var target=$(e.target);
        //确认
        if(target.hasClass("confirm")){
            //标题
            var content=questionset.find("input[name='subject']").val();
            that.setting.content=content;
            //是否必填
            if(questionset.find("input[name='isrequest']").is(":checked")){
                 that.setting.ismustinput="1";
            }else{
                 that.setting.ismustinput="0";
            }
            that.setting.questiontype = that.questiontype;
            that.setting.name = content;
            that.setting.options = [{oid : questionset.find("input[name='oid']").val()}];
           doSaveQuestion(that);
        }
        //取消
        if(target.hasClass("cancel")){

            that.hideQuestionSetting();
            that.showQuestion();
            that.geneartorQuestion();
        }
    });
}
//生成问题
BlankfillingQuestion.prototype.geneartorQuestion=function(){
     var questionview=this.questionview;
     questionview.find(".subject").html(this.setting.content===''?'填空':this.setting.content);
     var questiontip="";
    if(this.setting.ismustinput==='1'){
        questiontip="必填,"
        questionview.find(".require").show();
    }else{
        questionview.find(".require").hide();
    }
    questiontip=questiontip+"填空";
    questionview.find(".rules").html("("+questiontip+")");
    this.refreshQuestionMenu();
}
//恢复设置面板
BlankfillingQuestion.prototype.restoreSettingPanel=function(){
    var questionset=this.questionset;
    if(this.setting.ismustinput==='1'){
        questionset.find("input[name='isrequest']").prop("checked",true);
    }else{
        questionset.find("input[name='isrequest']").prop("checked",false);
    }
    questionset.find("input[name='subject']").val(this.setting.content);
    questionset.find("input[name='qid']").val(this.setting.qid);
    questionset.find("input[name='oid']").val(this.setting.options[0].oid);
}
//刷新菜单选项
BlankfillingQuestion.prototype.refreshQuestionMenu=function(){
    var titleinfo=this.setting.content===''?'填空':this.setting.content;
    this.questionmenu.attr("title",titleinfo);
    this.questionmenu.find(".label").html(titleinfo);
}

//复制填空题
BlankfillingQuestion.prototype.getQuestionCopy=function(){
    var questionclone=new  BlankfillingQuestion(new UUID());
    //克隆操作数据
    questionclone.setting= $.extend({},this.setting);
    return   questionclone;
}

//删除
function doDelete(that,type,e){
	surveydsigner.addLoadingIcon($(document.body));
	jQuery.ajax({
	   	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=deleteQuestion",
	   	type : "post",
	   	data : {qid : that.setting.qid},
	   	dataType : "json",
	   	success : function(data){
	   		if(!data || data.flag == "0"){
	   			surveydsigner.removeLoadingIcon($(document.body))
	   			window.top.Dialog.alert(type == "delete" ? "删除失败!" : "剪切失败!");
	   			return;
	   		}
	   		
	   		if(!e){
	   			var currentmenu = that.questionmenu;
	   			if (currentmenu.prev().length > 0) {
                    currentmenu.prev().trigger("click");
                } else if (currentmenu.next().length > 0) {
                    currentmenu.next().trigger("click");
                } else {
                    currentmenu.parents(".page").find(".pagenode").trigger("click");
                }
	   		}
	   		
	   		if(type == "cut"){
	   			that.questionview.find(".survey_buttons .copy").trigger("click");
	   		}
	         
	         surveydsigner.getCurrentPage().removeQuestion(that);
	         var questions = surveydsigner.getCurrentPage().getPageQuestions();
	         for(var i = 0; i < questions.length;i++){
	         	if(questions[i].setting && questions[i].setting.showorder){
	         		questions[i].setting.showorder = parseInt(questions[i].questionmenu.index()) + 1
	         	}
	         }
	      },
	      error : function(){
	      	surveydsigner.removeLoadingIcon($(document.body));
	      	window.top.Dialog.alert(type == "delete" ? "删除失败!" : "剪切失败!");
	      },
	      complete : function(){
	      	surveydsigner.removeLoadingIcon($(document.body));
	      	if(e){
	      		e.stopPropagation();
	        	e.preventDefault();
	        }
	      }
	        
	   });
}

//删除页
function doDeletePage(currentmenu){
	surveydsigner.addLoadingIcon($(document.body));
	
	var pagemenu = currentmenu.parent();
	var pageid = pagemenu.attr("page-id");
	
	var votingId = jQuery("input[name='votingid']").val();
	jQuery.ajax({
	   	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=deletePage",
	   	type : "post",
	   	data : {votingId : votingId, pagenum : surveydsigner.getPageByUuid(pageid).getPageCount()},
	   	dataType : "json",
	   	success : function(data){
	   		if(!data || data.flag == "0"){
	   			surveydsigner.removeLoadingIcon($(document.body))
	   			window.top.Dialog.alert("删除失败!");
	   			return;
	   		}
	   		
            if (pagemenu.prev().length > 0) {
                pagemenu.prev().find(".pagenode").trigger("click");
            } else if (pagemenu.next().length > 0) {
                pagemenu.next().find(".pagenode").trigger("click");
            }
            surveydsigner.removePageByUuid(pageid);
            surveydsigner.refreshPageInfos();
	      },
	      error : function(){
	      	surveydsigner.removeLoadingIcon($(document.body));
	      	window.top.Dialog.alert("删除失败!");
	      },
	      complete : function(){
	      	surveydsigner.removeLoadingIcon($(document.body));
	      }
	        
	   });
}


//获取图片标签
function getImageDiv(obj){
	var votingId = jQuery("input[name='votingid']").val();
	return 	"<div class='image_div'>" +
    			"<div class='delete'><span></span></div>" +
     			"<img width='" + obj.wi + "px' height='" + obj.hi + "px' src='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + obj.fid + "'/>" +
     			"<input type='hidden' name='fid' value='" + obj.fid + "'>" +
     			"<input type='hidden' name='aid' value='" + obj.aid + "'>" +
     			"<input type='hidden' class='innerorder' name='iinner' value='" + obj.order + "'>" +
     		"</div>";
}

//注册事件，图片悬浮事件显示关闭按钮事件
function bindImageEvent($li){
        $li.find(".image_div").unbind("hover");
        $li.find(".image_div .delete").unbind("click");
        $li.find(".image_div").hover(function(){
        	jQuery(this).addClass("hover");
        },function(){
        	jQuery(this).removeClass("hover");
        	return;
        }).find(".delete").click(function(){
        	var that = this;
        	window.top.Dialog.confirm("确定删除吗?",function(){
        		var num = jQuery(that).closest(".image_div").length;
        		if(num == 1){
        			jQuery(that).closest("voting_image").removeClass("has_data");
        		}
        		jQuery(that).closest(".image_div").remove();
        	});
        });
}

//获取附件标签
function getAttrDiv(obj){
	var votingId = jQuery("input[name='votingid']").val();
	return "<div class='attr_pdiv'><div class='attr_div'>" + 
				"<a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+obj.fid+"\""+
                " onclick=\"try{openSdoc('"+obj.fid+"\',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\"> "+obj.title+
				"<div class='delete'><span></span></div>" +
                " </a>" +
                "<a class='download' target='_blank' style='margin-left:15px' href='/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + obj.fid + "'>下载(" + Math.floor(obj.size/1024) + "KB)</a>" +
				"<div class=\"clearboth\"></div>" + 
				"<input type='hidden' name='fid' value='" + obj.fid + "'/>" +
				"<input type='hidden' name='aid' value='" + obj.aid + "'/>" +
				"<input type='hidden' name='size' value='" + obj.size + "'/>" +
				"<input type='hidden' name='title' value='" + obj.title + "'/>" +
				"<input type='hidden' class='innerorder' name='iinner' value='" + obj.order + "'/>" +
			"</div></div>";
}

//注册事件，附件悬浮事件显示关闭按钮事件
function bindAttrEvent($li){
	$li.find(".attr_div").unbind("hover");
	$li.find(".attr_div .delete").unbind("click");
	$li.find(".attr_div a").not($li.find(".attr_div a.download")).hover(function(){
		jQuery(this).closest(".attr_div").addClass("hover");
	},function(){
		jQuery(this).closest(".attr_div").removeClass("hover");
	}).closest(".attr_div").find(".delete").click(function(){
		var that = this;
		window.top.Dialog.confirm("确定删除吗?",function(){
			var num = jQuery(that).closest(".attr_pdiv").length;
			if(num == 1){
       			jQuery(that).closest("voting_attr").removeClass("has_data");
       		}
       		jQuery(that).closest(".attr_pdiv").remove();
       	});
	});
}

//获取说明标签
function getRemarkText(obj){
	return "<textarea name='remark' class='textarea'>" + obj.text + "</textarea><input type='hidden' class='innerorder' name='remarkorder' value='" + obj.order + "'/>";
}


//保存问题（新增、修改）
function doSaveQuestion(that){
	var votingId = jQuery("input[name='votingid']").val();
	surveydsigner.addLoadingIcon($(document.body));
	jQuery.ajax({
     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=save&votingId=" + votingId,
     	type : "post",
     	data : that.setting,
     	dataType : "json",
     	success : function(data){
     		if(!data || data.flag == "0"){
     			surveydsigner.removeLoadingIcon($(document.body))
     			window.top.Dialog.alert("保存失败!");
     			return;
     		}
     		
     		if(data.returnData){
     			replaceQuestionIds(that,data.returnData);
     		}
     		
     		
     		if(that.addnew == "1"){
     			that.addnew = "";
     			return;
     		}
     		
   			//隐藏设置面板
		    that.hideQuestionSetting();
		    //显示问题
		    that.showQuestion();
		    //生成问题面板
		    that.geneartorQuestion();
			//questiontype:0:单选问题，1:组合选项(矩阵问题)，2：说明，3：填空
     		if(that.setting.questiontype == 0 || that.setting.questiontype == 1){
			    //刷新问题选项
			     that.refreshQuestionMenu();
     		}
     	},
     	error : function(){
     		surveydsigner.removeLoadingIcon($(document.body));
     		window.top.Dialog.alert("保存失败!");
     	},
     	complete : function(){
     		surveydsigner.removeLoadingIcon($(document.body));
     	}
     });
}

function replaceQuestionIds(that,question){
	that.setting.qid = question.qid;
	if(that.questiontype == 1){  //复选题
		var j = 0;
		if(that.setting.cols && that.setting.cols.length > 0){
			for(var i = 0;i < that.setting.cols.length;i++){
				that.setting.cols[i].oid = question.option[j].oid;
				j++;
			}
		}
		if(that.setting.rows && that.setting.rows.length > 0){
			for(var i = 0;i < that.setting.rows.length;i++){
				that.setting.rows[i].oid = question.option[j].oid;
				j++;
			}
		}
	}else{
		if(question.option && question.option.length > 0){
			for(var i = 0;i < that.setting.options.length;i++){
				that.setting.options[i].oid = question.option[i].oid;
				if(question.option[i].attr && question.option[i].attr.length > 0){
					for(var j = 0;j < that.setting.options[i].attrs.length;j++){
						that.setting.options[i].attrs[j].aid = question.option[i].attr[j].aid;
					}
				}
				if(question.option[i].image && question.option[i].image.length > 0){
					for(var j = 0;j < that.setting.options[i].images.length;j++){
						that.setting.options[i].images[j].aid = question.option[i].image[j].aid;
					}
				}
			}
		}
	}
}

//上下移动(objType:page-页，question-问题;type:up-上,down-下)
function doUpDown(that,toThat,objType,type){
	if(!toThat)return;
	var fromId = "";
	var toId = "";
	if(objType == "page"){
		fromId = that.pageCount;
		var pageId = toThat.attr("page-id");
		toId = surveydsigner.getPageByUuid(pageId).pageCount;
	}else if(objType == "question"){
		fromId = that.setting.qid;
		toId = toThat.setting.qid;
	}else{
		return;
	}
	surveydsigner.addLoadingIcon($(document.body));
	var votingId = jQuery("input[name='votingid']").val();
	jQuery.ajax({
     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=order&objType=" + objType,
     	type : "post",
     	data : {fromId : fromId,toId : toId,votingId : votingId},
     	dataType : "json",
     	success : function(data){
     		if(!data || data.flag == "0"){
     			surveydsigner.removeLoadingIcon($(document.body))
     			window.top.Dialog.alert("移动失败!");
     			return;
     		}
     		if("page" == objType){
     			if("up" == type){ //line-61
     				that.pagemenu.insertBefore(toThat);  
     			}else if("down" == type){ //line-70
     				that.pagemenu.insertAfter(toThat);
     			}
     			surveydsigner.refreshPageInfos();
     		}else if("question" == objType){
     			if("up" == type){ //line-307
				    var toquestionview = toThat.questionview;
				    //移动问题
				    that.questionview.insertBefore(toquestionview);
				    that.questionset.insertAfter(that.questionview);
				    //移动菜单
				    that.questionmenu.insertBefore(toThat.questionmenu);
				    if(that.questiontype==='2'){
				        //初始化html编辑器
				        that.initHtmlEditor();
				    }
				    //滚动条滚动到响应的问题
				    surveydsigner.getCurrentPage().toQuestion(that);
				    that.setting.showorder -= 1; 
				    toThat.setting.showorder = parseInt(toThat.setting.showorder) + 1;
			    }else if("down" == type){//line-312
			    	var toquestionview=toThat.questionview;
				    //移动问题
				    that.questionview.insertAfter(toquestionview.next());
				    that.questionset.insertAfter(that.questionview);
				    //移动菜单
				    that.questionmenu.insertAfter(toThat.questionmenu);
				
				    if(that.questiontype==='2'){
				        //初始化html编辑器
				         that.initHtmlEditor();
				    }
				
				    //滚动条滚动到响应的问题
				    surveydsigner.getCurrentPage().toQuestion(that);
				    that.setting.showorder = parseInt(that.setting.showorder) + 1; 
				    toThat.setting.showorder -= 1;
			    }
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


function doDragPage(fromPage,toPage){
	var votingId = jQuery("input[name='votingid']").val();
	surveydsigner.addLoadingIcon($(document.body));
	jQuery.ajax({
     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=dragPage",
     	type : "post",
     	data : {fromPage : fromPage,toPage : toPage,votingId : votingId},
     	dataType : "json",
     	success : function(data){
     		if(!data || data.flag == "0"){
     			surveydsigner.removeLoadingIcon($(document.body))
     			window.top.Dialog.alert("移动失败!");
     			return;
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

function doDragQuestion(qid,fromOrder,toOrder,fromPage,toPage){
	surveydsigner.addLoadingIcon($(document.body));
	var votingId = jQuery("input[name='votingid']").val();
	jQuery.ajax({
     	url : "/voting/surveydesign/pages/surveyDesignerAjax.jsp?opType=dragQuestion",
     	type : "post",
     	data : {qid : qid,fromOrder : fromOrder,toOrder : toOrder,fromPage : fromPage,toPage : toPage,votingId : votingId},
     	dataType : "json",
     	success : function(data){
     		if(!data || data.flag == "0"){
     			surveydsigner.removeLoadingIcon($(document.body))
     			window.top.Dialog.alert("移动失败!");
     			return;
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

//修改选择题 类型（0-单选、1-多选、2-下拉）
function changeType(thi){
	var _value = thi.value;
	if(_value == 0 || _value == 1){
		jQuery(thi).closest(".part_set").children(".setting").children(".row").show()
			.parent().next().find(".voting_question")
			.children(".image,.attr,.remark,.voting_operator").show()
			.parent().siblings(".voting_image,.voting_attr,.voting_remark").show();
	}else if(_value == 2){
		jQuery(thi).closest(".part_set").children(".setting").children(".row").hide()
			.parent().next().find(".voting_question")
			.children(".image,.attr,.remark,.voting_operator").hide()
			.parent().siblings(".voting_image,.voting_attr,.voting_remark").hide();
	}
}

//选择题 选项、图片、附件、备注 上下移动图片的显示
function showOrHideOperator($li){
	var _length = $li.find(".has_data").length;
	if(_length == 1){
		$li.find(".voting_operator").find("a").hide();
		return;
	}
	$li.find(".has_data").each(function(i){
		if(i == 0){
			jQuery(this).find(".voting_operator").find(".voting_down").parent().show().siblings().hide();
		}else if(i == _length - 1){
			jQuery(this).find(".voting_operator").find(".voting_down").parent().hide().siblings().show();
		}else{
			jQuery(this).find(".voting_operator").find("a").show();
		}
	});
}

Question.prototype.addUpload = function(){
	//判断是否添加附件
    if(typeof(votingconfig) !== undefined  && votingconfig.annex==='on'){
        //初始化编辑器附件上传按钮
        
         var that = this;
	    var process= that.questionset.find(".process").attr("id");
       	var mainid= votingconfig.mainid;
        var subid=  votingconfig.subid;
        var seccateid= votingconfig.seccateid;
       	
        this.questionset.find(".list").find(".uploader").each(function(i){
	        var placehoder=jQuery(this).attr("id");
        	var _spanClass = jQuery(this).parent().attr("class");
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            post_params: {
            	"mainId":mainid,
                "subId":subid,
                "secId":seccateid,
                "logintype":1,
                "comefrom" : "VotingAttachment",
                "returnFileid" : 1,
                "language":'7'

            },
            upload_url: "/voting/surveydesign/pages/fileUpload.jsp",
            file_size_limit :"50MB",
            file_types : _spanClass && _spanClass.indexOf("i_image") > -1 ? "*.jpg;*.jpeg;*.bmp;*.gif;*.png" : "*.*",
            file_types_description : "All Files",
            file_upload_limit : "50",
            file_queue_limit : "0",
            custom_settings : {
                progressTarget : process
            },
            debug: false,

            //button_image_url : "/cowork/images/add_wev8.png",	// Relative to the SWF file
            button_placeholder_id : placehoder,

            button_width: 16,
            button_height: 16,
            //   button_image_url : "/voting/surveydesign/images/app-attach_wev8.png",
            button_text : '<span class="button"></span>',
            button_text_style : '.button { font-size: 12pt;color:#929393;background-color:blue } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 3,
            button_text_left_padding: 0,

            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){
            	var $obj = that.questionset.find("[uploadData='" + placehoder + "']");
            	var _top = $obj.closest(".voting_question").position().top;
            	jQuery("#"+process).css({
            		top : parseInt($obj.position().top) + parseInt(_top) +18 + "px",
            		left : $obj.position().left + "px"
            	});
                if (numFilesSelected > 0) {

                    jQuery("#fsUploadProgressannexuploadSimple").show();
                    this.startUpload();
                }

            },
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            queue_complete_handler : queueComplete,

            upload_success_handler : function (file, server_data) {
                var id=$.trim(server_data);
                /*
                var size=Math.floor(file.size/1024);
                var item="<a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+id+"\""+
                    " onclick=\"try{opendoc1('"+id+"\',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\"> "+file.name+
                    " </a>&nbsp;<a href=\"javascript:void(0)\" unselectable=\"off\" contenteditable=\"false\" linkid=\""+id+"\" "+
                    " onclick=\"try{downloads('"+id+"',this);return false;}catch(e){}\" style=\"cursor:pointer;text-decoration:underline !important;margin-right:8px;\">下载("+size+"K)</a><br />";
               */
               // KE.insertHtml(kindid,item);
               var $li = that.questionset.find("[uploadData='" + placehoder + "']").closest("li");
               
               var _class = that.questionset.find("[uploadData='" + placehoder + "']").attr("class");
               if(_class && _class.indexOf("i_image") != -1){
               	  var imageHi = that.setting.imageWi ? that.setting.imageWi : that.questionset.find(".imageHeight").val();
               	  var imageWi = that.setting.imageWi ? that.setting.imageWi : that.questionset.find(".imageWidth").val();
               	  $li.find(".voting_image").append(getImageDiv({
	               	fid : id,
	               	wi : imageWi,
	               	hi : imageHi,
	               	aid : "",
	               	order : $li.find(".voting_image").index()
	               })).addClass("has_data");
	               bindImageEvent($li);
               }else{
	               $li.find(".voting_attr").append(getAttrDiv({
	               	fid : id,
	               	title : file.name,
	               	aid : "",
	               	size : file.size,
	               	order : $li.find(".voting_attr").index()
	               })).addClass("has_data");
	               bindAttrEvent($li);
               }
               showOrHideOperator($li);
            },

            upload_complete_handler : function(file){
                if(this.getStats().files_queued==0){
                    //清空上传进度条
                    jQuery("#"+process).html("");
                }
            }
        };

        try {
            new SWFUpload(settings);
        } catch(e) {
            // alert(e)
        }
     });
        

    }
}
