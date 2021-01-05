<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String from=Util.null2String(request.getParameter("from"));
    boolean frompc = "pc".equals(Util.null2String(from));
    String isImgSendCutForbit = Util.null2String(request.getParameter("isImgSendCutForbit"));
    String isFileTransForbit = Util.null2String(request.getParameter("isFileTransForbit"));
    String ifForbitFolderTransfer = Util.null2String(request.getParameter("ifForbitFolderTransfer"));
    String ifForbitShake = Util.null2String(request.getParameter("ifForbitShake"));
    String pcOS = Util.null2String(request.getParameter("pcOS"));
    boolean pcIsWinodws = "Windows".equals(pcOS);
    boolean pcIsOSX = "OSX".equals(pcOS);
    boolean pcIsLinux = "Linux".equals(pcOS);
    
    String attachmentMaxsize="50";
    String userid=""+user.getUID();
    int timeSag=0;
    String targetFlag="";
%>
<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
 
<style>
*{
	font-size: 12px;
}

.eAchatdiv .imtitle{
	padding: 8px;
}

.eAchatdiv .imtitle .imtitleName {
    color: #5cb5d8;
}

.eAchatdiv .chatIMtop {
    position: absolute;
    left: 0;
    right: 0;
    height: 32px;
    border: 0;
    border-bottom: 1px solid #e3e6f0;
    border-top: 0;
    z-index: 1000;
    background: #fff;
}

.eAchatdiv .chattop .chattab {
    cursor: pointer;
    margin-left: 12px;
    height: 32px;
    line-height: 40px;
    font-size: 14px;
    margin-right: 12px;
}

.eAchatdiv .chattop .chattab .toDoListCount{
    font-size: 14px;
}

.eAchatdiv .chattop .currentchattab {
    border-bottom: 2px;
    border-bottom-color: #5bb3d7;
    border-bottom-style: solid;
}

.finishListTop {
    height: 55px;
    line-height: 55px;
    border-bottom: 1px solid #e3e6f0;
    min-width: 600px;
}
.left{
	float:left;
}
.right{
	float:right;
}
.hand{
	cursor: pointer;
}
.toDoList {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    top: 37px;
    z-index: 10;
    background-color: #fff;
}

.finishList {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    top: 37px;
    z-index: 10;
    background-color: #fff;
}

.finishlistResult{
    position: absolute;
    top: 61px;
    bottom: 0;
    left: 0;
    right: 0;
}

.searchItem{
	margin-left: 15px;
}

.resultItem{
	padding: 10px;
	line-height: 20px;
	padding-left: 15px;
    padding-right: 20px;
    margin-bottom: 15px;
}

.resultItem .title{

}

.titlespan{
	display: block;
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
	max-width: 85%;
    float: left;
}

.resultItem .date{
	color: #999999;
	margin-top: 5px;
}

.resultItem .toDo{
	color: #0066FF;
	cursor: pointer;
}

.resultItem .unDo{
	color: #000000;
	cursor: auto;
}

.line{
	border-bottom: 1px solid #e3e6f0;
	margin-top: 10px;
    margin-bottom: 10px;
}

.width100{
	width: 100%;
}

.warning{
	width: 10px;
	height: 10px;
	background-image: url("/fullsearch/img/warning_wev8.png");
	float: left;
	margin-left: 5px;
}
.loading123{
    position: absolute;
    top: 0px;
    bottom: 0px;
    left: 0px;
    right: 0px;
    background: url('/social/images/loading_large_wev8.gif') no-repeat center 200px;
    display: block;
    z-index: 10000;
}
.comefrom-e{
	border: 1px solid #3376ff;
    padding: 0 3px;
    color: #3376ff;
    margin-left: 20px;
    -moz-border-radius: 10px 10px 10px 10px;
    -webkit-border-radius: 10px 10px 10px 10px;
    border-radius: 10px 10px 10px 10px;
}
.comefrom-ws{
	border: 1px solid #37b17c;
    padding: 0 3px;
    color: #37b17c;
    margin-left: 20px;
    -moz-border-radius: 10px 10px 10px 10px;
    -webkit-border-radius: 10px 10px 10px 10px;
    border-radius: 10px 10px 10px 10px;
}
</style>


 </HEAD>
<BODY style="overflow-y: hidden">
	<div id="eAchatdiv" class="eAchatdiv">
		<div class="chatleft">
			<!-- 顶部 -->
			
			<div class="chattop chatIMtop">
				<div class="chattabdiv " style="float:left;" onclick="changeTopTab(this,'toDoList')" _target="toDoList">
					<div class="chattab currentchattab"><%=SystemEnv.getHtmlLabelName(16349, user.getLanguage()) %>(<span id="toDoListCount" class="toDoListCount">0</span>)</div><!-- 待处理 -->
				</div>
				<div class="chattabdiv" style="float:left;" onclick="changeTopTab(this,'finishList');" _target="finishList">
					<div class="chattab "><%=SystemEnv.getHtmlLabelName(1961, user.getLanguage()) %>(<span id="finishListCount" class="toDoListCount">0</span>)</div><!-- 已完成 -->
				</div>
				<div class="clear"></div>
			</div>
			
			<!-- 待处理列表 -->
			<div class="chatListbox toDoList chatRecord scroll-pane" id="toDoList" >
			  
			</div>
			
			<!-- 已完成列表 -->
			<div class="chatListbox finishList" id="finishList" style="display:none;">
			   <div class="finishListTop">
					<div class="left" style="margin-left:15px;">
						<div class="bSearchdiv">
				            <div class="searchItem left">
				            	<input type="text" name="keyword" id="keyword" class="keyword" placeholder="<%=SystemEnv.getHtmlLabelName(345, user.getLanguage()) %>" onkeydown="doSearch(this,event)">
				            </div>
				            <div class="searchItem left">
				            	<span style="padding-right: 5px;"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></span>
					            <select name="timeSag" id="timeSag" onchange="changeDate(this,'meetingStartdate');" style="width:100px;">
									<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
									<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
									<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
									<option value="7" <%=timeSag==7?"selected":"" %>><%=SystemEnv.getHtmlLabelName(27347,user.getLanguage())%></option><!-- 上个月 -->
								</select>
				            </div>
				            <div class="searchItem left">
				            	<span style="padding-right: 5px;"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span>
					            <select name="targetFlag" id="targetFlag" style="width:100px;">
									<option value="" <%=targetFlag.equals("")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="0" <%=targetFlag.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130382,user.getLanguage())%></option>
									<option value="1" <%=targetFlag.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130381,user.getLanguage())%></option>
									<option value="2" <%=targetFlag.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130375,user.getLanguage())%></option>
									<option value="3" <%=targetFlag.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130374,user.getLanguage())%></option>
									<option value="4" <%=targetFlag.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130373,user.getLanguage())%></option>
									<option value="5" <%=targetFlag.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(82832,user.getLanguage())%></option>
									<option value="6" <%=targetFlag.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
									<option value="7" <%=targetFlag.equals("7")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></option>
									<option value="8" <%=targetFlag.equals("8")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%></option>
								</select>
				            </div>
				            <div class="searchItem left">
				            	<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="finishList()"/>
				            </div>
				        </div>
				    </div>
					<div class="clear"></div>
				</div>
				<div class="finishlistResult" id="finishlistResult">
					
				</div>
			</div>
				 
		</div>
		<div id="loading123" class="loading123" style="display: none"></div>
	</div>
    </BODY>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/social/im/js/IMUtil_wev8.js"></script>
<script type="text/javascript">
var userId="<%=userid%>";
var currentItem;
var tab=1;
function changeTopTab(obj,func){
	$('.chatListbox').hide();
	$('#'+$(obj).attr("_target")).show();
	$('.currentchattab').removeClass("currentchattab");
	$(obj).find(".chattab").addClass("currentchattab");
	if(func=='toDoList'){
		toDoList();
		tab=1;
	}else{
		finishList();
		tab=2;
	}
}

function toDoList(){
	$('#loading123').show();
	//调用共享接口
	jQuery.ajax({
		type: "post",
	    url: "/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getTodoList&random="+new Date().getTime(),
	    data:{},
	    dataType: "json",  
	    success:function (data) {
	    	$('#loading123').hide();
	    	$('#toDoList').html("");
	    	$('#toDoListCount').html(data.count);
	    	if(data.list&&data.list.length>0){
		    	var str="";
		    	$.each(data.list,function(j,item){
		    		str+='<div class="resultItem">'+
							'<div class="left width100 title">'+item.ask+'</div>'+
							'<div class="left width100 date"><a href="javaScript:void(0);" onclick="openHrmCard(event,'+item.createrId+');">'+item.createrName+'</a>'+'&nbsp;&nbsp;'+item.createdate+'&nbsp;&nbsp;'+item.createtime+(item.commitTag=="1"?'<span class="comefrom-e">小e</span>':item.commitTag=="2"?'<span class="comefrom-ws">微搜</span>':'')+'</div>';
					if(item.checkOutId=="0"){
						str+='<div class="right toDo" itemId="'+item.id+'" onclick="checkFAQItem(this)"><%=SystemEnv.getHtmlLabelName(18985,user.getLanguage())%></div>';
					}else if(item.checkOutId==userId){
						str+='<div class="right toDo" itemId="'+item.id+'" onclick="checkFAQItem(this)"><%=SystemEnv.getHtmlLabelName(130383,user.getLanguage())%></div>';
					}else{
						str+='<div class="right unDo" itemId="'+item.id+'" onclick="checkFAQItem(this)">'+item.checkOutName+'<%=SystemEnv.getHtmlLabelName(125473,user.getLanguage())%></div>';
					}
							
						str+='</div><div class="left width100 line"></div>';
		    	});
		    	$('#toDoList').html(str);
	    	
	    	}else{
	    		$('#toDoList').html("<div style='text-align: center;margin-top: 20px;'><%=SystemEnv.getHtmlLabelName(130384,user.getLanguage())%></div>");
	    	}
	    	IMUtil.imPerfectScrollbar($('#toDoList'));
	    }
	});
}

function showTargetFlag(targetFlag){
	if(targetFlag=="0"){
		return "<%=SystemEnv.getHtmlLabelName(130382,user.getLanguage())%>";
	}else if(targetFlag=="1"){
		return "<%=SystemEnv.getHtmlLabelName(130381,user.getLanguage())%>";
	}else if(targetFlag=="2"){
		return "<%=SystemEnv.getHtmlLabelName(130375,user.getLanguage())%>";
	}else if(targetFlag=="3"){
		return "<%=SystemEnv.getHtmlLabelName(130374,user.getLanguage())%>";
	}else if(targetFlag=="4"){
		return "<%=SystemEnv.getHtmlLabelName(130373,user.getLanguage())%>";
	}else if(targetFlag=="5"){
		return "<%=SystemEnv.getHtmlLabelName(82832,user.getLanguage())%>";
	}else if(targetFlag=="6"){
		return "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";
	}else if(targetFlag=="7"){
		return "<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>";
	}else if(targetFlag=="8"){
		return "<%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%>";
	}
	return "";
	
}


function finishList(){
	//保存查询条件
	$('#finishlistResult').attr("keyword",$('#keyword').val());
	$('#finishlistResult').attr("timeSag",$('#timeSag').val());
	$('#finishlistResult').attr("targetFlag",$('#targetFlag').val());
	$('#loading123').show();
	jQuery.ajax({
		type: "post",
	    url: "/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getFinishList&random="+new Date().getTime(),
	    data:{"keyword":$('#keyword').val(),"timeSag":$('#timeSag').val(),"targetFlag":$('#targetFlag').val()},
	    dataType: "json",  
	    success:function (data) {
	    	$('#loading123').hide();
	    	$('#finishlistResult').html("");
	    	$('#finishListCount').html(data.totailcount);
	    	
	    	if(data.list&&data.list.length>0){
		    	var str="";
		    	$.each(data.list,function(j,item){
		    		str+='<div class="resultItem">'+
							'<div class="left width100 title hand finishItemTitle" itemId="'+item.id+'" onclick="showFAQItem(this)">'+item.ask+'</div>'+
							'<div class="left width100 date"><a href="javaScript:void(0);" onclick="openHrmCard(event,'+item.createrId+');">'+item.createrName+'</a>'+'&nbsp;&nbsp;'+item.createdate+'&nbsp;&nbsp;'+item.createtime+(item.commitTag=="1"?'<span class="comefrom-e">小e</span>':item.commitTag=="2"?'<span class="comefrom-ws"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage())%></span>':'')+'</div>'+
							'<div class="left width100 date"><%=SystemEnv.getHtmlLabelName(130385,user.getLanguage())%>'+'&nbsp;&nbsp;'+item.processdate+'&nbsp;&nbsp;'+item.processtime+'</div>'+
							'<div class="right targetFlag">'+showTargetFlag(item.targetFlag)+'</div>'+
						  '</div>'+
						  '<div class="left width100 line"></div>';
		    	});
		    	$('#finishlistResult').attr("hasnext",data.hasnext);
		    	$('#finishlistResult').attr("pageno",data.pageno);
						
		    	$('#finishlistResult').html(str);
	    	}else{
	    		$('#finishlistResult').html("<div style='text-align: center;margin-top: 20px;'><%=SystemEnv.getHtmlLabelName(127543,user.getLanguage())%></div>");
	    	}
	    	IMUtil.imPerfectScrollbar($('#finishlistResult'));
	    }
	});
}

function openHrmCard(e,id){
    pointerXY(e);   
    openhrm(id);
}
   
function doSearch(obj,evt){
	if((evt || window.event).keyCode == 13){
		var keywordInput = $(obj);
		var keyword = keywordInput.val();
		//关键字只包含空格符号
		if(keyword != '' && $.trim(keyword) == ''){
			keywordInput.val('');
			return;
		}
		finishList();
	}
}

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function undoCheckOut(){
	undoCheckOut();
	diag_vote.close();
}

//刷新列表
function closeDlgARfsh(targetFlag){
	DlgARfsh(targetFlag);
	diag_vote.close();
}
//刷新不关闭
function DlgARfsh(targetFlag){
	if(tab=="1"){
		if(currentItem){//先快速清除下.然后重新获取下有没有新数据
			$(currentItem).parent().next().remove();
			$(currentItem).parent().remove();
			$('#toDoListCount').html(parseInt($('#toDoListCount').text())-1);
		}
		toDoList();
	}else{
		if(tab=="2"){
			if(targetFlag){
				$(currentItem).parent().find(".targetFlag").html(showTargetFlag(targetFlag));
			}
			if(targetFlag==-1){
				$(currentItem).parent().next().remove();
				$(currentItem).parent().remove();
			}
		}
	}
}

function undoCheckOut(){
	$(currentItem).html("<%=SystemEnv.getHtmlLabelName(18985,user.getLanguage())%>");
	diag_vote.close();
	var faqId=$(currentItem).attr("itemId");
	jQuery.ajax({
		type: "post",
	    url: "/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=unDoCheckOut&random="+new Date().getTime(),
	    data:{"faqId":faqId},
	    dataType: "json",  
	    success:function (data) {}
	});	
}

function showFAQItem(obj){
	currentItem=obj;
	var faqId=$(obj).attr("itemId");
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 700;
	diag_vote.Height = 490;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(22045,user.getLanguage())%>";
	diag_vote.URL = "/fullsearch/EAssistant/ReMessage.jsp?faqId="+faqId+"&askid="+faqId;
	if(<%=frompc%>){
		parent.commonUtil.imedialog(diag_vote);
	}else{
		diag_vote.show();
	}
}


function checkFAQItem(obj){
	if(!$(obj).hasClass("unDo")){
		$('#loading123').show();
		var faqId=$(obj).attr("itemId");
		jQuery.ajax({
			type: "post",
		    url: "/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=checkOut&random="+new Date().getTime(),
		    data:{"faqId":faqId},
		    dataType: "json",  
		    success:function (data) {
		    	 $('#loading123').hide();
		    	 if(data.checkResut){
		    	 	 showFAQItem(obj);
		    	 	 $(obj).html("<%=SystemEnv.getHtmlLabelName(130383,user.getLanguage())%>");
		    	 }else{
		    	 	 if(data.needHide){
			    	 	 Dialog.alert(data.msg);
		    	 	 	 $(obj).parent().next().remove();
						 $(obj).parent().remove();
						 $('#toDoListCount').html(parseInt($('#toDoListCount').text())-1);
		    	 	 }else{
			    	 	 $(obj).addClass("unDo");
			    	 	 $(obj).html(data.msg);
		    	 	 }
		    	 }
		    }
		});	
	}

}

jQuery(document).ready(function(){
	toDoList();
	IMUtil.bindLoadMoreHandler($('#finishlistResult'),loadMoreFinishList);
});

var loadMore=false;
function loadMoreFinishList(){
	if($('#finishlistResult').attr("hasnext")=="true"){
		if(loadMore){
			//alert("正在加载中.不请求");
		}else{
			$('#loading123').show();
			var keyword=$('#finishlistResult').attr("keyword");
			var timeSag=$('#finishlistResult').attr("timeSag");
			var targetFlag=$('#finishlistResult').attr("targetFlag");
			var pageno=parseInt($('#finishlistResult').attr("pageno"))+1;
			loadMore=true;
			jQuery.ajax({
				type: "post",
			    url: "/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getFinishList&random="+new Date().getTime(),
			    data:{"keyword":keyword,"timeSag":timeSag,"targetFlag":targetFlag,"pageno":pageno},
			    dataType: "json",  
			    success:function (data) {
			    	$('#loading123').hide();
			    	var str="";
			    	$.each(data.list,function(j,item){
			    		str+='<div class="resultItem">'+
								'<div class="left width100 title hand finishItemTitle" itemId="'+item.id+'" onclick="showFAQItem(this)">'+item.ask+'</div>'+
								'<div class="left width100 date"><a href="javaScript:openhrm('+item.createrId+');" onclick="pointerXY(event);">'+item.createrName+'</a>'+'&nbsp;&nbsp;'+item.createdate+'&nbsp;&nbsp;'+item.createtime+(item.commitTag=="1"?'<span class="comefrom-e">小e</span>':item.commitTag=="2"?'<span class="comefrom-ws"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage())%></span>':'')+'</div>'+
								'<div class="left width100 date"><%=SystemEnv.getHtmlLabelName(130385,user.getLanguage())%>'+'&nbsp;&nbsp;'+item.processdate+'&nbsp;&nbsp;'+item.processtime+'</div>'+
								'<div class="right targetFlag">'+showTargetFlag(item.targetFlag)+'</div>'+
							  '</div>'+
							  '<div class="left width100 line"></div>';
			    	});
			    	$('#finishlistResult').attr("hasnext",data.hasnext);
			    	$('#finishlistResult').attr("pageno",data.pageno);
							
			    	$('#finishlistResult').append(str);
			    	IMUtil.imPerfectScrollbar($('#finishlistResult'));
			    	loadMore=false;
			    }
			});	
		}
	}else{
		//alert("不加载");
	}
}

</script>