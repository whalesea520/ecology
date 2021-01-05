
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/doc/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" src="/ueditor/custbtn/appwfPhraseBtn_wev8.js"></script>
	
	<style>
		.btn_font{
			text-align:center;
			line-height:23px;
			font-size:13px;
		    cursor: pointer;
		}
		.mark{
			float:left;
			height:23px;
			BORDER: 1px solid #ccc;
			border-radius:10px;
		}
		.send_btn{
			float:left;
			BORDER: 1px solid #18A15F;
			margin-left:15px;
			height:27px;
			width:72px;
			border-radius:10px;
			background-color:#18A15F;
			color:#FFFFFF;
		}
		.content{
			width:95%;
			margin-left:2%;
			margin-right:2%;
			margin-top:10px;
			resize:none;
		}
		.quickmenu{
			position: relative;
			background:#FFF;
			border:1px solid #E6E6E6;
			height:190px;
			width:235px;
			z-index: 1000;
			position: absolute;
			bottom:40px;
			left:370px;
			
		}
		.menuopt{
			padding-top:5px;
			padding-bottom:5px;
			padding-left:10px;
			background:#FFF;
			font-size:12px;
			cursor: pointer;
			color:#333;
			text-overflow: ellipsis; 
			white-space: nowrap; 
			overflow: hidden;
			width:225px;
		}
		.menuopt:hover{
			background:#F5FAFB;
		}
		.dtl_font{
			font-size:12px;
			color:#999999;
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
		#edui1_toolbarbox{
			display:none;
		}
		#edui1_bottombar{
			display:none;
		}
		
		.contentBorder{
			border:1px solid rgba(215, 215, 215, 1); 
		}
		
		.recordCacheBtn{
			border: 1px solid #9c9c9c; 
			padding: 2px 5px;
			line-height: 23px;
			border-radius: 7px;
			float:left;
			margin-left: 10px;
			cursor: pointer;
		}
	</style>
</HEAD>
<%!

%>
<%
int userId=user.getUID();
rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
if(!rs.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String method = Util.null2String(request.getParameter("method"));
String askid = Util.null2String(request.getParameter("askid"));

int inputing=0;
boolean isview=false;
String answer="";

if(method.equals("getQuickAnswer")){
	out.clearBuffer();
	String ret="";
	rs.execute("select * from sysPhrase where hrmid="+userId+" order by id");
	int k=0;
	while(rs.next()){
		ret+="<p class='menuopt' onclick='selQuickAnswer("+k+")' title='"+rs.getString("phrasedesc").trim()+"'>"+rs.getString("phraseshort").trim()+"</p>";
		ret+="<input type='hidden' id='c_"+k+"' value='"+rs.getString("phrasedesc")+"'></input>";
		k++;
	}
	out.write(ret); 
	return;
}

if(askid.isEmpty()){
	return;
}
String ask="";
String creater="";
String createdate="";
String createtime="";
String processid="";
String processdate="";
String processtime="";
String sRemark="";
String changeAsk="";
int targetFlag=0;
int faqTargetId=0;
rs.execute("select * from Fullsearch_E_Faq where id="+askid);
if(rs.next()){
	ask=rs.getString("ask");
	creater=rs.getString("createrid");
	createdate=rs.getString("createdate");
	createtime=rs.getString("createtime");
	processid=rs.getString("processid");
	processdate=rs.getString("processdate");
	processtime=rs.getString("processtime");
	targetFlag=rs.getInt("targetFlag");
	sRemark=rs.getString("sRemark");
	faqTargetId=Util.getIntValue(rs.getString("faqTargetId"),0);
	changeAsk=rs.getString("changeAsk");
	if(!"0".equals(rs.getString("status"))){
		isview=true;
		answer=rs.getString("answer");
	}else if("0".equals(rs.getString("status"))&&!(rs.getString("checkoutid").equals(userId+"")||rs.getString("checkoutid").equals("0")||rs.getString("checkoutid").equals(""))){
		inputing=1;
		out.println("<SCRIPT LANGUAGE='JavaScript'>window.top.Dialog.alert('"+SystemEnv.getHtmlLabelName(130376, user.getLanguage())+"!');</script>");
	}
}

if(faqTargetId>0){
	rs.execute("select faqDesc from fullSearch_FaqDetail where id="+faqTargetId);
	if(rs.next()){
		answer=SystemEnv.getHtmlLabelName(128697, user.getLanguage())+"：<a href=javaScript:openQuestion("+faqTargetId+")>"+rs.getString("faqDesc")+"</a>" ;
	}
}
if(!"".equals(changeAsk)){
	answer=SystemEnv.getHtmlLabelName(131431, user.getLanguage())+"："+changeAsk ;
	faqTargetId=-1;
}
%>
<BODY>
<div style="width:100%;height:105px;BORDER-bottom: 1px solid #d0d0d0">
<div id="loading123" class="loading123" style="display: none"></div>
	<table style="width:100%">
		<tr style="height:60px;width:100%"  valign="top">
			<td rowspan=2 style="width:45px">
				<img src='\fullsearch\img\ask.png' style="margin-left:5px;margin-top:10px">
			</td>
			<td style="padding-top:5px;">
				<div style="font-size:13px;color:#333333;height:35px"><%=ask %></div>
				<div class="dtl_font"><%=ResourceComInfo.getMulResourcename2(creater)+" "+createdate+" "+createtime %></div>
			</td>
		</tr>
		<tr>
			<td>
			<div style="float:right;margin-right: 20px;">
				<div id="flag-1" class="btn_font mark" style="margin-left:15px;width:60px;" onclick="confirmChangeFlag()">&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %></div>
				<%if(targetFlag!=5&&targetFlag!=6&&targetFlag!=7&&targetFlag!=8){%>
				<div id="flag5" class="btn_font mark" style="margin-left:15px;width:83px;display:none" onclick="submitNew()">&nbsp;<%=SystemEnv.getHtmlLabelName(130371, user.getLanguage()) %></div>
				<div id="flag1" class="btn_font mark" style="margin-left:15px;width:83px;display:none" onclick="createFAQ()">&nbsp;<%=SystemEnv.getHtmlLabelName(130370, user.getLanguage()) %></div>
				<div id="flag6" style="float:left;margin-left:15px;width:100px;">
					<select id="markflag" onchange="changeFlag()">
						<option value="0" <%=targetFlag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130382, user.getLanguage()) %></option>
						<option value="1" <%=targetFlag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130381, user.getLanguage()) %></option>
						<option value="4" <%=targetFlag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130373, user.getLanguage()) %></option>
						<option value="2" <%=targetFlag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130375, user.getLanguage()) %></option>
						<option value="3" <%=targetFlag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(130374, user.getLanguage()) %></option>
					</select>
				</div>
				<div id="flag_eidt" class="btn_font mark" style="margin-left:15px;width:60px;display: none;" onclick="editText()">&nbsp;<%=SystemEnv.getHtmlLabelName(103, user.getLanguage()) %></div>
				<%}else{%>
					<div id="flag_eidt" class="btn_font mark" style="margin-left:15px;width:60px;" onclick="editText()" targetFlag="<%=targetFlag %>">&nbsp;<%=SystemEnv.getHtmlLabelName(103, user.getLanguage()) %></div>
				<%} %>
				<div id="flag_save" class="btn_font mark" style="margin-left:15px;width:60px;display: none;" onclick="saveText()">&nbsp;<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %></div>
				
				
			</div>
			</td>
		</tr>
	</table>
</div>
<div style="width:100%;height:40px;">
<div style="float:left;margin-left:2%;margin-top:10px"><img src='\fullsearch\img\answer.png'></div><div id="answer_dtl" class="dtl_font" style="float:left;margin-top:10px;margin-left:5px;">
	<%=ResourceComInfo.getMulResourcename2(processid)+" "+processdate+" "+processtime %>
</div>
</div>
<div id="contentDiv" style="width:100%;height:190px;overflow-y:auto ">
	<textarea class="content" rows="9" id="content" name="content" value=""></textarea>
	<textarea class="content" rows="9" id="instructions_area" name="instructions_area" value="" style="display: none"></textarea>
	<div class="content" style="font-size:13px;color:#333333" id="content_div" name="content_div"><%=answer %></div>
	<div class="content" style="font-size:13px;color:#333333;display: none" id="content_cache_div" name="content_cache_div">
		<div id="content_cache_text_div" style="width: 100%;margin: 10px 0"><div style="width:60px;float:left">text:</div><div><input class="content_cache" type="text" id="content_cache_text" style="width:260px"/></div></div>
		<div id="content_cache_content_div" style="width: 100%;margin: 10px 0"><div style="width:60px;float:left">content:</div><div><input class="content_cache" type="text" id="content_cache_content" style="width:260px"/></div></div>
		<div id="content_cache_type_div" style="width: 100%;margin: 10px 0"><div style="width:60px;float:left">status:</div>
			<div>
			<select class="content_cache" id="content_cache_type" onchange="changeContentCache()">
				<option value="dealed"><%=SystemEnv.getHtmlLabelName(82832,user.getLanguage())%></option>
				<option value="show"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
				<option value="esearch"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></option>
				<option value="esearch_RSC"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
				<option value="esearch_CRM"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
				<option value="esearch_DOC"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
				<option value="esearch_WF"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
				<option value="esearch_FAQ:-1"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>-FAQ</option>
				<option value="Instructions"><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%></option>
			</select>
			</div>
		</div>
		<div id="content_cache_btn_div" style="width: 100%;margin: 20px 0">
			<div>
				<div class="recordCacheBtn" onclick="saveText(this)" _defaultvalue='请询问与协同办公相关的问题'><%="OA相关" %></div>
				<div class="recordCacheBtn" onclick="saveText(this)" _defaultvalue='暂不支持此功能'><%="暂不支持" %></div>
				<div class="recordCacheBtn" onclick="saveText(this)" _defaultvalue='我好像不太明白'><%="不太明白" %></div>
			</div>
		</div>
	</div>
</div>
<div id="btn_div" style="width:100%;height:40px;position: relative;">
<div style="float:left;margin-left: 20px;">
	<div class="btn_font" style="border: 1px solid #9c9c9c; padding: 2px 5px;line-height: 23px;border-radius: 7px;float:left" onclick="changeAsk()"><%=SystemEnv.getHtmlLabelName(131431, user.getLanguage()) %></div>
	<div class="btn_font" style="border: 1px solid #9c9c9c; padding: 2px 5px;line-height: 23px;border-radius: 7px;float:left;margin-left: 10px;" onclick="editText()"><%=SystemEnv.getHtmlLabelName(264, user.getLanguage()) %></div>
</div>
<div style="float:right;margin-right: 20px;">
	<div class="btn_font" style="float:left;margin-left:15px;width:150px;line-height:27px !important" onclick="findQ()"><%=SystemEnv.getHtmlLabelName(130369, user.getLanguage()) %></div>
	
	<div class="btn_font" style="float:left;margin-left:15px;width:50px;line-height:27px !important" onclick="quickRe()"><%=SystemEnv.getHtmlLabelName(33861, user.getLanguage()) %></div>
	<div id="quickmenu" class="quickmenu" style="display:none;">
		<div style="height:35px;width:235px;background:#f2f2f2">
			<div style="float:right;margin-top:5px;margin-right:5px;cursor: pointer;" onclick="cusSet()">
				<img src='\images\homepage\style\setting_wev8.png'></img>
			</div>
		</div>
		<div id="quickmenuopt" style="height:155px"></div>
	</div>
	<div class="btn_font send_btn" style="margin-left:15px;" onclick="sendMsg()"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage()) %> >></div>
	</div>
</div>
<div id="remarkDiv" style="height:35px;overflow-y:auto;margin: 10px 15px 10px 10px;">
	<div style="line-height: 35px">
		<div style="float: left;left: 15px;margin-left: 5px; margin-right: 10px;"><%=SystemEnv.getHtmlLabelName(454, user.getLanguage()) %>&nbsp;:</div>
		<div id="remarkContent" style="height: 35px;outline:0;margin-left: 50px" contentEditable="true" oninput="hasChangeRemark()"><%=sRemark %></div>
	</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value='<%=isview?SystemEnv.getHtmlLabelName(309, user.getLanguage()):SystemEnv.getHtmlLabelName(130368, user.getLanguage()) %>' id="btn_close" undocheck='<%=isview?"n":"y" %>' class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<SCRIPT LANGUAGE="JavaScript">
var inQuick=0;
var hasChange=false;
jQuery(document).ready(function(){
	//有其他人正在编辑隐藏底部按钮
	if(<%=inputing%>==1){
		$("#btn_div").css("display","none");
	}
	//查看时隐藏文本框和底部按钮
	<%if(isview){ %>
		$("#content").css("display","none");
		$("#btn_div").css("display","none");
		$("#flag1").css("display","");
		<%if(faqTargetId==0){%>
			$("#flag5").css("display","");
		<%}%>
		$('#contentDiv').height(230);
	<%}else{ %>
		$("#content_div").css("display","none");
		initFckEdit();
	<%}%>
	
	$("body").click(function(e){
		if(inQuick==0){
			$("#quickmenu").css("display","none");	
		}
		inQuick=0;
	});
	$("#quickmenu").click(function(e){
		inQuick=1;
	});
	getQuickAnswer();
	
	$('#remarkContent').focus(function(){
		$('#remarkDiv').addClass("contentBorder");
	}).blur(function(){
		var description=$(this).text();
		description = description.replace(/(\n)/g, "");  
		description = description.replace(/(\t)/g, "");  
		description = description.replace(/(\r)/g, "");  
		description = description.replace(/<\/?[^>]*>/g, "");  
		description = description.replace(/\s*/g, ""); 
		$('#remarkDiv').removeClass("contentBorder");
		if(hasChange){
			$(this).text(description);
			hasChange=false;
			$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",
				{type:'saveRemark',faqId:<%=askid%>,remark:description},
				function(data){
					
			});
		}
	});
});

function hasChangeRemark(){
	hasChange=true;
}
var diag;
function closeDialog(){
	diag.close();
}

function confirmChangeFlag(){
	$("#loading123").show();
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage()) %>",
		function(){
			changeFlag(-1);
			$("#loading123").hide();
		},
		function(){
			$("#loading123").hide();}
		);
}

function changeFlag(flag){
	if(flag!=-1){
		flag=$("#markflag").val();
	}
	var id="<%=askid%>";
	$("#loading123").show();
	$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{type:'changeTargetFlag',faqId:id,targetFlag:flag},function(data){
		if(data.result=="success"){
			$("#loading123").hide();
			if(flag==4||flag==-1){
				closeDlgARfsh(flag);
			}else{
				DlgARfsh(flag);
				if(flag==2){
				   if($("#answer_dtl").html()!=""){
					   var d=new Date();
					   var date=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+" "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
					   $("#answer_dtl").html("<%=ResourceComInfo.getLastname(userId+"")%> "+date);
					   showContent('','');
				   }	
				}
			}
		}
	});
}

function createFAQ(){
	//新建问题库
	var url="/fullsearch/EditFaqLibrary.jsp?fromFaqId=<%=askid%>";
	if(window.top.Dialog){
		diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 980;
	diag.Height = 600;
	diag.Modal = true;
	diag.Title = "";
	diag.URL = url;
	diag.show();
}

function findQ(){
	var url = "/systeminfo/BrowserMain.jsp?url=/fullsearch/EAssistant/QuestionBrowserTab.jsp";
	if(window.top.Dialog){
		diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 590;
	diag.Height = 570;
	diag.Modal = true;
	diag.Title = "";
	diag.callBackFun=cbFun;
	diag.URL = url;
	diag.show();
}

function cbFun(data,flag){
	closeDialog();
	var id=data.id;
	var name=data.name;
	ue.setContent("<%=SystemEnv.getHtmlLabelName(128697, user.getLanguage())%>：<a href=javaScript:openQuestion("+id+")>"+name+"</a>");
	if(flag==1){
		if(newSub==1){//提交新回复
			newSub=2;
		}
		otherAsk(id);
	}
	sendMsg(id);
	
}

function showContent(datas,targetId){
	$('#contentDiv').height(230);
	$("#content_div").html(datas);
	$("#content").css("display","none");
	$("#content_div").css("display","");
	$("#btn_div").css("display","none");
	$("#flag1").css("display","");
	if(targetId>0){
		$("#flag5").css("display","none");
	}else{
		$("#flag5").css("display","");
	}
	$("#btn_close").attr("undocheck","n");
	$("#btn_close").val("<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>");
}

function quickRe(){
	showQuick();
}

function sendMsg(targetId){
	$("#loading123").show();	
	$("#ueditor_0").contents().find(".view").find("*").css("font-size","");
	var answer = ue.getContent();
	var id="<%=askid%>";
	var d=new Date();
	var date=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+" "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
	if(answer!=""){
	
		$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{type:'sendEMsg',faqId:id,answer:answer,faqTargetId:targetId},function(data){
			if(data.result=="success"){
				$("#loading123").hide();
				$("#answer_dtl").html("<%=ResourceComInfo.getLastname(userId+"")%> "+date);
					if(newSub==2){
						DlgARfsh(1);		
					}else{
						DlgARfsh();		
					}
			}
		});
		showContent(answer,targetId);
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130367, user.getLanguage())%>");
		$("#loading123").hide();
	}
}

//转化问法.
function changeAsk(){
	$("#loading123").show();	
	$("#ueditor_0").contents().find(".view").find("*").css("font-size","");
	var answer =ue.getContent().replace(/<\/?.+?>/g,"");
	var id="<%=askid%>";
	var d=new Date();
	var date=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+" "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
	if(answer!=""){
		$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{type:'changeAsk',faqId:id,answer:answer},function(data){
			if(data.result=="success"){
				$("#loading123").hide();
				$("#answer_dtl").html("<%=ResourceComInfo.getLastname(userId+"")%> "+date);
					if(newSub==2){
						DlgARfsh(1);		
					}else{
						DlgARfsh();		
					}
			}
		});
		showContent("<%=SystemEnv.getHtmlLabelName(131431, user.getLanguage())%>："+answer);
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130367, user.getLanguage())%>");
		$("#loading123").hide();
	}
}

function openQuestion(id){
	var url = "/fullsearch/ViewFaqDetailLib.jsp?faqId="+id;
	window.open(url);
}

function showQuick(){
	inQuick=1;
	if($("#quickmenu").css("display")=="none"){
		$("#quickmenu").css("display","");
		$('#contentDiv').height(190);
	}else{
		$("#quickmenu").css("display","none");
		$('#contentDiv').height(230);
	}
}

function getQuickAnswer(){
	$.post("/fullsearch/EAssistant/ReMessage.jsp",{method:'getQuickAnswer'},function(data){
		$("#quickmenuopt").html(data);
		jQuery("#quickmenuopt").perfectScrollbar();
	});
}
function selQuickAnswer(id){
	var content=ue.getContent();
	content+=$("#c_"+id).val();
	ue.setContent(content);
	$("#quickmenu").css("display","none");
}
function cusSet(){
	var url="/systeminfo/menuconfig/CustomSetting.jsp";
	if(window.top.Dialog){
		diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 980;
	diag.Height = 600;
	diag.Modal = true;
	diag.Title = "";
	diag.URL = url;
	diag.show();
}
function otherAsk(id)
{ 
		var url = "/fullsearch/EAssistant/SendAndEdit.jsp?askid=<%=askid%>&askname=<%=ask%>&faqid="+id;
		if(window.top.Dialog){
			diag = new window.top.Dialog();
		} else {
			diag = new Dialog();
		}
		diag.currentWindow = window;
		diag.Width = 600;
		diag.Height = 260;
		diag.Modal = true;
		diag.Title = "";
		diag.URL = url;
		diag.show();     
}
var newSub=0;
function submitNew(){
	$("#content").css("display","");
	var content=$("#content_div").html();
	$("#content_div").css("display","none");
	$("#content").val(content);
	initFckEdit();
	$("#btn_div").css("display","");
	newSub=1;
	$('#contentDiv').height(190);
}

function btn_cancle(){
	if($("#btn_close").attr("undocheck")=="y"){
		try{
			window.parent.undoCheckOut();
		}catch(e){}
		try{
			window.parent.frames['notice_-1'].undoCheckOut();
		}catch(e){}
	}else{
		try{
			window.parent.closeDialog();
		}catch(e){}
		try{
			window.parent.frames['notice_-1'].closeDialog();
		}catch(e){}
	}
}

function closeDlgARfsh(flag){
	try{
		window.parent.closeDlgARfsh(flag);
	}catch(e){}
	try{
		window.parent.frames['notice_-1'].closeDlgARfsh(flag);
	}catch(e){}
}

function DlgARfsh(flag){
	try{
		window.parent.DlgARfsh(flag);
	}catch(e){}
	try{
		window.parent.frames['notice_-1'].DlgARfsh(flag);
	}catch(e){}
}

function initFckEdit(){
	ue = UE.getEditor('content',{
	    toolbars: [[
		]],
	    initialFrameHeight:"100%",
	    initialFrameWidth:"100%",
	    wordCount:false,
	    elementPathEnabled : false,
	    pasteplain:true
    });
}

var needClose=false;
//对缓存数据做json修改
function editText(){
	var content=$("#content_div").html();
	//内容为空.就是新建..
	if(content!=""){
		needClose=false;
		$("#content_div").css("display","none");
		//判断当前的
		if($('#flag_eidt').attr("targetFlag")=="8"){
			$("#instructions_area").show();
			$("#instructions_area").text(content);
			
			$("#content_cache_text_div").hide();
            $("#content_cache_content_div").hide();
            $("#content_cache_btn_div").hide();
            $("#content_cache_type").val("Instructions");
            
		}else{
			//解析json 放入字段中.
			var contentJson=JSON.parse(content);
		 
            if (contentJson && contentJson.text) {
                $("#content_cache_text").val(contentJson.text);
            } else {
                $("#content_cache_text").val("");
            }
            if (contentJson && contentJson.content) {
                $("#content_cache_content").val(contentJson.content);
            } else {
                $("#content_cache_content").val("");
            }
            if (contentJson && contentJson.status) {
                $("#content_cache_type").val(contentJson.status);
            } else {
                $("#content_cache_type").val("");
            }
		}
       
        $("#content_cache_type").selectbox("detach");
        $("#content_cache_type").selectbox();
        $("#content_cache_div").css("display","");
		$('#flag_eidt').hide();
		$('#flag_save').show();
	}else{//待处理页面过来.
		needClose=true;
		$("#content_div").css("display","none");
		$("#content").css("display","none");
		//隐藏按钮.
		$('#flag6').hide();
		$('#btn_div').hide();
		$('#contentDiv').height(230);
		//解析json 放入字段中.
		$("#content_cache_text").val("");
		$("#content_cache_content").val("");
		$("#content_cache_div").css("display","");
		$('#flag_eidt').hide();
		$('#flag_save').show();
	}
}

function changeContentCache(){
	var content=$("#content_div").html();
	if($("#content_cache_type").val() == "Instructions"){ // 选择执行指令
        $("#instructions_area").show();
		$("#content_div").hide();
        $("#content_cache_text_div").hide();
        $("#content_cache_content_div").hide();
        $("#content_cache_btn_div").hide();
        $("#instructions_area").text(content);
	}else {
		$("#instructions_area").hide();
        $("#content_div").hide();
        if(content!="") {
            //解析json 放入字段中.
            var contentJson = JSON.parse(content);
            if (contentJson && contentJson.text) {
                $("#content_cache_text").val(contentJson.text);
            }
            if (contentJson && contentJson.content) {
                $("#content_cache_content").val(contentJson.content);
            }
        }
        $("#content_cache_text_div").show();
        $("#content_cache_content_div").show();
        $("#content_cache_btn_div").show();
	}
}

function saveText(obj){
	if(obj&&$(obj)){
		var text=$(obj).attr("_defaultvalue");
		if(!text){
			text=$(obj).text();
		}
		$("#loading123").show();
		//拼接json
		var answer={};
		answer.text=text;
		answer.status="show";
		
		$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{"type":"changeText","faqId":"<%=askid%>","answer":JSON.stringify(answer),"status":answer.status},function(data){
			$("#loading123").hide();
			$("#content_cache_div").css("display","none");
			$("#content_div").html(JSON.stringify(answer));
			$("#content_div").css("display","");
			$('#flag_eidt').show();
			$('#flag_save').hide();
			if(needClose){
				closeDlgARfsh();
			}else{
				DlgARfsh(answer.status=="dealed"?'5':(answer.status=="show"?'6':'7'));
				$('#flag_eidt').attr("targetFlag",answer.status == "dealed" ? '5' : (answer.status == "show" ? '6' : '7'));
			}
		});
	}else{
		$("#loading123").show();
		//拼接json
		var answer={};
		answer.text=$("#content_cache_text").val();
		if($("#content_cache_content").val()!=""){
			answer.content=$("#content_cache_content").val();
		}
		answer.status=$("#content_cache_type").val();
		if(answer.status && answer.status == "Instructions"){ // 执行动作的保存方法
		    saveInstructions();
		}else {
            $.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp", {
                "type": "changeText",
                "faqId": "<%=askid%>",
                "answer": JSON.stringify(answer),
                "status": answer.status
            }, function (data) {
                $("#loading123").hide();
                $("#content_cache_div").css("display", "none");
                $("#content_div").html(JSON.stringify(answer));
                $("#content_div").css("display", "");
                $('#flag_eidt').show();
                $('#flag_save').hide();
                if (needClose) {
                    closeDlgARfsh();
                } else {
                    DlgARfsh(answer.status == "dealed" ? '5' : (answer.status == "show" ? '6' : '7'));
                    $('#flag_eidt').attr("targetFlag",answer.status == "dealed" ? '5' : (answer.status == "show" ? '6' : '7'));
                }
            });
        }
	}

}

String.prototype.replaceAll = function(s1,s2){  
	return this.replace(new RegExp(s1,"gm"),s2);  
} 

function saveInstructions(){
	$("#loading123").show();	
	var answer = $("#instructions_area").val();
	var id="<%=askid%>";
	var d=new Date();
	var date=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+" "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
	if(answer!=""){
		//对answer做检测
		try{
			var answerObj = eval("("+answer+")");
			if(answerObj.rc=="0"&&answerObj.text&&answerObj.text!=""){
				$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{type:'saveInstructions',faqId:id,answer:answer},function (data) {
                    $("#loading123").hide();
                    $("#content_cache_div").css("display", "none");
                    $("#content_div").html(answer);
                    $("#content_div").css("display", "");
                    $("#instructions_area").hide();
                    $('#flag_eidt').show();
                    $('#flag_save').hide();
                    if (needClose) {
                        closeDlgARfsh();
                    } else {
                        DlgARfsh('8');
                        $('#flag_eidt').attr("targetFlag",'8');
                    }
                });
			}else{
				window.top.Dialog.alert("JSON<%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>");
				$("#loading123").hide();
			}
		}catch(e){
			window.top.Dialog.alert("JSON<%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>");
			$("#loading123").hide();
		}
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130367, user.getLanguage())%>");
		$("#loading123").hide();
	}

}
</SCRIPT>
</BODY>
</HTML>
