<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
//会议提醒模板
if(!HrmUserVarify.checkUserRight("Meeting:Remind", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}


int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String usertype=user.getLogintype();


    
String perpage="20";

String sqlwhere=" where 1=1 ";
String backFields = " t1.*,t2.name,t3.name as modename  ";
String sqlFrom = " meeting_remind_template t1 join meeting_remind_type t2 on t1.type=t2.id join meeting_remind_mode t3 on t1.modetype=t3.type ";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"meetingRemindTable\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18713,user.getLanguage())+"\" column=\"name\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(82212,user.getLanguage())+"\" column=\"modename\" />"+
					  "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(18693,user.getLanguage())+"\" column=\"body\"/>"+
			  "</head>";
tableString +=  "<operates>"+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"</operates>";
tableString += "</table>";
        

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32640,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

//RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:viewDetail(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:viewDetail(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<!--  <input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="viewDetail(-1)"/> -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<form>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</td>
</tr>
</table>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript">


var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function doSubmit()
{
	_table.reLoad();
}

function closeDlgARfsh(){
	diag_vote.close();
	_table.reLoad();
}


function viewDetail(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(30425,user.getLanguage())%>";
	diag_vote.URL = "/meeting/defined/commonTab.jsp?_fromURL=RemindInfo&id="+id;
	diag_vote.show();
}       
       
</script>

</html>
