<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int msgLabelId = Util.getIntValue(request.getParameter("msgLabelId"));

String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage());
if(msgLabelId!=-1){
	titlename += " <span style='color:red;font-weight:bold'>" + SystemEnv.getHtmlLabelName(msgLabelId,user.getLanguage()) + "</span>";
}

%>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>

<script language="javascript">
var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
		_table. reLoad();
	}
}
  
 function addInfo(){    
    dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/new/MailBlackListAdd.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(83100,user.getLanguage())%>";
	dialog.Width = 480;
	dialog.Height = 170;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
 }
 
function deleteBlackList(id){
		jQuery.post("/email/MailOperation.jsp",{"bids":id,"operation":"deleteblacklist"},function(e){
			_table. reLoad();
		});
}

function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(id==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83062,user.getLanguage())%>？",function(){
		id = id.substring(0,id.length-1);
		deleteBlackList(id);
	});
	
}

</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDelete(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<%
String orderBy = "id";
String backFields = "id , name,postfix";
String sqlFrom = "from MailBlacklist";
String sqlwhere = "userId = "+user.getUID();
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getBlacklistOpratePopedom\"></popedom> ";
   	   operateString+="     <operate href=\"javascript:deleteBlackList()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_BlackList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_BlackList,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(19805,user.getLanguage()) +"\" column=\"name\""+" />";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(83101,user.getLanguage())+"\" column=\"postfix\""+" />";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>


<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_BlackList%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</body>
 
