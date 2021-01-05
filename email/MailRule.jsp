
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>

<script language="javascript">
 function  submitForRule(){
    var chk = document.getElementsByName("isActive");
	var ruleIds = "";
	for(var i=0;i<chk.length;i++){
		if(chk[i].checked){
			ruleIds += chk[i].value + ",";
		}
	}
	fMailRule.activeRuleIds.value = ruleIds;
     
     fMailRule.submit();
 }
 
 
 function deleteRule(id){
 	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
 		window.location.href = "/email/MailRuleOperation.jsp?showTop=show800&id="+id;
 	})
 }
 

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
	_table.reLoad();
}

function addInfo(){
    dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/MailRuleAdd.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,19828",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 300;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
	
}

function editInfo(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/MailRuleEdit.jsp?id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,19828",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(function(){
	jQuery('body').jNice();
});

</script>

<body>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitForRule(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
int perpage = 10;
String orderBy = "accountName";
String backFields = "t.id ,t.ruleName, t.isActive, t.accountName";
String sqlFrom = "(select a.* ,b.accountName from  MailRule a, MailAccount b "
	+" where  a.userId=b.userId AND a.userId="+user.getUID()+" AND a.mailAccountId=b.id"
	+" union select a.* , '"+SystemEnv.getHtmlLabelName(31350,user.getLanguage())+"' as accountName from MailRule a "
	+" where a.userId="+user.getUID()+" and a.mailAccountId=-1) t ";
String sqlwhere ="1=1";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getRuleOpratePopedom\"></popedom> ";
       operateString+="     <operate href=\"javascript:editInfo()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:deleteRule()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_Rule+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Rule,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"40%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(19829,user.getLanguage()) +"\" column=\"ruleName\""+
       		 " otherpara=\"column:id\" transmethod=\"weaver.email.MailSettingTransMethod.getRuleInfo\" />";
       tableString+="<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(19830,user.getLanguage()) +"\" column=\"accountName\"/>";
       tableString+="<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(18095,user.getLanguage()) +"\" column=\"id\""+
			 " otherpara=\"column:isActive\" transmethod=\"weaver.email.MailSettingTransMethod.geRuleCheckInfo\" />";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			
			<input class="e8_btn_top middle" onclick="submitForRule()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>"/>
			
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form id="fMailRule" method="post" action="MailRuleOperation.jsp">
<input type="hidden" name="operation" value="active" />
<input type="hidden" name="activeRuleIds" id="activeRuleIds" value="" />
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Rule%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
</form>
</body>

</html>
