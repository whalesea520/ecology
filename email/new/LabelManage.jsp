<%@page import="weaver.email.domain.MailLabel"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<link href="/email/css/color_wev8.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(81342, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript" src="/email/js/colorselect/jquery.colorselect_wev8.js"></script>
<script>

function doAdd(){
	getDialog("/email/new/LabelCreate.jsp?type=1","<%=SystemEnv.getHtmlLabelNames("82,176",user.getLanguage()) %>");
}

function doEdit(id){
	
	getDialog("/email/new/LabelCreate.jsp?type=3&labelid="+id,"<%=SystemEnv.getHtmlLabelNames("93,176",user.getLanguage()) %>");
}
var diag ;
function getDialog(url ,title){
	if(window.top.Dialog){
		diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	};
	diag.currentWindow = window;
	diag.Width =450;
	diag.Height =200;
	diag.Title = title;
	diag.URL = url;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
 }

function closeDialogcreateLabel() {
		diag.close();
		_table.reLoad();
}
function SaveDatecreateLabel(){
	     document.getElementById("_DialogFrame_0").contentWindow.submitDate(dlgcreateLabel);
}


function doSubmit(){
	if($.trim($("#labelname").val())==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81327,user.getLanguage()) %>")
		return;
	}
	var labelcolor= getBackgroundColor(".selectedColor");
	var labelid="";
	if($("#method").val()=="edit"){
		labelid=$("#editlableid").val()
	}
	var para ={method:$("#method").val(),labelname:$("#labelname").val(),labelcolor:labelcolor,labelid:labelid}	;
	
	$.post("/email/new/LabelManageOperation.jsp",para,function(data){
		
		if(data!='repeat'){
			Dialog.getInstance('0').close();
			document.location.reload();
		}else{
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(26603,user.getLanguage()) %>')
		}
		
	})
}


function doDel(id){	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
		var para ={method:'del',labelid:id};
		
		$.post("/email/new/LabelManageOperation.jsp",para,function(){
			_table.reLoad();
		})	
	})
}


function doClearLabel(id) {
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83089,user.getLanguage())%>',function(){
		var param = {'method': 'clear', 'labelid': id};
		$.get("/email/new/LabelManageOperation.jsp", param, function(){
			_table.reLoad();
		});
	});
}


</script>


<%
int perpage = 10;
String orderBy = "t.name";
String backFields = "t.*";
String sqlFrom = "(select a.*,b.allcount,c.noreadcount from email_label a left join "+
		"( select labelid,COUNT(t1.id) as allcount from email_label_detail t1, MailResource t2 WHERE t1.mailid = t2. ID AND t2.canview = 1 group by labelid) b on a.id = b.labelid  "+
		"	left join (select t3.labelid,count(t3.id) as noreadcount from (select t1.*  from email_label_detail t1 ,MailResource t2  where t1.mailid =t2.id  and t2.status = 0 and t2.canview=1) t3  group by t3.labelid) c on a.id = c.labelid where accountid = "
	+ user.getUID() + ") t ";
String sqlwhere ="1=1";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getLabelOpratePopedom\"></popedom> ";
       operateString+="     <operate href=\"javascript:doEdit()\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:doClearLabel()\" text=\""+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
   	   operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
   	   operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_Label+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Label,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(81323,user.getLanguage()) +"\" column=\"name\" "+
       	" otherpara=\"column:color\"	transmethod=\"weaver.email.MailSettingTransMethod.geLabelManageInfo\" />";
       tableString+="<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(27603,user.getLanguage()) +"\" column=\"noreadcount\" "+
       " transmethod=\"weaver.email.MailSettingTransMethod.getCount\"/>";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(81315,user.getLanguage()) +"\" column=\"allcount\" "+
       " transmethod=\"weaver.email.MailSettingTransMethod.getCount\" />";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			
			<input class="e8_btn_top middle" onclick="javascript:doAdd()" type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Label%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 




