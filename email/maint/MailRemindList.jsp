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
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
</head>

<script language="javascript">
var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
		_table. reLoad();
	}
}
 
 function editRemind(id){
 	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/MailRemindEdit.jsp?rid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,18121",user.getLanguage()) %>";
	dialog.Width = 680;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
 }
 
 
function deleteBlackList(id){
		jQuery.post("/email/MailOperation.jsp",{"bids":id,"operation":"deleteblacklist"},function(e){
			_table. reLoad();
		});
}

function enableRemind(id, e, obj){
	var children = obj.children;
	children[0].innerHTML = '&nbsp启用&nbsp';
}

</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<%
String orderBy = "id";
String backFields = " id , name,enable,content ";
String sqlFrom = " from MailReceiveRemind ";
String sqlwhere = "1=1 and id = 1 ";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getMailRemindOpratePopedom\"></popedom> ";
  // 	   operateString+="     <operate href=\"javascript:enableRemind()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:editRemind()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_Remain+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Remain,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"none\" >";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(18713, user.getLanguage())+"\" column=\"name\""+" />";
       tableString+="<col width=\"60%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(345, user.getLanguage())+"\" column=\"content\""+" />";
       tableString+="<col width=\"10%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(602, user.getLanguage())+"\"  transmethod=\"weaver.email.MailSettingTransMethod.getCheckMailReamindPopedom\" column=\"enable\""+" />";
       tableString+="</head>"+operateString; 
       tableString+="</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</body>
 
